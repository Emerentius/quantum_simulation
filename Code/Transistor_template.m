%% This shows an instantiation of a transistor with every possible variable defined
%  Leaving nothing to default values
initialise_constants;

tr = Transistor(0.5, ...    % V_ds
                0.7, ...    % V_g
                3,   ...    % d_ch
                3,   ...    % d_ox
                0.5, ...    % a
                'm',         0.2*m_e,      ...
                'E_f',       0.15,         ... % eV
                'l_ch',      25,           ...
                'dE',        5e-4,         ... % alternatively: n_energy_steps
                'T',         300,          ...
                'eps_ch',    eps_si,       ...
                'eps_ox',    eps_sio2,     ...
                'l_ds',      '7 lambda',   ...
                'E_g',       1,            ... % eV
                'lambda_ds', '1 lambda',   ... % multiple of lambda_ch
                'geometry',  'nano-wire',  ...
                'newton_step_size', 0.3,   ...   
                'self_consistency_limit', 1e-3, ... % eV
                'dopant_type', 'n', ...
                ... %'E_min', 1, ...    % leave out for automatic, adaptive energy
                ... %'E_max', -0.5, ... % depending on E_f, V_ds, and phi
                'coupling_left', 1, ...
                'coupling_right', 1, ...
                'eta', 1e-8 ...
                );