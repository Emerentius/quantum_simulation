function J_out = J(obj)
    initialise_constants;
    %% Extract some relevant data
    eps = obj.source.eps;
    % Todo: factor out maybe?
    
    a = obj.a;
    T = obj.T;
    lambda = obj.lambda;
    lambda_ds = obj.lambda_ds();
    n_ges = obj.n_ges();
    %%
    
    %% J new attempt
    J_mid_diag = obj.regioned_vector(-1/lambda_ds^2, -1/lambda^2, -1/lambda_ds^2);
    J_mid_diag = J_mid_diag - 2/a^2;
    % rho = -e*density
    % Note: sign like in transparencies (+) so likely wrong
    J_mid_diag = J_mid_diag + obj.rho()*helper.to_nm(e/(k_B*T)/eps_0/eps);
    J_side_diag = 1/a^2 * ones(n_ges,1);
    
    J_out = spdiags([J_side_diag, J_mid_diag, J_side_diag], [1,0,-1], n_ges, n_ges);
    J_out(1,2)            = 2/a^2;
    J_out(n_ges, n_ges-1) = 2/a^2;
end