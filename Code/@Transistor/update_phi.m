%% update phi once from new carrier density
% returns the delta phi, saves new phi

% Todo: take n_steps
function delta_phi = update_phi(obj)
    initialise_constants;
    %% Extract some relevant data
    newton_step_size = obj.newton_step_size;
    eps = obj.eps_ch;
    phi = obj.phi;
    
    a = obj.a;
    T = obj.T;
    lambda = obj.lambda;
    lambda_ds = obj.lambda_ds();
    density = obj.carrier_density(); % column vector
    n_ges = obj.n_ges();
    %% J
    J_mid_diag = obj.regioned_vector(-1/lambda_ds^2, -1/lambda^2, -1/lambda_ds^2) ...
                 -2/a^2;
    % rho = -e*carrier_density + e*dopant_density
    % dopant_density falls away due to differentiation
    J_mid_diag = J_mid_diag + helper.m_to_nm(e/k_B/T/eps_0/eps)*(-e*density);
    J_side_diag = 1/a^2 * ones(n_ges,1);
    
    J = spdiags([J_side_diag, J_mid_diag, J_side_diag], [1,0,-1], n_ges, n_ges);
    J(1,2)            = 2/a^2;
    J(n_ges, n_ges-1) = 2/a^2;
    
    for jjj = 1:15
        %% F
        % first term
        F = helper.second_derivative_von_neumann(phi, a);

        % second term
        F = F - [phi(obj.source.range) / lambda_ds^2; ...
                (phi(obj.gate.range) - obj.phi_bi - obj.phi_g)/lambda^2; ...
                (phi(obj.drain.range) - obj.phi_ds) / lambda_ds^2];

        % third term
        dop_density = obj.regioned_vector(obj.dopant_density, 0, obj.dopant_density);

        % One e gone for eV
        % rho = -e*density + e*dop_density      
        F = F - (-density + dop_density)*helper.m_to_nm(e/eps_0/eps);

        delta_phi = -J\F;
        phi = phi + delta_phi * newton_step_size;
        % obj.set_phi(obj.phi + delta_phi*newton_raphson_step_size);
    end
    obj.set_phi(phi);
end