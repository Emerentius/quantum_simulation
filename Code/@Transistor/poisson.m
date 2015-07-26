%% Poisson
% calculates conduction band
% assuming no carrier concentration
% output in eV (energy for an electron)
function phi = poisson(obj)             
    %% extracting relevant data (shorter names)
    a = obj.a;
    n_ges = obj.n_ges();
    %%

    side_diag = ones(n_ges, 1)/a^2;
    middle_diag = obj.regioned_vector(-1/obj.lambda_ds^2, ...
                                      -1/obj.lambda^2,    ...
                                      -1/obj.lambda_ds^2) ...
                  - 2/a^2;
                                  
    M = spdiags([side_diag, middle_diag, side_diag], [1,0,-1], n_ges, n_ges);
    M(1,2)            = 2/a^2;
    M(n_ges, n_ges-1) = 2/a^2;
    
    % vec = e/eps * rho + phi_offsets, assuming rho = 0 everywhere
    % signs inverted compared to transparencies, lecture 1, pg 35
    % seems to me like they are wrong, one minus gets lost from previous
    % slide
    vec = obj.regioned_vector(0,                        ...
                              -(obj.phi_g+obj.phi_bi)/obj.lambda^2, ...
                              -obj.phi_ds/obj.lambda_ds^2);

    phi = M\vec;
end