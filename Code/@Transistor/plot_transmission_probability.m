function plot_transmission_probability(obj, varargin)
    %take or create new figure handle
    fig = helper.check_figure_handle(varargin{:});
    figure(fig);
    
    initialise_constants;
    set(fig, 'name', 'transmission probability');    
    p = plot(obj.energy_range, obj.transmission_probability);
    xlabel('E [eV]');
    ylabel('transmission probability');
end