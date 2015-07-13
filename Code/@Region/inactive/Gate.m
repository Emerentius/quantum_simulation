%% Container class for variables in gate
classdef Gate < Transistor.Region.Region
    properties (GetAccess = public, ...
                SetAccess = {?Transistor.Transistor, ...
                             ?Transistor.Region.Region, ...
                             ?Transistor.Region.SourceDrain, ...
                             ?Transistor.Region.Gate} ...
                             )

    end
    
    methods
        function obj = Gate(d_ch, d_ox, eps_ch, eps_ox, E_g, lambda, range_start, range_end)
            % phi, carrier density, DOS are set separately
            % (those aren't constant)
            obj.d_ch = d_ch;
            obj.d_ox = d_ox;
            obj.eps_ch = eps_ch;
            obj.eps_ox = eps_ox;
            obj.E_g = E_g;
            obj.lambda = lambda;
            obj.range_start = range_start;
            obj.range_end = range_end;
        end
    end
end