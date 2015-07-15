% Convert n,m and sublattice-information into position space vector
function vec = components2vec(n,m, is_on_left_sublattice)
    if ~exist('is_on_left_sublattice', 'var')
        is_on_left_sublattice = 0;
    end
    nanotube.initialise_constants;
    vec = n*a1+m*a2 + is_on_left_sublattice*a_cc_vec_right2left;
end