% Convert a 3xN array [ [n; m; is_on_left], ...] to a 2xN array [ [x; y], ...]
function vec = components_vec2vec_vec(comp_vec)
    nanotube.initialise_constants;
    n_vecs = size(comp_vec, 2);
    
    n_matrix = repmat( comp_vec(1,:), [2 1] ); % 2 identical rows
    m_matrix = repmat( comp_vec(2,:), [2 1] );
    is_on_left_matrix = repmat( comp_vec(3,:), [2 1] );
    a1_matrix = repmat( a1, [1 n_vecs] );
    a2_matrix = repmat( a2, [1 n_vecs] );
    a_cc_vec_right2left_matrix = repmat( a_cc_vec_right2left, [1 n_vecs] );
    
    vec = n_matrix .* a1_matrix + m_matrix .* a2_matrix + is_on_left_matrix .* a_cc_vec_right2left_matrix;
end