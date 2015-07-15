function [H_prev, H, H_next] = hamiltonians(obj)
    H_prev = zeros( obj.atoms_in_unit_cell );
    H =      zeros( obj.atoms_in_unit_cell );
    H_next = zeros( obj.atoms_in_unit_cell );
    t = 3; % eV
    
    % Iterate through all atoms, for every atom iterate through every
    % neighbour and find number
    % Save in corresponding hamiltonian without phase factor.
    lattice_points = obj.lattice_points_components;
    for lattice_point_num = 1:length(lattice_points)
        atom_comps = lattice_points(:, lattice_point_num);
        % up right, down right, left
        neighbour_offsets = [ [1;0;1], [0;1;1], [0;0;1] ]; % % components
        if atom_comps(3) % is on left sublattice
            neighbour_offsets = -neighbour_offsets; % everything opposite
        end
        
        for neighbour = neighbour_offsets + repmat(atom_comps, 1, 3)
            [reduced_vec, is_valid_neighbour, P_offset] = obj.reduce_neighbour_vec_components(neighbour);
            if is_valid_neighbour
                neighbour_num = obj.component_vec2num(reduced_vec);
                
                if P_offset == 1
                    H_next(lattice_point_num, neighbour_num) = -t;
                elseif P_offset == -1
                    H_prev(lattice_point_num, neighbour_num) = -t;
                else
                         H(lattice_point_num, neighbour_num) = -t;
                end
            end
        end
    end
end