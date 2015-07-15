% Convert a 2xN array [ [x; y], ...] to a 3xN array [ [n; m; is_on_left], ...]
% if third component is_on_left is true (1), the atom lies on the left sublattice
function component_vec = vec_vec2components_vec(vec)
    nanotube.initialise_constants;
    vec = vec/a_c; % normalise
    
    to_be_n = vec(2,:) + vec(1,:)/sqrt(3);
    component_vec(1,:) = round( to_be_n );   % n
    component_vec(2,:) = round( vec(1,:)/sqrt(3) - vec(2,:) ); % m
    component_vec(3,:) = round( 3*abs(to_be_n - round(to_be_n)) ) == 1; % is_on_left sublattice
end