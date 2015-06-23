clear all;
close all;
initialise_constants
%profile on

%% input parameters
m = 0.2*m_e;
l = 50*nm;
a = 0.2*nm;

T = 300; % K

E_f = 1*eV;
E_min = -0.5*eV;
E_max = E_f+5*k_B*T;

energy_step = (E_max-E_min)/100;
eta = 1*energy_step;

coupling_right = 1;
coupling_left = 1;
%%

t = h_bar^2 / (2*m * a^2);
n_ges = floor(l/a);
phi = e*poisson(-0.5,0,5*nm, 1*nm, 'a', a, 'l_ch', l/4+a, 'l_ds', 3*l/8, 'geometry', 'nano-wire');
figure(5);
plot(phi);

energies = E_min : energy_step : E_max;

side_diag = ones(n_ges, 1) .*  (-t);
for E_j=[energies; 1:length(energies)]
    E = E_j(1);
    j = E_j(2);

    % side diag above
    middle_diag = phi + ones(n_ges,1) .* (2*t);
    H = spdiags([side_diag, middle_diag, side_diag], [1,0,-1], n_ges, n_ges);

    diagonal = ones(n_ges,1) .* (E+ 1i*eta);
    E_i_eta = spdiags(diagonal, [0], n_ges, n_ges);

    matrix = E_i_eta - H;
    
    % add matrices for contacts (single element each)
    phi_left = phi(1);
    phi_right = phi(length(phi));
    
    %left contact
    k_wave_left = sqrt(2*m*(E-phi_left) /h_bar^2 ); % korrigieren, tight-binding k
    self_energy_left = -(t*exp(1i*a*k_wave_left));
    matrix(1, 1) = matrix(1, 1) - self_energy_left * coupling_left;
    
    % right contact
    k_wave_right = sqrt(2*m*(E-phi_right) /h_bar^2 ); % korrigieren, tight-binding k
    self_energy_right = -(t*exp(1i*a*k_wave_right));
    matrix(n_ges, n_ges) = matrix(n_ges, n_ges) - self_energy_right * coupling_right;

    G = 1/a .* inv(matrix);
    densities(j, :) = -1/pi*imag(diag(G)).';
end

x_pos = 0:a:l-a;

%% Integrieren
n_elektronen = 0; % integrierte elektronenzahl
for i=1:length(energies)
    E = energies(i);
    n_elektronen = n_elektronen + sum(densities(i,:))*energy_step*a*fermi(E-E_f, T);
end

figure(3)
p = surf(x_pos(1:n_ges), energies, densities);

%profile off
%profile viewer