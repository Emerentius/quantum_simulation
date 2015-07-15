function compute_energy_bands(obj, n_k_steps)
    a = norm(obj.P);
    k_range = linspace(-pi/a, pi/a, n_k_steps);
    E = zeros(obj.atoms_in_unit_cell, length(k_range));
    k_counter = 1;

    [H_prev, H, H_next] = obj.hamiltonians;
    for k = k_range
        E(:,k_counter) = eig( H + H_next*exp(1i*k*a) + H_prev*exp(-1i*k*a) );
        k_counter = k_counter + 1;
    end
    %% Save data
    obj.energy_bands = E;
    obj.k_range = k_range;
end