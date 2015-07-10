CNT = Nanotube(2,3);

[energy_band, k_range] = CNT.energy_bands;
plot(k_range, energy_band, 'color', 'black');
conduction_band = energy_band( size(energy_band,1)/2 + 1, : );

initialise_constants;
d2Edk2 = helper.second_derivative(conduction_band, k_range(2) - k_range(1) );
m = h_bar^2 / d2Edk2( ceil(end/2) ) / e^2 / m_e

figure;
plot(k_range, conduction_band);

%effective_mass


%CNT.plot_lattice(0.1);