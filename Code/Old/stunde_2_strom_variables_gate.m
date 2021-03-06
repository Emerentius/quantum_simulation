%% 
%% BROKEN
%%

clear all;
for i=1:100;
    v_g = -0.01 * i;
    voltage = compute_modified_poisson(-1, v_g, 30, 'geometry', 'nano-wire');
    E_barrier_max = max(voltage);
    E_min = E_barrier_max - 0.1;
    E_max = 2;
    energy_step = 0.001;
    energies = E_min : energy_step : E_max;
    E_s = voltage(1);
    E_d = voltage( length(voltage) );
    E_f = 0.1;
    e = 1.6e-19;
    prefactor = 2e15/4.135;

    I(i) = 0;
    for energy=energies
        I(i) = I(i) + prefactor * energy_step * e * (fermi(energy-E_s - E_f, 300) - fermi(energy- E_d - E_f, 300) );
    end
    %I
end

plot((1:100)*0.01,log10(I))
0,3/(log10(I(31)) - log10(I(1)))