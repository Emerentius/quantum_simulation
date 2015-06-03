function lambda = lambda_double_gate(d_ch, d_ox, eps_ch, eps_ox);
    lambda = sqrt(d_ox*d_ch*eps_ch/eps_ox/2);
end