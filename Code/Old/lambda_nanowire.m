function lambda = lambda_nanowire(d_ch, d_ox, eps_ch, eps_ox);
    lambda = sqrt( eps_ch * d_ch*d_ch / 8 / eps_ox * log(1+ 2*d_ox/d_ch) );
end