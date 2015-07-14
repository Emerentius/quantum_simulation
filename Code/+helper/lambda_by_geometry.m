% Works for meter and nanometer
function lam = lambda_by_geometry(d_ch, d_ox, eps_ch, eps_ox, geometry)
    geometry = lower(geometry);
    expected_geometry = {'single gate','double gate','triple gate', 'tri-gate', 'nano-wire', 'nanowire', 'wrap-gate'};
    if ~any(ismember(expected_geometry, geometry))
        error(['Invalid geometry. Expected one of these: "' strjoin(expected_geometry, '" "') '"']);
    end
    
    switch(geometry)
        case {'single gate'}
            lam = helper.lambda_single_gate(d_ch,d_ox,eps_ch,eps_ox);
        case {'double gate'}
            lam = helper.lambda_double_gate(d_ch,d_ox,eps_ch,eps_ox);
        case {'triple gate', 'tri-gate'}
            lam = helper.lambda_triple_gate(d_ch,d_ox,eps_ch,eps_ox);
        case {'nano-wire', 'nanowire', 'wrap-gate'}
            lam = helper.lambda_nanowire(d_ch,d_ox,eps_ch,eps_ox);
    end
end