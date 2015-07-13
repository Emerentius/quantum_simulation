classdef Transistor < handle
    properties (GetAccess = public, SetAccess = protected)
        source
        gate
        drain
        a
        V_ds
        V_g % gate voltage
        geometry
        T
        m
        n_energy_steps
        dE
        E_f
        E_g
        transmission_probability
        d_ch
        d_ox
        eps_ch
        eps_ox
        lambda
        lambda_ds
    end
    
    properties (Access = protected)
        %% private flags to not unnecessarily recalculate data 
        is_self_consistent = false
        phi_changed_since_DOS_calculation
    end
    %%
    methods
        %% Constructor
        function obj = Transistor(V_ds, V_g, d_ch, d_ox, a, varargin)
            initialise_constants;            
            %%%%%%%%%%%% default values %%%%%%%%%%%%%%%%%%%
            % Silizium
            E_f_def = 0.1;
            E_g_def = 1;
            eps_ox_def = eps_sio2;
            eps_ch_def = eps_si;
            m_def = m_e; % note: this isn't silicon
            lambda_ds_def = '1 lambda'; % in lambda_ch
            l_ch_def = '5 lambda';
            l_ds_def = '5 lambda'; % in lambda_ds
            T_def = 300; % K
            geometry_def = 'single gate';
            expected_geometry = {'single gate','double gate','triple gate', 'tri-gate', 'nano-wire', 'nanowire'};
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
            addOptional(p, 'E_g', E_g_def, is_numeric_scalar);
            addOptional(p, 'E_f', E_f_def, is_numeric_scalar);
            addOptional(p, 'eps_ox', eps_ox_def, is_numeric_scalar);
            addOptional(p, 'eps_ch', eps_ch_def, is_numeric_scalar);
            addOptional(p, 'geometry', geometry_def, @(x) any(validatestring(x,expected_geometry)) );
            addOptional(p, 'lambda_ds', lambda_ds_def, is_numeric_scalar_or_string); 
            addOptional(p, 'l_ch', l_ch_def, is_numeric_scalar_or_string);
            addOptional(p, 'l_ds', l_ds_def, is_numeric_scalar_or_string);
            addOptional(p, 'm', m_def, is_numeric_scalar);
            addOptional(p, 'T', T_def, is_numeric_scalar);
            
            % parse input as described
            parse(p, V_ds, V_g,  d_ch, d_ox, a, varargin{:});
            
            % check exclusivity of dE and n_energy_steps
            if ~isempty(p.Results.dE) && ~isempty(p.Results.n_energy_steps)
                error('n_energy_steps and dE are mutually exclusive parameters');
            end

            %% read some input into variables that are needed multiple times
            E_f = p.Results.E_f;
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
            obj.E_f = E_f;
            obj.V_ds = V_ds;
            obj.V_g = V_g;
            obj.m = p.Results.m;
            obj.a = a;
            obj.n_energy_steps = p.Results.n_energy_steps; % exclusivity already checked
            obj.dE = p.Results.dE;
            obj.geometry = geometry;
            obj.T = p.Results.T;
            
            %% Calculate some data from the above
            obj.initialise_phi_carrier_density_DOS();
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
    end
end
