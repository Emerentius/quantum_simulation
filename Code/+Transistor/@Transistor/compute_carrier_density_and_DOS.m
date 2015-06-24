% TODO: - look at dimensions, where is the 1e9 (nm) factor coming in?
%       - dimensions of DOS in particular
%% Carrier Density
function density = compute_carrier_density_and_DOS(obj)
    initialise_constants
    %% avoid recalculating
%             if (~obj.phi_changed_since_DOS_calculation) && (obj.n_energy_steps_last == n_energy_steps)
%                 density = obj.carrier_density_cache;
%                 return
%             end
    %% Extract some relevant data
    n_ges = obj.n_ges();
    T = obj.T;
    a = obj.a;
    phi = obj.phi(); % because obj.phi()(1) is impossible in matlab
    n_energy_steps = obj.n_energy_steps;
    %%

    % Integrationsgrenzen
    % Note: only one E_f is saved and relative to the conduction band
    E_min = min(phi); % == min(0, -V_ds)
    E_max = max([obj.E_f_source, obj.E_f_drain, max(phi)])+helper.to_eV(5*k_B*T);

    %dE = 5e-4*e;
    dE = (E_max-E_min)/n_energy_steps;
    energies = E_min : dE : E_max;
    eta = 0.001*dE; % kann beliebig klein

    t = obj.t();

    % expands to vector later
    density = 0;
    % preallocate
    DOS = zeros(n_energy_steps+1, n_ges);
    for Ej=[energies; 1:length(energies)]
        E = Ej(1);
        j = Ej(2);
        ka_source = real( acos( 1 + (-E + phi(1    ))/2/t ) );
        ka_drain  = real( acos( 1 + (-E + phi(n_ges))/2/t ) );
        
        E_i_eta = (E+1i*eta) * speye(n_ges);
        H = spdiags([ -t * ones(n_ges, 1), ... % upper diag
                      phi + 2*t,           ... % middle diag
                      -t * ones(n_ges, 1), ... % lower diag
                     ], ...
                    [1,0,-1], n_ges, n_ges);
        % sparse matrices of size n_ges by n_ges, one element
        sigma_source = sparse(1,1,          -t*exp(1i*ka_source), n_ges, n_ges);
        sigma_drain  = sparse(n_ges, n_ges, -t*exp(1i*ka_drain ), n_ges, n_ges);
         
        G = 1/a * inv( E_i_eta - H - sigma_source - sigma_drain );
        
        % DOS == A/2pi
        DOS_source = t*sin(ka_source)/pi * abs(G(:, 1    ).^2);
        DOS_drain  = t*sin(ka_drain )/pi * abs(G(:, n_ges).^2);
        
        %% Save DOS
        %DOS(j,:) = -imag(diag(G)).';
        DOS(j,:) = DOS_source.' + DOS_drain.';
        %% integrate DOS for carrier density
        density  = density + dE*( ...
            DOS_source*obj.fermi_source(E) + ...
            DOS_drain *obj.fermi_drain(E)    ...
        );
    end
    %% Note: multiply with a to counteract the squaring, divide by area for 3D
    % TODO: factor out 1D and 3D density
    % 2 for spin degeneracy
    density = 2*density * a /obj.area_ch;
    %%
    obj.set_carrier_density_and_DOS(density, DOS);
end