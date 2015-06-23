%% update phi once from new carrier density
% returns the delta phi, saves new phi

% Todo: take n_steps
function delta_phi = update_phi(obj, newton_raphson_step_size)
    initialise_constants;
    %% Extract some relevant data
    eps = obj.source.eps;
    phi = obj.phi;
    
    % like in poisson
    phi_bi = obj.E_g/2 + obj.E_f;
    phi_g = -obj.V_g;
    phi_ds = -obj.V_ds;
    
    a = obj.a;
    T = obj.T;
    lambda = obj.lambda;
    lambda_ds = obj.lambda_ds();
    density = obj.carrier_density(); % column vector
    n_ges = obj.n_ges();
    
    
    %% J new attempt
    J_mid_diag = obj.regioned_vector(-1/lambda_ds^2, -1/lambda^2, -1/lambda_ds^2);
    J_mid_diag = J_mid_diag - 2/a^2;
    % rho = -e*density
    J_mid_diag = J_mid_diag + (-e*density)*helper.to_nm(e/(k_B*T)/eps_0/eps);
    J_side_diag = 1/a^2 * ones(n_ges,1);
    
    J = spdiags([J_side_diag, J_mid_diag, J_side_diag], [1,0,-1], n_ges, n_ges);
    J(1,2)            = 2/a^2;
    J(n_ges, n_ges-1) = 2/a^2;
    %% F new attempt
    % first term
    F = helper.second_derivative_von_neumann(phi, a);
    
    % second term
    F = F - [obj.source.phi / lambda_ds^2; ...
            (obj.gate.phi -phi_bi - phi_g)/lambda^2; ...
            (obj.drain.phi - phi_ds) / lambda_ds^2];
    
    % third term
    N = obj.regioned_vector(obj.dopant_density, 0, obj.dopant_density);
    
    % Note: Originally e^2, 1 e from formula, 1 e from rho = -e*density
    %       one e gone for eV, but an extra minus remains
    F = F - (-1)*(density - N)*helper.to_nm(e/eps_0/eps);
    
    delta_phi = -J\F;
    obj.set_phi(phi + delta_phi*newton_raphson_step_size);
end