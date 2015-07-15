% Calculate total charge in drain (including dopants).
function Q = charge_source(obj)
    e = 1.60217656e-19;
    Q = -e * sum(obj.drain.carrier_density) * obj.a * obj.area_ch;
end