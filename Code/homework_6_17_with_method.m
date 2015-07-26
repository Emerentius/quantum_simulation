%clear all;
%close all;
initialise_constants
%% input parameters and transistor instantiation
tr = Transistor(0.5, ...    % V_ds
                0.0, ...    % V_g
                3,   ...    % d_ch
                3,   ...    % d_ox
                0.5, ...    % a
                'm',         0.2*m_e,      ...
                'E_f',       0.15,         ... % eV
                'l_ch',      25,           ...
                'dE',        5e-4,         ...
                'T',         300,          ...
                'eps_ch',    eps_si,       ...
                'eps_ox',    eps_sio2,     ...
                'l_ds',      '7 lambda',   ...
                'E_g',       1,            ... % eV
                'lambda_ds', '1 lambda',   ... % multiple of lambda_ch
                'geometry',  'nano-wire',  ...
                'newton_step_size', 0.3,   ...   
                'self_consistency_limit', 1e-3); % eV
            
% step size of newton raphson
MAX_ITERATIONS = 15;
%%
V_g_range = 0.0 : 0.05 : 0.7;
[fig, current, subthr_slope, iterations] = tr.plot_transfer_characteristic(V_g_range);
iterations
subthr_slope% = helper.subthreshold_slope(V_g_range, current)
