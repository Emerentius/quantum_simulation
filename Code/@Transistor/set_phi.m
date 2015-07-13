function set_phi(obj, phi)
    %% dent correction
    % TODO: make dent correction limit adjustable
    LIMIT = 0.03;
    [min_phi_source, min_idx_source] = min(phi(obj.source.range));
    [min_phi_drain, min_idx_drain] = min(phi(obj.drain.range));
    max_phi_gate = max(phi(obj.gate.range));
    
    if phi(1) - min_phi_source > LIMIT && ...
       max_phi_gate > phi(1) % else this always applies
        phi(1:min_idx_source) = min_phi_source;
    end
    
    if phi(end) - min_phi_drain > LIMIT && ...
       max_phi_gate > phi(end) % else this always applies
        phi(min_idx_drain:end) = min_phi_drain;
    end


    %% save phi
    obj.source.phi = phi(obj.source.range);
    obj.gate.phi   = phi(obj.gate.range);
    obj.drain.phi  = phi(obj.drain.range);
    
    obj.phi_changed_since_DOS_calculation = true;
    obj.current_is_up_to_date = false;
end