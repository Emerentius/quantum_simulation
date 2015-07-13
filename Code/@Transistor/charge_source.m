% Calculate total charge in source (including dopants).
function Q = charge_source(obj)
    e = 1.60217656e-19;
    % nm^-3 to m^-3 to meter conversion
    Q = -e* sum(obj.source.carrier_density - obj.dopant_density )*1e27; 
end