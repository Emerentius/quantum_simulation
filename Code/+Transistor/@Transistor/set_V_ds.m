function set_V_ds(obj, V_ds)
    obj.V_ds = V_ds;
    obj.is_self_consistent = false;
    obj.initialise_phi_carrier_density_DOS();
end