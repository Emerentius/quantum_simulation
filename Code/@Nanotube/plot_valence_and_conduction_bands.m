function fig = plot_valence_and_conduction_bands(obj, fig)
    if ~exist('fig', 'var')
        fig = figure;
    else
        figure(fig);
    end
    
    hold on;
    obj.plot_valence_band(fig);
    obj.plot_conduction_band(fig);
end