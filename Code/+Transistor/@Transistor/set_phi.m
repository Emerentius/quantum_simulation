function set_phi(obj, phi)
    %obj.phi_cache = phi;
    obj.source.phi = phi(obj.source.range);
    obj.gate.phi   = phi(obj.gate.range);
    obj.drain.phi  = phi(obj.drain.range);
    
    obj.phi_changed_since_DOS_calculation = true;
end