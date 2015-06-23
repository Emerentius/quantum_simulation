%
% Function to calculate density is in carrier_density.m
%
clear all;
close all;
initialise_constants
%profile on
%% input parameters
m = 0.2*m_e;
%l = 50*nm;
a = 0.2*nm;

l_ch = possible_length(10*nm, a);
% l_ds defined further down
%l_ds = '5 lambda'; %possible_length(3*l/8, a);

d_ch = 5*nm;
d_ox = 1*nm;

area_ch = pi/4*d_ch^2;

eps_ch = eps_si;
eps = eps_ch;

T = 300;

% TODO: clean up E_f distinctions
E_f = 0.2*eV;
% E_f for dopant density (E_f for drain and source)
% TODO: distinction sound?
E_f_N = E_f;
N_STEPS = 1000;

% CORRECT
E_g = 1*eV;
E_f_ch = E_f;

V_ds = -0.5; %-0.7;
V_g = 0;%1; %E_g/e/2;

% step size of newton raphson
step_size = 0.3; % of full delta phi

plot_every = 10;
% how often to repeat newton-raphson
% stop on first condition reached
REPS = plot_every * 1;
LIMIT_DELTA_PHI = 1e-3 * eV;

%% LAMBDA
% NOTE: changed to multiple
lambda = lambda_nanowire(d_ch,d_ox,3.9,11.2);
lambda_ds = 0.3*lambda;
l_ds = 50*lambda_ds;
%%
n_ds = n_lattice_points(l_ds, a);
n_ch = n_lattice_points(l_ch, a);
n_ges = n_ch + 2*n_ds;  %floor(l/a);

%NOTE: changed to eV
%phi = poisson(V_ds,V_g,d_ch, d_ox, 'a', a, 'l_ch', l_ch, 'l_ds', l_ds, 'lambda_ds', lambda_ds, 'geometry', 'nano-wire');
phi_eV = poisson(V_ds,V_g,d_ch, d_ox, 'a', a, 'l_ch', l_ch, 'l_ds', l_ds, 'lambda_ds', lambda_ds, 'geometry', 'nano-wire')/e;

%phi_bi = E_f_ch + E_g/2;
%phi_g = -V_g*e; 
phi_bi_eV = (E_f_ch + E_g/2)/e;
phi_g_eV = -V_g;

% define ranges
rg_ds_left = 1:n_ds;
rg_ch = n_ds+1:n_ds+n_ch;
rg_ds_right = n_ds+n_ch+1:n_ges;

hold on;
%plot(phi/e);
plot(phi_eV);

%% TODO: Funktion anpassen
for i=1:REPS
    %% TODO: return correct dimension, so factor of a is not necessary
    density = carrier_density(phi_eV*eV,a, E_f, E_f+V_ds*e, 'm', m, 'n_steps', N_STEPS, 'T', T)  * a;
    %% CORRECT?
    density = density/area_ch;
    
    % calc new phi
    %delta_phi = update_phi(V_ds, d_ch, eps_ch, eps, phi, phi_bi, phi_g, density, a, lambda_ds, lambda, rg_ds_left, rg_ch, rg_ds_right, E_f_N, T, m);
    delta_phi_eV = update_phi_eV(V_ds, d_ch, eps_ch, eps, phi_eV, phi_bi_eV, phi_g_eV, density, a, lambda_ds, lambda, rg_ds_left, rg_ch, rg_ds_right, E_f_N, T, m);
    if max(abs(delta_phi_eV)) < LIMIT_DELTA_PHI
        i % print i
        break
    end
    %phi = phi+step_size*delta_phi;
    phi_eV = phi_eV+step_size*delta_phi_eV;
    if mod(i,plot_every) == 0
        figure(1);
        %plot(phi/e);
        plot(phi_eV);
        figure(2);
        plot(density);
    end
end

%plot(phi);

% % %% J
% % side_diag = ones(n_ges,1) .* (1/a^2);
% % mid_diag(rg_ds_left, 1) = -2/a^2 - 1/lambda_ds^2;
% % mid_diag(rg_ch, 1)= -2/a^2 - 1/lambda^2;
% % mid_diag(rg_ds_right, 1) = -2/a^2 - 1/lambda_ds^2;
% % mid_diag = mid_diag + density .* (e/k_b/T/eps_0/eps);
% % 
% % %mid_diag = ones(n_ges,1) .* (-2/a^2 - 1/lambda^2) + e/eps_0/k_B/T .* phi;
% % J = spdiags( [side_diag, mid_diag, side_diag], [1,0,-1], n_ges, n_ges);
% % J(1,2) = 2/a^2;
% % J(n_ges, n_ges - 1) = 2/a^2;
% % %% F
% % % first term d^2?/dx^2
% %     F(1,1) = 2*( phi(2) - phi(1) )/a^2;
% %     F(n_ges,1) = 2*( phi(n_ges-1) - phi(n_ges) )/a^2;
% %     for i = 2:n_ges-1
% %         F(i,1) = (phi(i-1)-2*phi(i)+phi(i+1))/a^2;
% %     end
% % 
% % % second term ?/?^2 
% %     phi_tmp = phi;
% % 
% %     % drain source
% %     phi_tmp(rg_ds_left) = phi_tmp(rg_ds_left) / lambda_ds^2;
% %     phi_tmp(rg_ds_right) = (phi_tmp(rg_ds_right) - e*V_ds )/ lambda_ds^2;
% %     % channel
% %     phi_tmp(rg_ch) = (phi_tmp(rg_ch) - phi_bi - phi_g) / lambda^2;
% % 
% %     F = F - phi_tmp;
% %     
% % % third term e(?-N)/?
% %     dop_dens = dopant_density(E_f_N,m)/area_ch;
% %     N(rg_ds_left, 1) = dop_dens;
% %     N(rg_ds_right, 1) = dop_dens;
% % 
% %     F = F - (e/eps_0/eps_ch)*(density-N);
% % %%
% % delta_phi = -J\F;
% % phi_neu = 0.3*delta_phi + phi;

%%
%x_pos = 0:a:l-a;
%figure(1);
%figure('name', 'carrier density');
%plot(x_pos(1:n_ges)/nm, density)
%xlabel('Position [nm]');
%ylabel('Carrier density [??]');

%profile off
%profile viewer