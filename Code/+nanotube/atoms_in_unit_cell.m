% EXPERIMENTAL
function n_atoms = atoms_in_unit_cell(n,m)
    nanotube.initialise_constants;
    C = nanotube.C(n,m);
    P = nanotube.P(n,m);
    area = norm(C)*norm(P);
    area_hex = a_cc^2 * 3*sqrt(3)/2;
    n_atoms = area/area_hex * 2;
end