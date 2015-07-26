%% Compute and save DOS, carrier density, transmission probability and current
function compute_DOS_and_related(obj)
    initialise_constants
    %% natural constant for fermi function inlining
    k_B_eV = 8.6173324e-5;
    
    %% Extract some relevant data
    n_ges = obj.n_ges();
    T = obj.T;
    a = obj.a;
    phi = obj.phi(); % because obj.phi()(1) is impossible in matlab
    n_energy_steps = obj.n_energy_steps;
    
    eta = obj.eta; %1e-8; %0.001*dE; % kann beliebig klein
    
    E_f_source = obj.E_f_source;
    E_f_drain = obj.E_f_drain;
    
    coupling_left = obj.coupling_left;
    coupling_right = obj.coupling_right;
    
    fermi_function = @(E,E_f) 1/(exp( (E-E_f)/k_B_eV/T ) + 1);        
    %%

    % integration limits
    dE = obj.dE;
    energies = obj.energy_range;

    t = obj.t();

    %% preallocate
    density = zeros(n_ges, 1);
    
    DOS = zeros(n_energy_steps+1, n_ges);
    transmission_probability = zeros(n_energy_steps+1,1);

    sigma_source = sparse(1,1,          1, n_ges, n_ges);
    sigma_drain  = sparse(n_ges, n_ges, 1, n_ges, n_ges);
    
    %% precalculate
    minus_H = - spdiags([ -t*ones(n_ges,1), ... % upper diag
                          phi + 2*t,        ... % middle diag
                          -t*ones(n_ges,1), ... % lower diag
                ], ...
                [1,0,-1], n_ges, n_ges);
    %%
    current = 0;

    % first and last vec of unit matrix
    unit_vec_1n = zeros(n_ges, 2);
    unit_vec_1n(1,1)      = 1;
    unit_vec_1n(end, end) = 1;

    for Ej=[energies; 1:length(energies)]
        E = Ej(1);
        jj = Ej(2);
        ka_source = real( acos( 1 + (-E + phi(1    ))/2/t ) );
        ka_drain  = real( acos( 1 + (-E + phi(n_ges))/2/t ) );
        
        E_i_eta = (E+1i*eta) * speye(n_ges);

        % sparse matrices of size n_ges x n_ges, one element
        sigma_source(1, 1)       = coupling_left  * -t*exp(1i*ka_source); %#ok<SPRIX>
        sigma_drain(n_ges,n_ges) = coupling_right * -t*exp(1i*ka_drain ); %#ok<SPRIX>
        
        % invert
        % G = [G_1, G_2, ..., G_n]
        % compute vectors G_1 and G_n only. Both in one go for efficiency.
        G_1n = (minus_H + E_i_eta - sigma_source - sigma_drain) \ unit_vec_1n;
        %%
        % DOS == A/2pi
        % 2 for spin degeneracy
        DOS_source = 2*t*sin(ka_source)/pi * abs(G_1n(:,1).^2) / a;
        DOS_drain  = 2*t*sin(ka_drain )/pi * abs(G_1n(:,end).^2) / a;
        
        %% Save DOS
        DOS(jj,:) = DOS_source.' + DOS_drain.';
        
        fermi_source = fermi_function(E, E_f_source);
        fermi_drain = fermi_function(E, E_f_drain);

        %% integrate carrier density
        % spin degeneracy in DOS_source and _drain
        density  = density + dE*( ...
            DOS_source*fermi_source + ...
            DOS_drain *fermi_drain    ...
        );

        %% Save transmission probability
        % G_1n(1, end) = G(1,n_ges)
        transmission_probability(jj) = 4*t^2*sin(ka_source)*sin(ka_drain)*abs(G_1n(1,end))^2;
        %% compute current
        %  dE*e = dE in J
        %  2 for spin degeneracy
        current = current + dE*e* 2*e/h * ...
                transmission_probability(jj) * ...
                (fermi_source-fermi_drain);
    end
    %% Note: multiply with a to counteract the squaring, divide by area for 3D
    % TODO: factor out 1D and 3D density
    density = density /obj.area_ch;
    %%
    obj.transmission_probability = transmission_probability;
    
    obj.current = current;
    obj.current_is_up_to_date = true;
    obj.set_carrier_density_and_DOS(density, DOS);
end