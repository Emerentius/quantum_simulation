clear all;
close all;
initialise_constants
%profile on

%% input parameters
m = 0.2*m_e;
l = 50*nm;
a = 0.2*nm;

T = 300; % K

coupling_right = 1;
coupling_left = 1;

V_ds = -0.7;%-0.2; %-0.5;

E_f = 0.2*eV;

%% Integrationsgrenzen
E_min = V_ds*eV;
E_max = 1*eV; %E_f+5*k_B*T;
%%

dE = (E_max-E_min)/1000;
eta = 0.001*dE;
%%

t = h_bar^2 / (2*m * a^2);
n_ges = floor(l/a);
phi = eV*poisson(V_ds,0,5*nm, 1*nm, 'a', a, 'l_ch', l/4+a, 'l_ds', 3*l/8, 'geometry', 'nano-wire');
figure(1);
plot(phi);

energies = E_min : dE : E_max;

H_side_diag = ones(n_ges, 1) .*  (-t);
n = 0;
for E_j=[energies; 1:length(energies)]
    E = E_j(1);
    j = E_j(2);

    % side diag above
    H_middle_diag = phi + ones(n_ges,1) .* (2*t);
    H = spdiags([H_side_diag, H_middle_diag, H_side_diag], [1,0,-1], n_ges, n_ges);

    E_i_eta_diag = ones(n_ges,1) .* (E+ 1i*eta);
    E_i_eta = spdiags(E_i_eta_diag, [0], n_ges, n_ges);

    matrix = E_i_eta - H;
    
    %% add matrices for contacts (single element each)
    phi_source = phi(1);
    phi_drain = phi(length(phi));
    
    arg_source = (2*t - E + phi_source)/2/t;
    arg_drain = (2*t - E + phi_drain)/2/t;
    ka_source = real( acos(arg_source) );      % 0 if argument of acos > 1
    ka_drain = real( acos(arg_drain) );
    
    self_energy_left = -t*exp(1i*ka_source);
    matrix(1, 1) = matrix(1, 1) - self_energy_left * coupling_left;

    self_energy_right = -t*exp(1i*ka_drain);
    matrix(n_ges, n_ges) = matrix(n_ges, n_ges) - self_energy_right * coupling_right;

    %%
    
    G = 1/a .* inv(matrix);
    densities_old(j, :) = -1/pi*imag(diag(G)).'; 
    A_source = abs( G(:,1).^ 2 ) * 2*t*sin(ka_source);
    A_drain = abs( G(:, n_ges).^ 2 ) * 2*t*sin(ka_drain);
    DOS_source = A_source / (2*pi);
    DOS_drain = A_drain / (2*pi);
    DOS_s(j,:) = DOS_source(:);
    DOS_d(j,:) = DOS_drain(:);
    %% Berechne carrior density
    E_f_s = E_f;
    E_f_d = E_f + V_ds*eV;
    n = n + ( fermi(E-E_f_s, T)*DOS_source + fermi(E-E_f_d, T)*DOS_drain )*dE;
    
    %% Speichere DOS
    densities(j, :) = DOS_source.' + DOS_drain.';
    %%
end

% plot carrier density
x_pos = 0:a:l-a;
figure(2);
figure('name', 'carrier density');
plot(x_pos(1:n_ges)/nm, n)
xlabel('Position [nm]');
ylabel('Carrier density [??]');

% plot densities calculated via spectral matrices
figure(3);
figure('Name', 'DOS (spectral matrices)');
surf(x_pos(1:n_ges)/nm, energies/eV, densities);
view(2);
xlabel('Position [nm]');
ylabel('Energy [eV]');

% plot densities calculated via old matrix diagonal method
figure(4)
figure('name', 'DOS (matrix diagonal)')
surf(x_pos(1:n_ges)/nm, energies/eV, densities_old);
view(2);
xlabel('Position [nm]');
ylabel('Energy [eV]');

%profile off
%profile viewer