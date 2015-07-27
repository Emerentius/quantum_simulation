function charge_density_ = area_charge_density_gate(obj)
    e = 1.60217656e-19;
    charge_density_ = -e * sum(obj.gate.carrier_density) * obj.a;
end