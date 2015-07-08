%
% Currently not used, may not be up to date
%
function F_out = F(obj)
    initialise_constants;
    %% Extract some relevant data
    eps = obj.source.eps;
    
    % like in poisson
    phi_bi = obj.E_g/2 + obj.E_f;
    phi_g = -obj.V_g;
    phi_ds = -obj.V_ds;
    
    density = obj.carrier_density(); % column vector
    %%
    % first term
    F_out = helper.second_derivative_von_neumann(obj.phi, obj.a);
    
    % second term
    F_out = F_out - [obj.source.phi / obj.lambda_ds^2; ...
            (obj.gate.phi -phi_bi - phi_g)/obj.lambda^2; ...
            (obj.drain.phi - phi_ds) / obj.lambda_ds^2];
    
    % third term
    N = obj.regioned_vector(obj.dopant_density, 0, obj.dopant_density);
    
    % Note: Originally e^2, 1 e from formula, 1 e from rho = -e*density
    %       one e gone for eV, but an extra minus remains
    F_out = F_out - (-1)*(density - N)*helper.to_nm(e/eps_0/eps);
end