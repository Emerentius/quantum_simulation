% Calculate charge in gate.
function Q = charge_gate(obj)
    e = 1.60217656e-19;
    Q = -e * sum(obj.gate.carrier_density) * obj.a * obj.area_ch;
end