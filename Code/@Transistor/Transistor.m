classdef Transistor < handle
    % Default material properties for silicon
    properties (GetAccess = public, SetAccess = protected)
        source
        gate
        drain
        a
        V_ds % drain-source voltage
        V_g  % gate voltage
        geometry = 'single gate'
        T = 300 % K
        m = 0.2 * 9.10938291e-31 % 0.2 * m_e
        E_min = []
        E_max = []
        n_energy_steps
        dE = 5e-4; % eV, mutually exclusive with n_energy_steps, checks are done in constructor
        E_f = 0.1 % == 0.1eV above conduction band in source
        E_g = 1.14
        transmission_probability
        d_ch
        d_ox
        eps_ch = 11.2
        eps_ox = 3.9
        lambda
        lambda_ds = '1 lambda' % in lambda_ch
        carrier_charge_in_e = -1
        current
        newton_step_size = 0.3 % part of delta phi that is taken in one newton-step
        self_consistency_limit = 1e-3 % eV, self-consistency reached when max(abs(delta_phi)) <= self_consistency_limit
    end
    
    properties (Access = protected)
        %% private flags to not unnecessarily recalculate data 
        is_self_consistent = false
        phi_changed_since_DOS_calculation = true
        current_is_up_to_date = false
    end
    %%
    methods
        %% Constructor
        function obj = Transistor(V_ds, V_g, d_ch, d_ox, a, varargin)
            initialise_constants;            
            %%%%%%%%%%%% Further default values %%%%%%%%%%%%
            l_ch_def = '5 lambda';
            l_ds_def = '5 lambda'; % in lambda_ds
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            %% parse input
            p = inputParser;
            % helper functions
            is_numeric_scalar = @(x) isnumeric(x) && isscalar(x);
            is_numeric_scalar_or_string = @(x) is_numeric_scalar(x) || ischar(x);
            is_empty_or_numeric_scalar = @(x) isempty(x) || is_numeric_scalar(x);
            
            % required arguments
            addRequired(p, 'V_ds', is_numeric_scalar);
            addRequired(p, 'V_g',  is_numeric_scalar); 
            addRequired(p, 'd_ch', is_numeric_scalar);
            addRequired(p, 'd_ox', is_numeric_scalar);
            addRequired(p, 'a',    is_numeric_scalar);

            % overrides
            % amount of steps between E_max and E_min (integration)
            addOptional(p, 'n_energy_steps', [],is_empty_or_numeric_scalar);
            % step size between E_max and E_min (mutually exclusive with
            % n_energy_steps
            % exclusivity is checked down below
            addOptional(p, 'dE', [], is_empty_or_numeric_scalar);
            addOptional(p, 'E_g', obj.E_g, is_numeric_scalar);
            addOptional(p, 'E_f', obj.E_f, is_numeric_scalar);
            addOptional(p, 'eps_ox', obj.eps_ox, is_numeric_scalar);
            addOptional(p, 'eps_ch', obj.eps_ch, is_numeric_scalar);
            addOptional(p, 'geometry', obj.geometry); % validation in lambda_by_geometry
            addOptional(p, 'lambda_ds', obj.lambda_ds, is_numeric_scalar_or_string); 
            addOptional(p, 'l_ch', l_ch_def, is_numeric_scalar_or_string);
            addOptional(p, 'l_ds', l_ds_def, is_numeric_scalar_or_string);
            addOptional(p, 'm', obj.m, is_numeric_scalar);
            addOptional(p, 'T', obj.T, is_numeric_scalar);
            addOptional(p, 'newton_step_size', obj.newton_step_size, is_numeric_scalar);
            addOptional(p, 'self_consistency_limit', obj.self_consistency_limit, is_numeric_scalar);
            addOptional(p, 'dopant_type', 'n', @(x) all(lower(x) == 'p') || all(lower(x) == 'n'));
            addOptional(p, 'E_max', [], is_numeric_scalar);
            addOptional(p, 'E_min', [], is_numeric_scalar);
            
            % parse input as described
            parse(p, V_ds, V_g,  d_ch, d_ox, a, varargin{:});
            
            % check exclusivity of dE and n_energy_steps
            if ~isempty(p.Results.dE) && ~isempty(p.Results.n_energy_steps)
                % Two values specified => error due to mutual exclusiveness
                error('n_energy_steps and dE are mutually exclusive parameters');
            elseif ~isempty(p.Results.dE) % n_energy_steps empty
                obj.dE = p.Results.dE; % overwrite default with given dE
            elseif ~isempty(p.Results.n_energy_steps) % dE empty
                obj.dE = []; % delete default value
                obj.n_energy_steps = p.Results.n_energy_steps;
            end 
            % else both empty => keep default
            
            %% read some input into variables that are needed multiple times
            eps_ox = p.Results.eps_ox;
            eps_ch = p.Results.eps_ch;
            geometry = p.Results.geometry;
            
            %% pre-initialisation work
            % lambda inside channel
            lambda = helper.lambda_by_geometry(d_ch, d_ox, eps_ch, eps_ox, geometry);
            % Parse inputs that are either numeric or a string like '3.2 lambda'
            lambda_ds = helper.parse_numeric_or_string(p.Results.lambda_ds, lambda);
            
            %% determine ranges
            l_ch = helper.parse_numeric_or_string(p.Results.l_ch, lambda);
            l_ch = helper.possible_length(l_ch, a);
            % l_ds is dependent upon lambda_ds
            l_ds = helper.parse_numeric_or_string(p.Results.l_ds, lambda_ds);
            l_ds = helper.possible_length(l_ds, a);

            n_ds = helper.n_lattice_points(l_ds,a);
            n_ch = helper.n_lattice_points(l_ch,a);

            % range start and end
            range_source  = {1           , n_ds };
            range_gate    = {n_ds+1      , n_ds+n_ch };
            range_drain   = {n_ds+n_ch+1 , 2*n_ds+n_ch };
                        
            %% Initialize properties
            
            % p or n-type
            switch(lower(p.Results.dopant_type))
                case {'n'}
                    obj.carrier_charge_in_e = -1;
                case {'p'}
                    obj.carrier_charge_in_e = 1;
                otherwise
                    error('shit bug in dopant_type');
            end
            %
            
            obj.source = Region(range_source{:});
            obj.gate   = Region(range_gate{:});
            obj.drain  = Region(range_drain{:});
            obj.lambda_ds = lambda_ds;
            obj.lambda = lambda;
            obj.d_ch = d_ch;
            obj.d_ox = d_ox;
            obj.eps_ch = eps_ch;
            obj.eps_ox = eps_ox;
            obj.E_g = p.Results.E_g;
            obj.E_f = p.Results.E_f;
            obj.E_max = p.Results.E_max;
            obj.E_min = p.Results.E_min;
            obj.V_ds = V_ds;
            obj.V_g = V_g;
            obj.m = p.Results.m;
            obj.a = a;
            obj.geometry = geometry;
            obj.T = p.Results.T;
            obj.newton_step_size = p.Results.newton_step_size;
            obj.self_consistency_limit = p.Results.self_consistency_limit;
            
            %% Calculate some data from the above
            obj.set_phi(obj.poisson());
            %obj.initialise_phi_carrier_density_DOS();
        end
        
        % dependencies:
        % E_f
        % V_ds
        % phi
        % carrier_charge_in_e
        % T
        function E_max_ = get.E_max(obj)
            if ~isempty(obj.E_max)
                E_max_ = obj.E_max;
            else
                % in eV already!!
                k_B = 8.6173324e-5;
                E_max_ = max([obj.E_f_source, obj.source.phi(1), max(obj.gate.phi), obj.E_f_drain, obj.drain.phi(end)]);
                if sign(obj.carrier_charge_in_e) == -1
                    E_max_ = E_max_ + 5*k_B*obj.T;
                end
            end
        end
     
        function E_min_ = get.E_min(obj)
            if ~isempty(obj.E_min)
                E_min_ = obj.E_min;
            else
                k_B = 8.6173324e-5;
                E_min_ = min([obj.E_f_source, obj.source.phi(1), min(obj.gate.phi), obj.E_f_drain, obj.drain.phi(end)]);
                if sign(obj.carrier_charge_in_e) == 1
                    E_min_ = E_min_ - 5*k_B*obj.T;
                end
            end
        end
        
            
        
        function dE_ = get.dE(obj)
            if ~isempty(obj.dE)
                dE_ = obj.dE;
            else 
                if isempty(obj.n_energy_steps)
                    error('You need to specify either dE or n_energy_steps before accessing .dE');
                end
                dE_ = (obj.E_max - obj.E_min)/obj.n_energy_steps;                     
            end
        end
        
        function n_steps = get.n_energy_steps(obj)
            if ~isempty(obj.n_energy_steps)
                n_steps = obj.n_energy_steps;
            else
                n_steps = length(obj.energy_range) - 1; % inefficient, but robust. Should be changed regardless.
            end
        end
        
        function current_ = get.current(obj)
            if ~obj.current_is_up_to_date
                obj.compute_DOS_and_related;
            end
            current_ = obj.current;
        end
    end
end
