% Experimental
% 1 direction
function is_inside = is_inside_unit_cell_partial_components(components_vec, n,m)
    if components_vec(3) % => is on left sublattice
        vec_3n = 3*int32(components_vec(1)) - 1;
        vec_3m = 3*int32(components_vec(2)) - 1;
    else
        vec_3n = 3*int32(components_vec(1));
        vec_3m = 3*int32(components_vec(2));
    end
    
    n = int32(n);
    m = int32(m);
    
    num = 2*vec_3n*n + 2*vec_3m * m + vec_3n*m + vec_3m*n;
    range_start = 0;
    range_end   = 3*2*(n^2 + m^2 + n*m);
    
	is_inside = (range_start <= num) && (num < range_end);
end