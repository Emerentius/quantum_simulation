function num = component_vec2num(obj, vec)
    atoms_comp = obj.lattice_points_components;
    for num = 1:obj.atoms_in_unit_cell
        if atoms_comp(:, num) == vec
            return
        end
    end
    %num = obj.components2num(num2str(vec));
end