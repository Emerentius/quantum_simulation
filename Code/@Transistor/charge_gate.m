% Calculate charge in gate.
function Q = charge_gate(obj)
    e = 1.60217656e-19;
    % nm^-3 to m^-3 to meter conversion
    Q = -e* sum(obj.gate.carrier_density)*1e27;
end