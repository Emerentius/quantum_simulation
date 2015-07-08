% Check if the vector specified by the components is inside the unit cell
function is_inside = is_inside_unit_cell_components(vec_n, vec_m, is_inside_unit_cell, n,m, n_p, m_p)
	is_inside = nanotube.is_inside_unit_cell_partial_components(vec_n, vec_m, is_inside_unit_cell, n,m) && ...
                nanotube.is_inside_unit_cell_partial_components(vec_n, vec_m, is_inside_unit_cell, n_p, m_p)
end