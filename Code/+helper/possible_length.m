% Highest possible length realisable with given lattice distance, not
% exceeding the given length
function length = possible_length(length, lattice_distance)
    length = helper.n_lattice_points(length, lattice_distance) * lattice_distance;
end