clear all;
close all;

import Transistor.Transistor;
initialise_constants;
%profile on;
%% input parameters and transistor instantiation
tr = Transistor(0.3, ...    % V_ds
                0.7, ...   % V_g
                5,   ...    % d_ch
                5,   ...    % d_ox
                0.5, ...    % a % 0.2
                ...%'n_energy_steps', 1000, ...
                'dE', 5e-4, ...
                'm',         0.2*m_e,      ...
                'T',         300,          ...
                'eps_ch',    eps_si,       ...
                'eps_ox',    eps_sio2,     ...
                'l_ch',      15,        ...
                'l_ds',      10,  ...
                'E_f',       0.2,          ... % eV
                'E_g',       1,            ... % eV
                'lambda_ds', '0.3 lambda', ... % multiple of lambda_ch
                'geometry',  'nano-wire');

% step size of newton raphson
NEWTON_STEP_SIZE = 0.4; % of full delta phi

plot_every = 10;
% how often to repeat newton-raphson
% stop on first condition reached
REPS = plot_every * 4;
LIMIT_DELTA_PHI = 1e-3;
%LIMIT_DELTA_PHI = 1e-3;

compute_self_consistent = 1;
%%


if ~compute_self_consistent
    tr.carrier_density();
    tr.plot_phi;
    delta_phi = tr.update_phi(NEWTON_RAPHSON_STEP_SIZE);
    plot(delta_phi);
    tr.plot_carrier_density;
else
    fig_phi = figure();
    hold on;
    fig_carrier_density = figure();
    hold on;
    for i=0:REPS
        % calc new phi
        delta_phi = tr.update_phi(NEWTON_STEP_SIZE);
        
        max_delta_phi = max(abs(delta_phi));
        disp(max_delta_phi);
        if max_delta_phi < LIMIT_DELTA_PHI
            i % print i
            tr.plot_phi(fig_phi);
            tr.plot_carrier_density(fig_carrier_density);
            break
        end

        if mod(i,plot_every) == 0
            tr.plot_phi(fig_phi);
            tr.plot_carrier_density(fig_carrier_density);
        end
    end
end
 
% tr.compute_self_consistent_phi(NEWTON_STEP_SIZE, LIMIT_DELTA_PHI, 50)
% tr.plot_phi();

%plot(tr.poisson());
%profile off
%profile viewer