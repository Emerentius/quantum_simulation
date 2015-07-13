function E = E_max(obj)
    % in eV already!!
    k_B = 8.6173324e-5;
    E = max([max(obj.source.phi), max(obj.gate.phi), max(obj.drain.phi), obj.E_f]) + 5*k_B*obj.T;
end