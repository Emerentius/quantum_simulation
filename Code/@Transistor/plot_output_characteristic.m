function [fig, current, iterations] = plot_output_characteristic(obj, V_ds_range, fig)
    if ~exist('fig', 'var');
        fig = figure;
    else
        figure(fig);
    end
    
    [current, iterations] = obj.output_characteristic(V_ds_range);
    plot(V_ds_range, current);
    xlabel('$V_{ds}$ [V]', 'interpreter', 'latex');
    ylabel('I [A]');
end