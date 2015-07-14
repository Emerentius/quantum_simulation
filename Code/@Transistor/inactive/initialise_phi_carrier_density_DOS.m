function initialise_phi_carrier_density_DOS(obj)
    obj.set_phi(obj.poisson());
    obj.compute_carrier_density_and_DOS();
end