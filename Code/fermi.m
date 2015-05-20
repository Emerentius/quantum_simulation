function output = fermi(E, T)
    k_B = 1.38e-23;
    output = 1/(exp(E/(k_B*T)) + 1);
end