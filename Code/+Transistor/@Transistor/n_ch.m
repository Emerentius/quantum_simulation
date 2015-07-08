% number of lattice points in gate
function n = n_ch(obj)
    n = obj.gate.range_end - obj.n_ds();
end