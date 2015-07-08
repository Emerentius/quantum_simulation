% TODO: - look at dimensions, where is the 1e9 (nm) factor coming in?
%       - dimensions of DOS in particular
%% Carrier Density
function density = compute_carrier_density_and_DOS(obj)
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
    dE = obj.dE; %(E_max-E_min)/n_energy_steps;
    energies = obj.energy_range; %E_min : dE : E_max;
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
         
        %G = 1/a * inv( E_i_eta - H - sigma_source - sigma_drain );
        %G = inv( E_i_eta - H - sigma_source - sigma_drain );
        G = inv( minus_H + E_i_eta - sigma_source - sigma_drain);
        %% Save transmission probability
        % Todo: check dimensions
        obj.transmission_probability(jj) = 4*t^2*sin(ka_source)*sin(ka_drain)*abs(G(1,n_ges))^2; % * a^2;
        %%
        % DOS == A/2pi
        DOS_source = t*sin(ka_source)/pi * abs(G(:, 1    ).^2)  / a;
        DOS_drain  = t*sin(ka_drain )/pi * abs(G(:, n_ges).^2)  / a;
        
        %% Save DOS
        %DOS(jj,:) = -imag(diag(G))/a;
        DOS(jj,:) = DOS_source.' + DOS_drain.';
        %% integrate DOS for carrier density
%         correct but slow
%         density  = density + dE*( ...
%             DOS_source*obj.fermi_source(E) + ...
%             DOS_drain *obj.fermi_drain(E)    ...
%         );

        % inlined fermi function
        
        if T == 0 
            % this is necessary, because the calculation below breaks down
            % for T = 0 and returns NaN.
            if (E-E_f_source) == 0 
                fermi_source = 0.5;
            elseif (E-E_f_source) < 0
                fermi_source = 1;
            else
                fermi_source = 0;
            end
            
            if (E-E_f_drain) == 0
                fermi_drain = 0.5;
            elseif (E-E_f_drain) < 0
                fermi_drain = 1;
            else
                fermi_drain = 0;
            end
        else
        	fermi_source = 1/(exp( (E-E_f_source)/k_B_eV/T ) + 1);
        	fermi_drain  = 1/(exp( (E-E_f_drain)/k_B_eV/T ) + 1);
        end
        
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