%
% Function to calculate density is in carrier_density.m
%
clear all;
close all;
initialise_constants
profile on

%% input parameters
m = 0.2*m_e;
l = 50*nm;
a = 0.02*nm;

T = 0;

V_ds = -0.7;

E_f = 0.2*eV;

n_steps = 10000;
%%

n_ges = floor(l/a);

phi = poisson(V_ds,0,5*nm, 1*nm, 'a', a, 'l_ch', l/4+a, 'l_ds', 3*l/8, 'geometry', 'nano-wire');
density = carrier_density(phi,a, E_f, E_f+V_ds*eV, 'm', m, 'n_steps', n_steps, 'T', T);

x_pos = 0:a:l-a;
%figure(1);
figure('name', 'carrier density');
plot(x_pos(1:n_ges)/nm, density)
xlabel('Position [nm]');
ylabel('Carrier density [??]');

profile off
profile viewer