%% Class for source, gate and drain.
classdef Region < handle
    properties (GetAccess = public, SetAccess = {?Transistor, ?Region})
        phi
        carrier_density
        DOS
        range_start
        range_end
    end
    
    methods
        function obj = Region(range_start, range_end)
            % phi, carrier density, DOS are set separately
            % (those aren't constant)
            obj.range_start = range_start;
            obj.range_end = range_end;
        end
        
        function rg = range(obj)
            rg = obj.range_start:obj.range_end;
        end
    end
end




