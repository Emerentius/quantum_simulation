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
        function obj = SourceDrain(eps, E_g, lambda, range_start, range_end)
            % phi, carrier density, DOS are set separately
            % (those aren't constant)
            obj.eps = eps;
            obj.E_g = E_g;
            obj.lambda = lambda;
            obj.range_start = range_start;
            obj.range_end = range_end;
        end
    end
end