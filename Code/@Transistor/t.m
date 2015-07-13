function t_out = t(obj)
    initialise_constants;
    a_SI = helper.nm_to_m(obj.a);
    t_SI = h_bar^2 / (2*obj.m * a_SI^2 );
    t_out = helper.J_to_eV(t_SI);
end