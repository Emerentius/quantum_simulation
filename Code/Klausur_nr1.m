initialise_constants;

tr_low = Transistor(0.5, ...    % V_ds
                0.0, ...    % V_g
                3,   ...    % d_ch
                1,   ...    % d_ox
                0.5, ...    % a
                'm',         0.02*m_e,      ...
                'E_f',       0.3,         ... % eV
                'l_ch',      20,           ...
                'dE',        5e-4,         ... % alternatively: n_energy_steps
                'T',         300,          ...
                'eps_ch',    eps_si,       ...
                'eps_ox',    eps_sio2,     ...
                'l_ds',      '12 lambda',   ...
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
            
tr_high = Transistor(0.5, ...    % V_ds
                0.0, ...    % V_g
                3,   ...    % d_ch
                1,   ...    % d_ox
                0.5, ...    % a
                'm',         0.2*m_e,      ...
                'E_f',       0.3,         ... % eV
                'l_ch',      20,           ...
                'dE',        5e-4,         ... % alternatively: n_energy_steps
                'T',         300,          ...
                'eps_ch',    eps_si,       ...
                'eps_ox',    eps_sio2,     ...
                'l_ds',      '12 lambda',   ...
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
            
%%
dV_g = 0.05;
V_g_range = 0 : dV_g : 0.8;

Q_low = [];
Q_high = [];

for V_g = V_g_range
    tr_low.set_V_g(V_g);
    tr_high.set_V_g(V_g);
    
    disp(tr_low.make_self_consistent)
    tr_high.make_self_consistent;
    
    Q_low(end+1) = -tr_low.charge_gate; % TO MAKE POSITIVE
    Q_high(end+1) = -tr_high.charge_gate;
end
%%
capacitance_low = helper.derivative(Q_low, dV_g);
capacitance_high = helper.derivative(Q_high, dV_g);
fig_Q = figure;
hold on;
plot(V_g_range, Q_low);
plot(V_g_range, Q_high);

fig_cap = figure;
hold on;
plot(V_g_range(2:end-1), capacitance_low);
plot(V_g_range(2:end-1), capacitance_high);
line([0.05, 0.75], [8.5e-18 8.5e-18]);