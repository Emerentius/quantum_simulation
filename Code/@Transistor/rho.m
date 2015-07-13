function rho_out = rho(obj)
    e = 1.602176565e-19;
    rho_out = -e*obj.carrier_density;
    rho_out(obj.source.range) = rho_out(obj.source.range) + e*obj.dopant_density;
    rho_out(obj.drain.range)  = rho_out(obj.drain.range) + e*obj.dopant_density;
end