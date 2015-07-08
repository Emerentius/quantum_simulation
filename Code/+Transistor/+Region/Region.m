%% Superclass for the classes SourceDrain and Gate, encapsulating
%  variables that every one of these regions has
classdef Region < handle
    properties (GetAccess = public, SetAccess = {?Transistor.Transistor, ?Transistor.Region.Region})
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




