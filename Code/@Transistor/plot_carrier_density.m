function fig = plot_carrier_density(obj, fig)
    if ~exist('fig', 'var')
        fig = figure;
    else
        figure(fig);
    end
    
    initialise_constants;
    set(fig, 'name', 'carrier density');    
    p = plot(obj.position_range, obj.carrier_density);
    xlabel('Position [nm]');
    ylabel('Carrier density [nm^{-3}]');
end