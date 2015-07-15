% when using higher upper limits, use k_steps less than 1000 or this will
% take forever
are_equal = [];
upper_limit = 5; % 10;
k_steps = 100;
for n = 1:upper_limit
    for m = 0:n-1 % no double counting
        %disp(num2str([n,m, nanotube.atoms_in_unit_cell(n,m)]));
        CNT = Nanotube(n,m, k_steps);
        CNT_rev = Nanotube(m,n, k_steps);
        are_equal(end+1) = all(all( (CNT.energy_bands - CNT_rev.energy_bands) < 1e-10 ));
    end
end
all(are_equal)

% check if armchair nanotubes can be computed
for n = 1:10
    Nanotube(n,n);
end