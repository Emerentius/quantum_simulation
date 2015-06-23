function density = carrier_density(phi, a, E_f_left, E_f_right, varargin);
initialise_constants

%%% Default parameters
m_def = m_e;
T_def = 300;
steps_def = 10000;

%%%

% parse input
p = inputParser;
is_numeric_scalar = @(x) isnumeric(x) && isscalar(x);
is_numeric_vector = @(x) isnumeric(x) && isvector(x);
%is_numeric_scalar_or_string = @(x) is_numeric_scalar(x) || ischar(x);

% required arguments
addRequired(p, 'phi', is_numeric_vector);
addRequired(p, 'E_f_left', is_numeric_scalar); 
addRequired(p, 'E_f_right', is_numeric_scalar);
addRequired(p, 'a', is_numeric_scalar);

% overrides
addOptional(p, 'm', m_def, is_numeric_scalar);
addOptional(p, 'T', T_def, is_numeric_scalar);
addOptional(p, 'n_steps', steps_def, is_numeric_scalar);

% parse input as described
parse(p, phi, a, E_f_left, E_f_right, varargin{:});

% read parsed optional input into variables
m = p.Results.m;
T = p.Results.T;
n_steps = p.Results.n_steps; % energy steps UMBENENNEN
%%
n_ges = length(phi);
%l = (n_ges-1)*a;

% Integrationsgrenzen
E_min = min(phi);
E_max = max(E_f_left, E_f_right)+5*k_B*T;

dE = (E_max-E_min)/n_steps;
energies = E_min : dE : E_max;

eta = 0.001*dE; % kann beliebig klein

t = h_bar^2 / (2*m * a^2);
H_side_diag = ones(n_ges, 1) .*  (-t);
density = 0;
for E_j=[energies; 1:length(energies)]
    E = E_j(1);
    %j = E_j(2);

    % side diag above
    H_middle_diag = phi + ones(n_ges,1) .* (2*t);
    H = spdiags([H_side_diag, H_middle_diag, H_side_diag], [1,0,-1], n_ges, n_ges);

    E_i_eta_diag = ones(n_ges,1) .* (E+ 1i*eta);
    E_i_eta = spdiags(E_i_eta_diag, [0], n_ges, n_ges);

    matrix = E_i_eta - H;
    
    %% add matrices for contacts (single element each)
    phi_left = phi(1);
    phi_right = phi(length(phi));
    
    arg_left = (2*t - E + phi_left)/2/t;
    arg_right = (2*t - E + phi_right)/2/t;
    ka_left = real( acos(arg_left) );      % 0 if argument of acos > 1
    ka_right = real( acos(arg_right) );
    
    self_energy_left = -t*exp(1i*ka_left);
    matrix(1, 1) = matrix(1, 1) - self_energy_left;

    self_energy_right = -t*exp(1i*ka_right);
    matrix(n_ges, n_ges) = matrix(n_ges, n_ges) - self_energy_right;
    %%
    
    G = 1/a .* inv(matrix);
    %densities_old(j, :) = -1/pi*imag(diag(G)).'; 
    A_left = abs( G(:,1).^ 2 ) * 2*t*sin(ka_left);
    A_right = abs( G(:, n_ges).^ 2 ) * 2*t*sin(ka_right);
    DOS_left = A_left / (2*pi);
    DOS_right = A_right / (2*pi);
    %DOS_s(j,:) = DOS_left(:);
    %DOS_d(j,:) = DOS_right(:);
    %% Berechne carrior density
    density = density + ( fermi(E-E_f_left, T)*DOS_left + fermi(E-E_f_right, T)*DOS_right )*dE;
    
    %% Speichere DOS
    %densities(j, :) = DOS_left.' + DOS_right.';
    %%
end