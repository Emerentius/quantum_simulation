function [H_prev, H, H_next] = hamiltonians(obj)
    H_prev = zeros( obj.atoms_in_unit_cell );
    H = zeros( obj.atoms_in_unit_cell );
    H_next = zeros( obj.atoms_in_unit_cell );
    a = norm(obj.P);
    % TODO: correct t
    t = -3; % eV
    
    lattice_points = obj.lattice_points_components;
    for lattice_point_num = 1:length(lattice_points)
        atom_comps = lattice_points(:, lattice_point_num);
        neighbour_offsets = [ [1;0;1], [0;1;1], [0;0;1] ]; % % components
        if atom_comps(3) % is on left sublattice
            neighbour_offsets = -neighbour_offsets;
        end
        
        for neighbour = neighbour_offsets + repmat(atom_comps, 1, 3)
            [reduced_vec, is_valid_neighbour, P_offset] = obj.reduce_vec_components(neighbour);
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