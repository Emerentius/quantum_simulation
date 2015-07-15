% Calculate number of atoms in a unit cell by area
function n_atoms = atoms_in_unit_cell(n,m)
    nanotube.initialise_constants;
    C = nanotube.C(n,m);
    P = nanotube.P(n,m);
    area = norm(C)*norm(P);
    area_hex = a_cc^2 * 3*sqrt(3)/2;
    % n_atoms is integer already, rounding simply shaves off small float errors
    n_atoms = round(area/area_hex * 2);
end