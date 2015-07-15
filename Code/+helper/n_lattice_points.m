% Highest amount of lattice points in given length for given lattice
% distance
function n_points = n_lattice_points(length, lattice_distance)
    n_points = floor(length/lattice_distance);
end