% Check if the component vector is inside the unit cell of the CNT
% Takes component vecs of type [n; m; is_on_left_sublattice]
function is_inside = is_inside_unit_cell_components(obj, components_vec)
	is_inside = nanotube.is_inside_unit_cell_partial_components(components_vec, obj.n,obj.m) && ...
                nanotube.is_inside_unit_cell_partial_components(components_vec, obj.n_p, obj.m_p);
end