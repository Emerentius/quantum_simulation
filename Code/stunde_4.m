clear all;
close all;
m_e = 9.1e-31;
m = 0.1*m_e;
nm = 1e-9;
e = 1.6e-19;

l = 20*nm;
a = 0.2*nm;

h_bar = 1.0546e-34;
t = h_bar^2 / (2*m * a^2);
E_1 = h_bar^2*pi^2 / m / l^2 / 2;
E_f = 100*E_1; %9.1 * E_1;
%E = 0.1;
n_ges = floor(l/a);
phi = e* poisson(-1,0,5*nm, 1*nm, 'a', a, 'l_ch', l/2, 'l_ds', l/4 + a, 'geometry', 'nano-wire', 'eps_ox', 30);
%zeros(n_ges,1);

E_min = 0; %E_barrier_max - 0.1;
E_max = 1000*E_1;
energy_step = E_max/1000;
eta = 1*energy_step;
energies = E_min : energy_step : E_max;
%E_f = 0.1;
%e = 1.6e-19;
%prefactor = 2e15/4.135; % 2e/h oder h_quer

side_diag = ones(n_ges, 1) .*  (-t);
j = 1;
for E=energies
    middle_diag = phi + ones(n_ges,1) .* (2*t);
    H = spdiags([side_diag, middle_diag, side_diag], [1,0,-1], n_ges, n_ges);
    E_i_eta = spdiags(ones(n_ges, 1), [0], n_ges, n_ges) .* (E + 1i*eta);
    matrix = E_i_eta - H;
    %spdiags([side_diag, middle_diag, side_diag], [1,0,-1], n_ges, n_ges );
    G = 1/a .* inv(matrix);
    densities(j, :) = -1/pi*imag(diag(G)).';
    j = j+1;
end

x_pos = 0:a:l-a;
p = surf(x_pos(1:n_ges), energies, densities);

%%
% Integrieren
int_res = 0;
for i=1:length(energies)
    E = energies(i);
    int_res = int_res + sum(densities(i,:))*energy_step*a*fermi((E-E_f)/e, 300);
end
disp(int_res)

%% carrier density
figure(2)
for i=1:n_ges
    x = x_pos(i);
    n_tmp = 0;
    for j=1:length(energies)
        E=energies(j);
        n_tmp = n_tmp + energy_step*fermi((E-E_f)/e, 300)*densities(j,i);
    end
    n(i)=n_tmp;
end
%%
plot(x_pos(1:n_ges), n)
%%
%figure(3)
%fplot(@(x) fermi(x-E_f, 300), [-E_f/e, E_max/e]);