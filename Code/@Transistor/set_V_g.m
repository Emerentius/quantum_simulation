function set_V_g(obj, V_g)
    if obj.V_g == V_g
        return
    end
    obj.V_g = V_g;
    obj.is_self_consistent = false;
    obj.set_phi(obj.poisson);
end