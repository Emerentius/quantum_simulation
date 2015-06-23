%% Container class for variables in source and drain
classdef SourceDrain < Transistor.Region.Region
    properties (GetAccess = public, ...
                SetAccess = {?Transistor.Transistor, ...
                             ?Transistor.Region.Region, ...
                             ?Transistor.Region.SourceDrain, ...
                             ?Transistor.Region.Gate} ...
                             )
        eps
    end
    
    methods
        function obj = SourceDrain(eps, E_f, E_g, m, lambda, range_start, range_end)
            % phi, carrier density, DOS are set separately
            % (those aren't constant)
            obj.eps = eps;
            obj.E_f = E_f;
            obj.E_g = E_g;
            obj.m = m;
            obj.lambda = lambda;
            obj.range_start = range_start;
            obj.range_end = range_end;
        end
        
%         % TODO: eV or J
%         function dopant_density = dopant_density_1D(obj, E_f, m);
%             initialise_constants;
%             dopant_density = sqrt(32*obj.m*obj.E_f*e)/h; % <-- Joule call
%         end
    end
end