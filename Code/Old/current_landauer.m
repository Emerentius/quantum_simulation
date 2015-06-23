% todo:
% parameter parsen
function current = compute_current_landauer(band_curve, T, varargin)

E_barrier_max = max(band_curve);
E_min = E_barrier_max - 0.1;
E_max = 3;
energy_step = 0.001;
energies = E_min : energy_step : E_max;
E_s = band_curve(1);
E_d = band_curve( length(band_curve) );
E_f = 0.1;
e = 1.6e-19;
prefactor = 2e15/4.135; % 2e/h oder h_quer

current = 0;
for E=energies
    current = current + prefactor * energy_step * e * (fermi((E-E_s - E_f)*e, 300) - fermi((E- E_d - E_f)*e, T) );
end
current;