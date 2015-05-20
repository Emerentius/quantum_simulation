clear all;
close all;
initialise_constants
%profile on

%% input parameters
m = 0.2*m_e;
l = 20*nm;
a = 0.2*nm;

T = 300;

E_min = 0;
E_max = 2*eV;
E_f = 0.5*eV;

energy_step = (E_max-E_min)/100;
eta = 1*energy_step;

% Device
V_ds = -1;
%%

t = h_bar^2 / (2*m * a^2);
E_1 = (h_bar * pi)^2 / (2*m * l^2 ); % first state
n_ges = floor(l/a);
phi = e*poisson(V_ds,0,5*nm, 5*nm, 'a', a, 'l_ch', l/2, 'l_ds', l/4+a, 'E_f', E_f, 'geometry', 'nano-wire');

energies = E_min : energy_step : E_max;
%prefactor = 2e15/4.135; % 2e/h oder h_quer
   
side_diag = ones(n_ges, 1) .*  (-t);
for E_j=[energies; 1:length(energies)]
    E = E_j(1);
    j = E_j(2);

    % side diag above
    middle_diag = phi(1:n_ges) + ones(n_ges,1) .* (2*t);
    H = spdiags([side_diag, middle_diag, side_diag], [1,0,-1], n_ges, n_ges);

    diagonal = ones(n_ges,1) .* (E+ 1i*eta);
    E_i_eta = spdiags(diagonal, [0], n_ges, n_ges);

    matrix = E_i_eta - H;

    G = 1/a .* inv(matrix);
    densities(j, :) = -1/pi*imag(diag(G)).';
end

x_pos = 0:a:l-a;
p = surf(x_pos(1:n_ges), energies, densities);

%% Integrieren
n_elektronen_ges = 0;
for i=1:length(energies)
    E = energies(i);
    n_elektronen_ges = n_elektronen_ges + sum(densities(i,:))*energy_step*a*fermi(E-E_f, T);
end
disp(n_elektronen_ges)
%% carrier density
% figure(2)
% for i=1:n_ges
%     x = x_pos(i);
%     n_tmp = 0;
%     for j=1:length(energies)
%         E=energies(j);
%         n_tmp = n_tmp + energy_step*fermi(E-E_f, T)*densities(j,i);
%     end
%     n(i)=n_tmp;
% end
%%
%plot(x_pos(1:n_ges), n)
%%

%profile off
%profile viewer