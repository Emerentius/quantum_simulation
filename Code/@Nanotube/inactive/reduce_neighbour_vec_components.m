% If input component vector lies in unit cell or neighbouring unit cell
% return the equivalent vector in unit cell and P offset of the cell it was
% in
% Fails (empty return vector) on component vectors too far away
function [reduced_vec, valid_neighbour, P_offset] = reduce_neighbour_vec_components(obj, comp_vec)
    P_comp = obj.P_components; % component vec [n; m; is_on_left]
    C_comp = obj.C_components; 
    
    for C_offset = [-1, 0, 1]
        for P_offset = [-1, 0, 1]
            test_vec = comp_vec + C_offset*C_comp + P_offset*P_comp;
            if obj.is_inside_unit_cell_components( test_vec )
                valid_neighbour = true;
                reduced_vec = test_vec;
                return
            end
        end
    end
    
    % no neighbour found
    valid_neighbour = false;
    reduced_vec = [];
    P_offset = [];
end