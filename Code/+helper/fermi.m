% Fermi function for energies in eV
function output = fermi(E, T)
    k_B = 1.38e-23;
    eV = 1.602176565e-19;

    if E == 0 
       % this is necessary, because the calculation below breaks down
       % for T = 0 and returns NaN.
       output = 0.5;
    else
       output = 1/(exp(E*eV/(k_B*T)) + 1);
    end
end