% Plot graphene lattice and overlay the CNT unit cell and CNT vectors
function fig = plot_lattice(n,m)
    fig = figure('name', ['n = ', num2str(n) ', m = ' num2str(m)]);
    xlabel('x [nm]');
    ylabel('y [nm]');
    axis square
    hold on;
    nanotube.initialise_constants;
    
    %% Draw nanotube area
    %  lattice will then be plotted around it
    C = nanotube.C(n,m);
    P = nanotube.P(n,m);
    
    corners = [ [0;0], C, C+P, P ];
    
    % plot ranges
    xrange = [min(corners(1,:))-d_x, max(corners(1,:))+d_x];
    yrange = [min(corners(2,:))-d_y, max(corners(2,:))+d_y];
    
    xlim(xrange);
    ylim(yrange);
    
    x_corners = corners(1,:);
    y_corners = corners(2,:);
    fill(x_corners, y_corners, 'r', 'facealpha', 0.3);
    
    %% plot P and C arrows
    % x, y, vec_x, vec_y, scale, options
    P_arrow = quiver(0,0,P(1),P(2), 0, 'LineWidth', 2, 'Color', 'red');
    C_arrow = quiver(0,0,C(1),C(2), 0, 'LineWidth', 2, 'Color', 'blue');
    legend_h = legend([P_arrow, C_arrow], 'P', 'C');
    set(legend_h, 'EdgeColor', 'white', 'Location', 'northeastoutside');
    
    %% Generate lattice
    %  Iterate along left and bottom border of enclosing rectanlge, 
    %  use those points as start points and walk along the a1-direction
    %  plot lines to all neighbours

    % testing array function
    all_vecs = nanotube.all_lattice_points_inside_and_around(n,m, 2,1);
    right_sublattice = all_vecs(:, 2:2:length(all_vecs));
    for v = right_sublattice
        %while all(v >= [xmin-d_x;ymin-d_y]) && all(v <= [xmax+d_x;ymax+d_y])
            % left
            line([v(1) v(1)-a_cc], [v(2) v(2)]);
            % up right
            line([v(1) v(1)+a1(1)-a_cc], [v(2) v(2)+a1(2)]);
            % down right
            line([v(1) v(1)+a1(1)-a_cc], [v(2) v(2)+a2(2)]);
            
            v = v + a1;
        %end
    end
    
%     
%     xmin = xrange(1);
%     xmax = xrange(2);
%     ymin = yrange(1);
%     ymax = yrange(2);
%     
%     % all x, min y
%     atoms_bottom_edge(1, :) = (xmin:d_x:xmax); %-d_x/2;
%     atoms_bottom_edge(2, :) = ymin;
%     
%     % all y, min x    
%     atoms_left_edge(2, :) = ymin:d_y:ymax;
%     atoms_left_edge(1, :) = xmin; %-d_x/2;
%         
%     % first along y axis, then along x axis    
%     starts = [atoms_left_edge, atoms_bottom_edge];
%     
%     % lattice corrections
%     % [xmin; ymin] may lie outside the lattice
%     % causing mismatch between nanotube vectors and lattice
%     % this is the case when n+m is uneven
%     if mod(n-m,2) ~= 0
%         starts(1,:) = starts(1,:) - d_x/2;
%     end
%     
%     for v = starts
%         while all(v >= [xmin-d_x;ymin-d_y]) && all(v <= [xmax+d_x;ymax+d_y])
%             % left
%             line([v(1) v(1)-a_cc], [v(2) v(2)]);
%             % up right
%             line([v(1) v(1)+a1(1)-a_cc], [v(2) v(2)+a1(2)]);
%             % down right
%             line([v(1) v(1)+a1(1)-a_cc], [v(2) v(2)+a2(2)]);
%             
%             v = v + a1;
%         end
%     end
end