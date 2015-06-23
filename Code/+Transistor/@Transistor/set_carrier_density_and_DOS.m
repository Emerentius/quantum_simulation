function set_carrier_density_and_DOS(obj, carrier_density, DOS)
    %obj.phi_cache = phi;
    obj.source.carrier_density = carrier_density(obj.source.range);
    obj.gate.carrier_density   = carrier_density(obj.gate.range);
    obj.drain.carrier_density  = carrier_density(obj.drain.range);
    
    obj.source.DOS = DOS(:, obj.source.range);
    obj.gate.DOS   = DOS(:, obj.gate.range);
    obj.drain.DOS  = DOS(:, obj.drain.range);
    
    obj.phi_changed_since_DOS_calculation = false;
end