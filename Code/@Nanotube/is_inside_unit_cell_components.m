% Check if the vector specified by the components is inside the unit cell
function is_inside = is_inside_unit_cell_components(obj, components_vec)
	is_inside = nanotube.is_inside_unit_cell_partial_components(components_vec, obj.n,obj.m) && ...
                nanotube.is_inside_unit_cell_partial_components(components_vec, obj.n_p, obj.m_p);
end