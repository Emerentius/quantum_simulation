function fig = plot_transmission_probability(obj, fig)
    if ~exist('fig', 'var')
        fig = figure;
    else
        figure(fig);
    end
    
    initialise_constants;
    set(fig, 'name', 'transmission probability');    
    p = plot(obj.energy_range, obj.transmission_probability);
    xlabel('E [eV]');
    ylabel('transmission probability');
end