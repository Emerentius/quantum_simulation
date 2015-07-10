function [E, k_range] = energy_band(obj)
    a = norm(obj.P);
    k_range = linspace(-pi/a, pi/a, 100);
    
    %psi = zeros( obj.atoms_in_unit_cell, 1);
    E = zeros(obj.atoms_in_unit_cell, length(k_range));
    k_counter = 1;
    
    [H_prev, H, H_next] = obj.hamiltonians;
    for k = k_range
        %% psi
        atom_counter = 1;
        for atom = obj.lattice_points
            psi(atom_counter) = exp(1i*k* dot(atom, obj.P));
            atom_counter = atom_counter + 1;
        end
        %% 
        E(:,k_counter) = eig( H + H_next*exp(1i*k*a) + H_prev*exp(-1i*k*a) );
        k_counter = k_counter + 1;
    end
end