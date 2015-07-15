function is_inside = is_inside_unit_cell(vector, C, P)
	is_inside = nanotube.is_inside_unit_cell_partial(vector, C) && ...
                nanotube.is_inside_unit_cell_partial(vector,P);
end