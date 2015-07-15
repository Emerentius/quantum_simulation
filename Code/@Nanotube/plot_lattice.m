% Plot graphene lattice and overlay the CNT unit cell, CNT vectors and all
% lattice points that are counted as part of the unit cell
function fig = plot_lattice(obj, pause_between_points)
    if ~exist('pause_between_points', 'var')
        pause_between_points = 0;
    end
    fig = nanotube.plot_lattice(obj.n, obj.m);
    
    % plot points inside unit cell
    for v = obj.lattice_points
        plot(v(1), v(2), 'Marker', '.', 'MarkerSize', 20, 'color', 'black');
        pause(pause_between_points);
    end
end