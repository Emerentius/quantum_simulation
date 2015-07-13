%% plot methods
function plot_phi(obj, fig)
    if ~exist('fig', 'var')
        fig = figure;
    else
        figure(fig);
    end
    
    initialise_constants;
    set(fig, 'name', 'Phi');
    p = plot([1:obj.n_ges]*obj.a, obj.phi);
    xlabel('Position [nm]');
    ylabel('E [eV]');
end