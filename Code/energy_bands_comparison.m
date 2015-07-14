%% Compare results with Benedikt
close all;
clear all;

CNT02 = Nanotube(0,2);
CNT21 = Nanotube(2,1);
CNT44 = Nanotube(4,4);

fig02 = CNT02.plot_energy_bands;
fig21 = CNT21.plot_energy_bands;
fig44 = CNT44.plot_energy_bands;
savefig(fig02, '0_2.fig');
savefig(fig21, '2_1.fig');
savefig(fig44, '4_4.fig');
saveas(fig02, '0_2.png', 'png');
saveas(fig21, '2_1.png', 'png');
saveas(fig44, '4_4.png', 'png');