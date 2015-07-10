function [reduced_vec, valid_neighbour, P_offset] = reduce_vec_components(obj, comp_vec)
    component_offsets = [ [0;0;0], obj.C_components, -obj.C_components, obj.P_components, -obj.P_components];
    P_offsets = [ 0, 0, 0, 1, -1 ];
    valid_neighbour = true;
    
    for jj = 1:size(component_offsets, 2)
        component_offset = component_offsets(:, jj);
        if obj.is_inside_unit_cell_components( comp_vec + component_offset )
            reduced_vec = comp_vec + component_offset;
            P_offset = P_offsets(jj);
            return;
        end
    end
    
    valid_neighbour = false;
    reduced_vec = [];
    P_offset = [];
end