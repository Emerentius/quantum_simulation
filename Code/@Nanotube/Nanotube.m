classdef Nanotube < handle
    properties (GetAccess=public, SetAccess=protected)
        n
        m
        C % position space
        n_p
        m_p
        P % position space
        k_range
        energy_bands
        valence_band
        conduction_band
    end
    
    % Internal use only
    % Set to public for easy debuggability
    % Set to private for easy usability (tab auto-complete)
    properties (Access = private)
        C_components % component vector
        P_components % component vector
        lattice_points
        lattice_points_components % array of component vectors
        components2num % map taking ['n'; 'm'; 'is_on_left'] string array
    end
        
    methods 
        function obj = Nanotube(n,m, k_steps)
            if ~exist('k_steps', 'var')
                k_steps = 1000;
            end
            
            obj.n = n;
            obj.m = m;
            % Yes, this needs to be on 3 lines. Matlab.
            [n_p, m_p] = nanotube.P_components(n,m);
            obj.n_p = n_p;
            obj.m_p = m_p;
            obj.C = nanotube.C(n,m);
            obj.P = nanotube.P(n,m);
            obj.C_components = nanotube.vec_vec2components_vec(obj.C);
            obj.P_components = nanotube.vec_vec2components_vec(obj.P);

            obj.components2num = containers.Map('KeyType', 'char', 'ValueType', 'double'); % string 'n m' to double
     
            %% Find all lattice points inside CNT unit cell
            cnt = 1; % atom counter
            for atom_comp = nanotube.lattice_points_inside_and_around_components(n,m, 1,0); % padding in x for lattice correction wiggle room
                if obj.is_inside_unit_cell_components(atom_comp)
                    obj.lattice_points_components(:, cnt) = atom_comp;
                    obj.components2num( num2str(atom_comp) ) = cnt;
                    cnt = cnt + 1;
                end
            end
            obj.lattice_points = nanotube.components_vec2vec_vec( obj.lattice_points_components );
            
            %% Compute energy bands
            obj.compute_energy_bands(k_steps);
            
            %% Extract valence and conduction band
            n_bands = size(obj.energy_bands, 1);
            obj.conduction_band = obj.energy_bands(n_bands/2 + 1, :);
            obj.valence_band = obj.energy_bands(n_bands/2, :);
        end
    end
    
    % Internal use only
    % Set to public for easy debuggability
    % Set to private for easy usability (tab auto-complete)
    methods % (Access = private)
        %% For initialisation
        function compute_energy_bands(obj, n_k_steps)
            a = norm(obj.P);
            k_range = linspace(-pi/a, pi/a, n_k_steps);
            E = zeros(obj.atoms_in_unit_cell, length(k_range));
            k_counter = 1;

            [H_prev, H, H_next] = obj.hamiltonians;
            % calculate one half of energy bands
            n_before_middle = int32(floor(n_k_steps/2));
            
            for k = k_range(1: ceil(n_k_steps/2))
                E(:,k_counter) = eig( H + H_next*exp(1i*k*a) + H_prev*exp(-1i*k*a) );
                k_counter = k_counter + 1;
            end
            
            % get other half by mirroring
            E(:, end - n_before_middle + 1 : end) = fliplr( E(:, 1 : n_before_middle) );
            
            %% Save data
            obj.energy_bands = E;
            obj.k_range = k_range;
        end
        
        %% For building hamiltonian matrices
        % If input component vector lies in unit cell or neighbouring unit cell
        % return the equivalent vector in unit cell and P offset of the cell it was
        % in
        % Fails (empty return vector) on component vectors too far away
        function [reduced_vec, valid_neighbour, P_offset] = reduce_neighbour_vec_components(obj, comp_vec)
            P_comp = obj.P_components; % component vec [n; m; is_on_left]
            C_comp = obj.C_components; 

            for C_offset = [0, -1, 1]
                for P_offset = [0, -1, 1]
                    test_vec = comp_vec + C_offset*C_comp + P_offset*P_comp;
                    if obj.is_inside_unit_cell_components( test_vec )
                        valid_neighbour = true;
                        reduced_vec = test_vec;
                        return
                    end
                end
            end

            % no neighbour found
            valid_neighbour = false;
            reduced_vec = [];
            P_offset = [];
        end
        
        %% Convert between vectors and position numbers
        function num = component_vec2num(obj, vec)
            num = obj.components2num(num2str(vec));
        end
        
        function vec = num2component_vec(obj, num)
            vec = obj.lattice_points_components(:, num);
        end
        
        %% Membership tests        
        % Check if the component vector is inside the unit cell of the CNT
        % Takes component vecs of type [n; m; is_on_left_sublattice]
        function is_inside = is_inside_unit_cell_components(obj, components_vec)
            is_inside = nanotube.is_inside_unit_cell_partial_components(components_vec, obj.n,obj.m) && ...
                        nanotube.is_inside_unit_cell_partial_components(components_vec, obj.n_p, obj.m_p);
        end
        
        %% Hamiltonian
        function [H_prev, H, H_next] = hamiltonians(obj)
            H_prev = zeros( obj.atoms_in_unit_cell );
            H =      zeros( obj.atoms_in_unit_cell );
            H_next = zeros( obj.atoms_in_unit_cell );
            t = 3; % eV

            % Iterate through all atoms, for every atom iterate through every
            % neighbour and find number
            % Save in corresponding hamiltonian without phase factor.
            lattice_points = obj.lattice_points_components;
            for lattice_point_num = 1:length(lattice_points)
                atom_comps = lattice_points(:, lattice_point_num);
                % up right, down right, left
                neighbour_offsets = [ [1;0;1], [0;1;1], [0;0;1] ]; % % components
                if atom_comps(3) % is on left sublattice
                    neighbour_offsets = -neighbour_offsets; % everything opposite
                end

                for neighbour = neighbour_offsets + repmat(atom_comps, 1, 3)
                    [reduced_vec, is_valid_neighbour, P_offset] = obj.reduce_neighbour_vec_components(neighbour);
                    if is_valid_neighbour
                        neighbour_num = obj.component_vec2num(reduced_vec);

                        if P_offset == 1
                            H_next(lattice_point_num, neighbour_num) = -t;
                        elseif P_offset == -1
                            H_prev(lattice_point_num, neighbour_num) = -t;
                        else
                                 H(lattice_point_num, neighbour_num) = -t;
                        end
                    end
                end
            end
        end
    end
end