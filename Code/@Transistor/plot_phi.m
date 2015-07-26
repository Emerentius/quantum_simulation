%% plot methods
function fig = plot_phi(obj, fig)
    if ~exist('fig', 'var')
        fig = figure;
    else
        figure(fig);
    end
    
    set(fig, 'name', 'Phi');
    p = plot(obj.position_range, obj.phi);
    xlabel('Position [nm]');
    ylabel('E [eV]');
end