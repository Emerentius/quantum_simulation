function E = E_min(obj)
    E = min([min(obj.gate.phi), min(obj.drain.phi)]);
end