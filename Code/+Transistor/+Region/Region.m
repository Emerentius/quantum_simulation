%% Superclass for the classes SourceDrain and Gate, encapsulating
%  variables that every one of these regions has
classdef Region < handle
    properties (GetAccess = public, SetAccess = {?Transistor.Transistor, ?Transistor.Region.Region})
        E_f
        E_g
        m
        lambda
        phi
        carrier_density
        DOS
        range_start
        range_end
    end
    
    methods
        function rg = range(obj)
            rg = obj.range_start:obj.range_end;
        end
    end
end




