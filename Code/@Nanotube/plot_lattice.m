% Plot graphene lattice and overlay the CNT unit cell and CNT vectors
function plot_lattice(obj, pause_between_points)
    if ~exist('pause_between_points', 'var')
        pause_between_points = 0;
    end
    fig = nanotube.plot_lattice(obj.n, obj.m);
    
    % plot points inside unit cell
    for v_comps = obj.lattice_points_components
        v = nanotube.components_vec2vec_vec(v_comps);
        plot(v(1), v(2), 'Marker', '.', 'MarkerSize', 20, 'color', 'black');
        pause(pause_between_points);
    end
end