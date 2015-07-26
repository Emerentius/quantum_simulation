function E = nth_level_particle_in_a_box(n, m, L)
    initialise_constants;
    E = helper.J_to_eV(h_bar^2 * n^2 * pi^2 / (2*m*helper.nm_to_m(L)^2));
end