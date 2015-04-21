function output = fermi(E, T)
    k_B = 1.38e-23;
    e = 1.6e-19;
    output = exp(-E*e/k_B/T)
end

voltage = compute_modified_poisson(-1, 20);
E_barrier_max = max(voltage);
E_min = E_barrier_max - 0.1
E_max = 20
Energies = E_min : 0.01 : E_max;
E_s = voltage(1);
E_d = voltage( length(voltage) );
E_f = 0.1;
%e = 1.6e-19;
prefactor = 2e15/4.135;

I = 0;
for energy=Energies
    I = I + prefactor * (fermi(energy-E_s + E_f, 300) - fermi (energy-E_d+E_f, 300) );
end
I