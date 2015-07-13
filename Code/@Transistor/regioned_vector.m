function vector = regioned_vector(obj, source_val, gate_val, drain_val)
    vector = zeros(obj.n_ges, 1);
    vector(obj.source.range) = source_val;
    vector(obj.gate.range)   = gate_val;
    vector(obj.drain.range)  = drain_val;
end