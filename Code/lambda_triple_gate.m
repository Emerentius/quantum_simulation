function lambda = lambda_triple_gate(d_ch, d_ox, eps_ch, eps_ox);
    lambda = sqrt(d_ox*d_ch*eps_ch/eps_ox/3);
end