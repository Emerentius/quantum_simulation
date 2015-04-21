close all;
clear;
hold on
i = 1;
for voltage=0.1:0.01:0.2
    comp_voltage = compute_modified_poisson(-voltage, 0, 30, 'geometry', 'nano-wire');
    max_voltage(i) = max(comp_voltage);
    plot(1:length(comp_voltage), comp_voltage);
    i = i+1;
end
hold off
%figure(2)
%plot(max_voltage)
len = length(max_voltage);
DIBL_30 = (max_voltage(len) - max_voltage(1))/0.1;

comp_voltage50_200mv = compute_modified_poisson(-0.2, 50);
comp_voltage50_100mv = compute_modified_poisson(-0.1, 50);

DIBL_30
DIBL_50 = (max(comp_voltage50_200mv) - max(comp_voltage50_100mv) )/0.1