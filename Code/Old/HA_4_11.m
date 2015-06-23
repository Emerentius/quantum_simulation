%
% Function to calculate density is in carrier_density.m
%
clear all;
close all;
initialise_constants
profile on

%% input parameters
m = 0.2*m_e;
l = 40*nm;
a = 0.02*nm;
d_ch = 2*nm;
d_ox = 5*nm;

l_ch = l/4+a;
l_ds = 3*l/8;

T = 300;

V_ds = -0.7;
V_g = 0;

E_f = 0.15*eV;

n_steps = 10000;
%%

n_ges = floor(l/a);

phi = poisson(V_ds,V_g,d_ch, d_ox, 'a', a, 'l_ch', l_ch, 'l_ds', l_ds, 'geometry', 'nano-wire');
density = carrier_density(phi,a, E_f, E_f+V_ds*eV, 'm', m, 'n_steps', n_steps, 'T', T);

x_ch_start = l_ds;
x_ch_end = x_ch_start + l_ch;
density_ch = density(x_ch_start/a:x_ch_end/a);
Q_ch = sum(density_ch) * a;

x_pos = 0:a:l-a;
%figure(1);
figure('name', 'carrier density');
plot(x_pos(1:n_ges)/nm, density)
xlabel('Position [nm]');
ylabel('Carrier density [??]');

profile off
profile viewer
