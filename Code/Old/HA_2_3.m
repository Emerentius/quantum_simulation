close all;

V_ds = 0.5; %V
V_g_max = 1; %V
steps = 100;
V_G = 0:V_g_max / steps : V_g_max - V_g_max / steps;
T = 300;
d_ox = 5;
d_ch = 5;
E_f = 0.15;

lens_ch = [15, 20, 50, 100]; % nm
hold on
logI = current_gate_control_characteristic(steps, 'log', T, -V_ds, -V_g_max, d_ch, d_ox, 'E_f', E_f, 'l_ch', '12 lambda');
plot( V_G, logI );
subthreshold_slope(5) = ( V_G(11)-V_G(1) )/ ( logI(11) - logI(1) );

for i=1:4
    % all gate voltages
    logI = current_gate_control_characteristic(steps, 'log', T, -V_ds, -V_g_max, d_ch, d_ox, 'E_f', E_f, 'l_ch', lens_ch(i));
    plot( V_G , logI );
    subthreshold_slope(i) = ( V_G(11)-V_G(1) )/ ( logI(11) - logI(1) );
end
hold off
disp(subthreshold_slope);