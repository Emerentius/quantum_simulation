clear all;
close all;
initialise_constants

%% input parameters
m = 0.5*m_e;
l = 50*nm;
a = 0.5*nm;
%%

t = h_bar^2 / (2*m * a^2);
%E = 0.1;
n_ges = floor(l/a);
phi = zeros(n_ges,1);

E_min = 0; %E_barrier_max - 0.1;
E_max = 0.01*t; %0.0005*e;
energy_step = E_max/1000;
eta = 1*energy_step;
energies = E_min : energy_step : E_max;

side_diag = ones(n_ges, 1) .*  (-t);
j = 1;
for E=energies
    middle_diag = phi + ones(n_ges,1) .* (2*t);
    H = spdiags([side_diag, middle_diag, side_diag], [1,0,-1], n_ges, n_ges);
    E_i_eta = spdiags(ones(n_ges, 1), [0], n_ges, n_ges) .* (E + 1i*eta);
    matrix = E_i_eta - H;
    G = 1/a .* inv(matrix);
    densities(:, j) = -imag(diag(G));
    j = j+1;
end

x_pos = 0:a:l-a;
p = surf(x_pos(1:n_ges), energies, densities.');