function delta_phi = calc_phi(V_ds, d_ch, eps_ch, eps, phi, phi_bi, phi_g, density, a, lambda_ds, lambda, rg_ds_left, rg_ch, rg_ds_right, E_f_N, T, m)
initialise_constants;

n_ges = length(phi);
area_ch = pi/4*d_ch^2;
% differently defined
% Todo: correct
V_ds = -V_ds;
%phi_g = -phi_g;

%% J
side_diag = ones(n_ges,1) / a^2;
% first two terms
mid_diag(rg_ds_left, 1) = -2/a^2 - 1/lambda_ds^2;
mid_diag(rg_ch, 1)= -2/a^2 - 1/lambda^2;
mid_diag(rg_ds_right, 1) = -2/a^2 - 1/lambda_ds^2;
% density term
mid_diag = mid_diag + density * (e/k_b/T/eps_0/eps);

%mid_diag = ones(n_ges,1) .* (-2/a^2 - 1/lambda^2) + e/eps_0/k_B/T .* phi;
J = spdiags( [side_diag, mid_diag, side_diag], [1,0,-1], n_ges, n_ges);
% edge terms
J(1,2) = 2/a^2;
J(n_ges, n_ges - 1) = 2/a^2;
%% F
% first term d^2 phi/dx^2
    F(1,1) = 2*( phi(2) - phi(1) )/a^2;
    F(n_ges,1) = 2*( phi(n_ges-1) - phi(n_ges) )/a^2;
    for i = 2:n_ges-1
        F(i,1) = (phi(i-1)-2*phi(i)+phi(i+1))/a^2;
    end

% second term phi/lambda^2 
    phi_tmp = phi;

    % drain source
    phi_tmp(rg_ds_left) = phi_tmp(rg_ds_left) / lambda_ds^2;
    phi_tmp(rg_ds_right) = (phi_tmp(rg_ds_right) - e*V_ds )/ lambda_ds^2;
    % channel
    phi_tmp(rg_ch) = (phi_tmp(rg_ch) - phi_bi + phi_g) / lambda^2;

    F = F - phi_tmp;
    
% third term e(rho-N)/?
    dop_dens = dopant_density(E_f_N,m)/area_ch;
    N(rg_ds_left, 1) = dop_dens;
    N(rg_ds_right, 1) = dop_dens;

    F = F - (e/eps_0/eps_ch)*(density-N);
%%
delta_phi = -J\F;
%phi_new = 0.3*delta_phi + phi;