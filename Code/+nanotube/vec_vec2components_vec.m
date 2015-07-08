% take a 2xN array [v1, v2, v3...] and return a 3xN array of layout [n1, n2, n3... ; m1,
% m2, m3; is_on_left1 is_on_left2 is_on_left3]
% v1, v2... are 2x1 arrays
% if third component is_on_left is 1, the atom lies on the left sublattice
function component_vec = vec_vec2components_vec(vec)
    nanotube.initialise_constants;
    vec = vec/a_c;
    
    %to_be_n = vec(2)+vec(1)/sqrt(3);
    %is_on_left_sublattice = round( 3*abs(to_be_n - round(to_be_n)) ) == 1;
    
    to_be_n = vec(2,:) + vec(1,:)/sqrt(3);
    
    component_vec(1,:) = round( to_be_n );   % n
    component_vec(2,:) = round( vec(1,:)/sqrt(3) - vec(2,:) ); % m
    component_vec(3,:) = round( 3*abs(to_be_n - round(to_be_n)) ) == 1; % is_on_left sublattice
end