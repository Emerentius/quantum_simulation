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

CNT64 = Nanotube(6,4);
CNT72 = Nanotube(7,2);
CNT62 = Nanotube(6,2);
CNT54 = Nanotube(5,4);

CNTs = [CNT64, CNT72, CNT62, CNT54];
%%

for CNT = CNTs
    %disp(CNT.band_gap)
    %disp(CNT.effective_mass/m_e);
    disp(CNT.diameter);
end
%minimum_length = 4*helper.lambda_by_geometry(3, 1, 3,9