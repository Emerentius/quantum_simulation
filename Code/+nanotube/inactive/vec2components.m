% Convert position space vector into n,m and sublattice-information
function [n,m, is_on_left_sublattice] = vec2components(vec)
    nanotube.initialise_constants;
    vec = vec/a_c;
    
    % on the left sublattice, there is an offset of -1/3 (a1+a2)
    % which is completely in x
    % => if m and n are -1/3 below an integer, it's on the left sublattice
    to_be_n = vec(2)+vec(1)/sqrt(3);
    is_on_left_sublattice = round( 3*abs(to_be_n - round(to_be_n)) ) == 1;
    n = round( to_be_n );
    m = round( vec(1)/sqrt(3) - vec(2) );
end