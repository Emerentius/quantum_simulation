function plot_DOS(obj, varargin)
    %take or create new figure handle
    fig = helper.check_figure_handle(varargin{:});
    figure(fig);
    
    initialise_constants;
    % todo: factor out energy calculations
    phi = obj.phi;
    E_min = min(phi);
    E_max = max([obj.E_f_source, obj.E_f_drain, max(phi)])+5*k_B*obj.T/eV;
    dE = (E_max-E_min)/obj.n_energy_steps;
    E_range = E_min:dE:E_max;
    x_range = [1:obj.n_ges]*obj.a;
    
    p = pcolor(x_range, E_range, obj.DOS);
    %p = surf(x_range, E_range, obj.DOS);
    set(fig, 'name', 'DOS');
    view(2); % X-Y
    shading flat;
    xlabel('Position [nm]');
    ylabel('E [eV]');
end