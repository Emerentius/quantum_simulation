classdef Nanotube
    properties (GetAccess=public, SetAccess=protected)
        n
        m
        C % position space
        C_components % component vector
        n_p
        m_p
        P % position space
        P_components % component vector
        lattice_points
        lattice_points_components % array of component vectors
        components2num % map taking 'n m is_on_left' string
    end
    
    methods 
        function obj = Nanotube(n,m)
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
     
            counter = 1;
            for atom_components = nanotube.all_lattice_points_inside_and_around_components(n,m);
                if obj.is_inside_unit_cell_components(atom_components)
                    obj.lattice_points(:, counter) = nanotube.components_vec2vec_vec(atom_components);
                    obj.lattice_points_components(:, counter) = atom_components;
                    obj.components2num( num2str(atom_components) ) = counter;
                    counter = counter + 1;
                end
            end
        end
    end
end