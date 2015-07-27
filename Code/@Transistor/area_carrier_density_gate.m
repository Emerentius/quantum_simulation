function carrier_density_ = area_carrier_density_gate(obj)
    carrier_density_ = sum(obj.gate.carrier_density) * obj.a;
end