function fig = check_figure_handle(varargin)
    if length(varargin) > 1
            err('This function takes no arguments or a figure handle')
    elseif length(varargin) == 1
        fig = varargin{1};
        if ~isa(fig, 'matlab.ui.Figure')
            err('Argument is not a figure handle')
        end
        figure(fig);
    else
        fig = figure();
    end
end