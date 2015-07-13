% TODO: - look at dimensions, where is the 1e9 (nm) factor coming in?
%       - dimensions of DOS in particular
%% Carrier Density
function density = carrier_density(obj)
    if obj.phi_changed_since_DOS_calculation
       % phi and DOS inconsistent, recalculate carrier_density
       obj.compute_carrier_density_and_DOS();
    end
    density = [obj.source.carrier_density; ...
               obj.gate.carrier_density;   ...
               obj.drain.carrier_density];
end