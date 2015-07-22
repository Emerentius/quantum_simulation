initialise_constants;

tr = Transistor(0.5, ...    % V_ds
                0.0, ...    % V_g
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
                'self_consistency_limit', 1e-3); % eV
           
V_g_range = 0.0 : 0.05 : 0.7;
charge = zeros(length(V_g_range), 1);

fig_phi = figure;
hold on;
fig_carrier_dens = figure;
hold on;

counter = 1;
for V_g = V_g_range;
    tr.set_V_g(V_g);
    %disp(tr.make_self_consistent);
    tr.compute_DOS_and_related;
    
    tr.plot_phi(fig_phi);
    tr.plot_carrier_density(fig_carrier_dens);
    
    charge(counter) = tr.charge_gate;
    counter = counter + 1;
end

figure;
plot(V_g_range, charge);
capacitance = -helper.derivative(charge, 0.05);
figure;
plot(V_g_range(2:end-1), capacitance);