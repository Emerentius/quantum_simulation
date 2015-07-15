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
V_g_range = 0.0: 0.05 : 0.7;
phi_fig = figure;
hold on;
iterations_counter = 0;
for Vgjj = [V_g_range; 1:length(V_g_range)]
    V_g = Vgjj(1);
    jj = Vgjj(2);
    tr.set_V_g(V_g);
    iterations = tr.make_self_consistent(MAX_ITERATIONS);
    disp(iterations);
    iterations_counter = iterations_counter + iterations;
    I(jj) = tr.current;
    %if V_g >= 0.5 
    tr.plot_phi(phi_fig);
    %end
end
disp(['total iterations:' num2str(iterations_counter)]);
figure
plot(V_g_range, I);
xlabel('V_g [V]');
ylabel('I [A]');
set(gca, 'yscale', 'log');