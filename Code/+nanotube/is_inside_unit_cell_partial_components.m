% Checks along one direction, which is given by n*a1+m*a2
% Takes component vecs of type [n; m; is_on_left_sublattice]
function is_inside = is_inside_unit_cell_partial_components(components_vec, n,m)
    vec_3n = 3*int32(components_vec(1));
    vec_3m = 3*int32(components_vec(2));
    if components_vec(3) % => is on left sublattice
        % a_cc_right_to_left = -1/3 (a1+a2)
        % => *3 to keep integers
        vec_3n = vec_3n - 1;
        vec_3m = vec_3m - 1;
    end
    
    n = int32(n);
    m = int32(m);
    
    num = 2*vec_3n*n + 2*vec_3m * m + vec_3n*m + vec_3m*n;
    range_start = 0;
    range_end   = 3*2*(n^2 + m^2 + n*m);
    
    % atoms on lower edge are part of cell, atoms on far edge are not
    % atoms on corners bordering far edge are not either
	is_inside = (range_start <= num) && (num < range_end);
end