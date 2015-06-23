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
        n_energy_steps
    end
    
    properties (Access = protected)
        self_consistent = false
        %% private flag to not unnecessarily recalculate data 
        phi_changed_since_DOS_calculation
    end
    %%
    methods
        %% Constructor
        function obj = Transistor(V_ds, V_g, d_ch, d_ox, a, varargin)
            initialise_constants;
            import Transistor.Region.*;
            
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

            % required arguments
            addRequired(p, 'V_ds', is_numeric_scalar);
            addRequired(p, 'V_g',  is_numeric_scalar); 
            addRequired(p, 'd_ch', is_numeric_scalar);
            addRequired(p, 'd_ox', is_numeric_scalar);
            addRequired(p, 'a',    is_numeric_scalar);
            addOptional(p, 'n_energy_steps', is_numeric_scalar);

            % overrides
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

            %% read some input into variables that are needed multiple times
            E_g = p.Results.E_g;
            E_f = p.Results.E_f;
            eps_ox = p.Results.eps_ox;
            eps_ch = p.Results.eps_ch;
            m = p.Results.m;
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
            obj.source = SourceDrain(eps_ch, E_f, E_g, m, lambda_ds, range_source{:});
            obj.gate   = Gate(d_ch, d_ox, eps_ch, eps_ox, E_f, E_g, m, lambda, range_gate{:});
            obj.drain  = SourceDrain(eps_ch, E_f, E_g, m, lambda_ds, range_drain{:});
            obj.V_ds = V_ds;
            obj.V_g = V_g;
            obj.a = a;
            obj.n_energy_steps = p.Results.n_energy_steps;
            obj.geometry = geometry;
            obj.T = p.Results.T;
            
            %% Calculate some data from the above
            obj.set_phi(obj.poisson());
            obj.compute_carrier_density_and_DOS();
        end
    end
end
