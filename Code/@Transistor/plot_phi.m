%% plot methods
function plot_phi(obj, varargin)
    %take or create new figure handle
    fig = helper.check_figure_handle(varargin{:});
    figure(fig);

    initialise_constants;
    set(fig, 'name', 'Phi');
    p = plot([1:obj.n_ges]*obj.a, obj.phi);
    xlabel('Position [nm]');
    ylabel('E [eV]');
end