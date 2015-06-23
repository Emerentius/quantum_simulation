% Works for meter and nanometer
function lam = lambda_by_geometry(d_ch, d_ox, eps_ch, eps_ox, geometry)

    switch(geometry)
        case {'single gate'}
            lam = lambda_single_gate(d_ch,d_ox,eps_ch,eps_ox);
        case {'double gate'}
            lam = lambda_double_gate(d_ch,d_ox,eps_ch,eps_ox);
        case {'triple gate', 'tri-gate'}
            lam = lambda_triple_gate(d_ch,d_ox,eps_ch,eps_ox);
        case {'nano-wire', 'nanowire'}
            lam = lambda_nanowire(d_ch,d_ox,eps_ch,eps_ox);
    end
end