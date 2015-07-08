% Return row array containing all 2D-vectors to every lattice point inside
% the unit cell and a few surrounding ones
function atoms_array = all_lattice_points_inside_and_around(n,m, padding_x, padding_y)
    if ~exist('padding_x', 'var') && ~exist('padding_y', 'var')
        padding_x = 0;
        padding_y = 0;
    end
    nanotube.initialise_constants;
    
    %% Determine ranges
    C = nanotube.C(n,m);
    P = nanotube.P(n,m);
    
    corners = [ [0;0], C, C+P, P ];
        
    xmin = min(corners(1,:)) - padding_x * d_x;
    xmax = max(corners(1,:)) + padding_x * d_x;
    ymin = min(corners(2,:)) - padding_y * d_y;
    ymax = max(corners(2,:)) + padding_y * d_y;
    
    % lattice corrections
    % [xmin; ymin] may lie outside the lattice
    % causing mismatch between nanotube vectors and lattice
    % this is the case when n+m is uneven
    if mod(n+m,2) ~= 0
        xmin = xmin - d_x/2;
        xmax = xmax - d_x/2;
    end
    
    %% Generate lattice  
    % create array
    % x-position
    % intersperse both sublattices
    
    % left sublattice
    lower_row(1,:) = xmin-a_cc : d_x : xmax-a_cc;
    % right sublattice
    lower_row(2,:) = xmin : d_x : xmax;
    % flatten
    lower_row = lower_row(:)';
    
    % y-position
    lower_row(2,:) = ymin;
    
    % now the upper row
    upper_row(1,:) = lower_row(1,:) + a1(1);
    upper_row(2,:) = ymin + d_y/2;
    
    both_rows = [lower_row, upper_row];
    atoms_array = [];
    
    % while lower row is <= ymax
    % add both rows to array, increase y by d_y
    while both_rows(2,1) <= ymax+0.1*d_y
        atoms_array = [atoms_array, both_rows];
        both_rows(2, :) = both_rows(2, :) + d_y;
    end
end