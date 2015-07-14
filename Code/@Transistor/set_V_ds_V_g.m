function set_V_ds_V_g(obj, V_ds, V_g)
    if obj.V_g == V_g && obj.V_ds == V_ds
        return
    end
    obj.V_ds = V_ds;
    obj.V_g = V_g;
    obj.is_self_consistent = false;
    obj.set_phi(obj.poisson);
end