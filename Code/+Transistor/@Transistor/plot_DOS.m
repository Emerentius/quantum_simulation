function plot_DOS(obj, varargin)
    initialise_constants;
    %take or create new figure handle
    fig = helper.check_figure_handle(varargin{:});
    figure(fig);
    
    phi = obj.phi;
    x_range = [1:obj.n_ges]*obj.a;
    
    p = pcolor(x_range, obj.energy_range, obj.DOS);
    %p = surf(x_range, E_range, obj.DOS);
    set(fig, 'name', 'DOS');
    view(2); % X-Y
    shading flat;
    xlabel('Position [nm]');
    ylabel('E [eV]');
end