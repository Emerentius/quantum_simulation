function [fig, current, subthreshold_slope, iterations] = plot_transfer_characteristic(obj, V_g_range, fig)
    if ~exist('fig', 'var');
        fig = figure;
    else
        figure(fig);
    end
    
    [current, iterations, subthreshold_slope] = obj.transfer_characteristic(V_g_range);
    plot(V_g_range, current);
    xlabel('V_g [V]');
    ylabel('I [A]');
    set(gca, 'yscale', 'log');
end