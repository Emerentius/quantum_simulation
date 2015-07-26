function E = E_max(obj)
    % in eV already!!
    k_B = 8.6173324e-5;
    E = max([obj.E_f_source, obj.source.phi(1), max(obj.gate.phi), obj.E_f_drain, obj.drain.phi(end)]);
    if sign(obj.carrier_charge_in_e) == -1
        E = E + 5*k_B*obj.T;
    end
end