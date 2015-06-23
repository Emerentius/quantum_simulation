close all;
clear;
hold on
i = 1;

pos_args = {0, 5, 5} % necessary arguments
options = {'a', 0.5, 'l_ds', '4 lambda'};

for voltage=0.1:0.01:0.2
    comp_voltage = poisson(-voltage, pos_args{:}, options{:}, 'l_ch', 30 );
    max_voltage(i) = max(comp_voltage);
    plot(1:length(comp_voltage), comp_voltage);
    i = i+1;
end
hold off
%figure(2)
%plot(max_voltage)
len = length(max_voltage);
DIBL_30 = (max_voltage(len) - max_voltage(1))/0.1; % 30nm

comp_voltage50_200mv = poisson(-0.2, pos_args{:}, 'l_ch', 50);
comp_voltage50_100mv = poisson(-0.1, pos_args{:}, 'l_ch', 50);

disp(DIBL_30)
DIBL_50 = (max(comp_voltage50_200mv) - max(comp_voltage50_100mv) )/0.1 % 50nm