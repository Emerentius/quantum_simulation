%% Initialise
a = 0.2; % nm
L = 20;  % nm
m = 0.1*m_e;

E_min = -0.01; % eV
E_max = helper.nth_level_particle_in_a_box(4, m, L);

E_f = helper.nth_level_particle_in_a_box(3, m, L)*1.1;
dE = 5e-4;
eta = 2*dE;

T = 1e-8; % K

coupling_left  = 0;
coupling_right = 0;

%%
n_ges = helper.n_lattice_points(L, a);
t = helper.J_to_eV(h_bar^2 / (2*m * helper.nm_to_m(a)^2));
E_1 = helper.nth_level_particle_in_a_box(1, m, L);
phi = zeros(n_ges, 1);

energies = E_min : dE : E_max;

H = spdiags([ -t*ones(n_ges,1), ... % upper diag
              phi + 2*t,        ... % middle diag
              -t*ones(n_ges,1), ... % lower diag
             ], ...
             [1,0,-1], n_ges, n_ges);

DOS = [];
carrier_density = 0;
for E = energies
    G = 1/a * ( ((E + 1i*eta)*speye(n_ges) - H)\eye(n_ges) );
    DOS(end+1, :) = -1/pi * imag(diag(G));
    carrier_density = carrier_density + DOS(end, :) * dE * helper.fermi(E-E_f, T);
end

x_pos = [1:n_ges] * a;
p = pcolor(x_pos, energies, DOS);
shading flat;
%carrier_density = sum(DOS);
figure;
plot(x_pos, carrier_density);

sum(carrier_density)


% Integrieren
n_elektronen = 0;
for i=1:length(energies)
    E = energies(i);
    n_elektronen = n_elektronen + sum(DOS(i,:))*dE*a*helper.fermi(E-E_f, T);
end
n_elektronen