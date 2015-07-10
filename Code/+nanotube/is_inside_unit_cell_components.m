% Check if the vector specified by the components is inside the unit cell
function is_inside = is_inside_unit_cell_components(components_vec, n,m, n_p, m_p)
	is_inside = nanotube.is_inside_unit_cell_partial_components(components_vec, n,m) && ...
                nanotube.is_inside_unit_cell_partial_components(components_vec, n_p, m_p)
end