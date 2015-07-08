% Checks if the given vector is inside the boundaries set by the second
% vector
function is_inside = is_inside_unit_cell_partial(vector, CP)
	projection_CP = dot(vector, CP);
	is_inside =  projection_CP >= 0 && projection_CP < dot(CP,CP);
end