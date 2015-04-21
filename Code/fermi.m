function output = fermi(E, T)
    k_B = 1.38e-23;
    e = 1.6e-19;
    output = 1/(exp(E*e/(k_B*T)) + 1);
end