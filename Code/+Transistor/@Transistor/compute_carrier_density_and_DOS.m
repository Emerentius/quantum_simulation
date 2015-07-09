% TODO: - look at dimensions, where is the 1e9 (nm) factor coming in?
%       - dimensions of DOS in particular
%% Carrier Density
function compute_carrier_density_and_DOS(obj)
    %% avoid recalculating
    if (~obj.phi_changed_since_DOS_calculation)
         return
    end

    initialise_constants
    %% natural constant for fermi function inlining
    k_B_eV = 8.6173324e-5;
    
    %% Extract some relevant data
    n_ges = obj.n_ges();
    T = obj.T;
    a = obj.a;
    phi = obj.phi(); % because obj.phi()(1) is impossible in matlab
    n_energy_steps = obj.n_energy_steps;
    
    E_f_source = obj.E_f_source;
    E_f_drain = obj.E_f_drain;
    %%

    % Integrationsgrenzen
    dE = obj.dE;
    energies = obj.energy_range;
    eta = 0.001*dE; % kann beliebig klein

    t = obj.t();

    %% preallocate
    density = zeros(n_ges, 1);
    
    DOS = zeros(n_energy_steps+1, n_ges);
    obj.transmission_probability = zeros(n_energy_steps+1,1);
    %% precalculate
    minus_H = - spdiags([ -t*ones(n_ges,1), ... % upper diag
                          phi + 2*t,        ... % middle diag
                          -t*ones(n_ges,1), ... % lower diag
                ], ...
                [1,0,-1], n_ges, n_ges);
    %%
    for Ej=[energies; 1:length(energies)]
        E = Ej(1);
        jj = Ej(2);
        ka_source = real( acos( 1 + (-E + phi(1    ))/2/t ) );
        ka_drain  = real( acos( 1 + (-E + phi(n_ges))/2/t ) );
        
        E_i_eta = (E+1i*eta) * speye(n_ges);

        % sparse matrices of size n_ges by n_ges, one element
        sigma_source = sparse(1,1,          -t*exp(1i*ka_source), n_ges, n_ges);
        sigma_drain  = sparse(n_ges, n_ges, -t*exp(1i*ka_drain ), n_ges, n_ges);
        
        % invert
        G = ( minus_H + E_i_eta - sigma_source - sigma_drain) \ eye(n_ges);
        %% Save transmission probability
        obj.transmission_probability(jj) = 4*t^2*sin(ka_source)*sin(ka_drain)*abs(G(1,n_ges))^2;
        %%
        % DOS == A/2pi
        DOS_source = t*sin(ka_source)/pi * abs(G(:, 1    ).^2) / a;
        DOS_drain  = t*sin(ka_drain )/pi * abs(G(:, n_ges).^2) / a;
        
        %% Save DOS
        DOS(jj,:) = DOS_source.' + DOS_drain.';
        %% inlined fermi function for carrier density integration
        % external function calls are very expensive
        fermi_source = 1/(exp( (E-E_f_source)/k_B_eV/T ) + 1);
        fermi_drain  = 1/(exp( (E-E_f_drain)/k_B_eV/T ) + 1);
        if T == 0 
            % this is necessary, because the calculation above breaks down
            % for T = 0 and returns NaN.
            if (E-E_f_source) == 0 
                fermi_source = 0.5;
            end

            if (E-E_f_drain) == 0
                fermi_drain = 0.5;
            end
        end
        %% integrate carrier density
        % 2 for spin degeneracy
        density  = density + 2*dE*( ...
            DOS_source*fermi_source + ...
            DOS_drain *fermi_drain    ...
        );

    end
    %% Note: multiply with a to counteract the squaring, divide by area for 3D
    % TODO: factor out 1D and 3D density
    density = density /obj.area_ch;
    %%
    obj.set_carrier_density_and_DOS(density, DOS);
end