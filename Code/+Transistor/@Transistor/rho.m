function rho_out = rho(obj)
    e = 1.602176565e-19;
    rho_out = -e*obj.carrier_density;
end