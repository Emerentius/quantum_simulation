function plot_carrier_density(obj, varargin)
    %take or create new figure handle
    fig = helper.check_figure_handle(varargin{:});
    figure(fig);
    
    initialise_constants;
    set(fig, 'name', 'carrier density');    
    p = plot([1:obj.n_ges]*obj.a, obj.carrier_density);
    xlabel('Position [nm]');
    ylabel('Carrier density [nm^{-3}]');
end