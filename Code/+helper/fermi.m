% Fermi function for energies in eV
function output = fermi(E, T)
    k_B = 8.6173324e-5;
    if T == 0 
       % this is necessary, because the calculation below breaks down
       % for T = 0 and returns NaN.
       if E == 0 
           output = 0.5;
       elseif E < 0
           output = 1;
       else
           output = 0;
       end
    else
       output = 1/(exp( E/k_B/T ) + 1);
    end
end