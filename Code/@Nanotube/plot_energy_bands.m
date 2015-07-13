function fig = plot_energy_bands(obj, fig)
    if ~exist('fig', 'var')
        fig = figure;
    else
        figure(fig);
    end

    plot(obj.k_range, obj.energy_bands, 'color', 'blue');
    xlim([obj.k_range(1) obj.k_range(end)]);
    xlabel('$k_{||}$ [1/nm]', 'interpreter', 'latex');
    ylabel('E [eV]');
end