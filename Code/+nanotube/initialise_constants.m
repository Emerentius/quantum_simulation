a_c = 0.249; % nm, length of lattice vector a1, also a2
a_cc = a_c / sqrt(3); % distance between two neighbouring C atoms
a_cc_vec_left2right = a_cc * [1; 0];
a_cc_vec_right2left = -a_cc_vec_left2right;
a1 = a_c * [sqrt(3); 1]/2;
a2 = a_c * [sqrt(3); -1]/2;

% distance between two equivalent atoms along y axis and x axis (same
% sublattice)
d_y = a_c;
d_x = sqrt(3) * a_c;