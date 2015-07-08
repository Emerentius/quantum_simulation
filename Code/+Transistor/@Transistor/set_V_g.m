function set_V_g(obj, V_g)
    obj.V_g = V_g;
    obj.is_self_consistent = false;
    obj.initialise_phi_carrier_density_DOS();
end