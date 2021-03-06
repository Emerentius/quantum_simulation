% vector of vectors (3xN array) consististing of all points inside and around the unit cell
% output format: [ [n; m; is_on_left_sublattice], ... ]
function lattice_components = all_lattice_point_components_inside_and_around(n,m, padding_x, padding_y)
    if ~exist('padding_x', 'var') && ~exist('padding_y', 'var')
        padding_x = 0;
        padding_y = 0;
    end

    all_points = nanotube.lattice_points_inside_and_around(n,m, padding_x, padding_y);
    lattice_components = nanotube.vec_vec2components_vec(all_points);
end