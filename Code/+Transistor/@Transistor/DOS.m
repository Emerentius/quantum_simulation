%% Access DOS.
% Note: Arbitrary units, not correct dimensions
function dos = DOS(obj)
    if obj.phi_changed_since_DOS_calculation
       % phi and DOS inconsistent, recalculate DOS
       obj.compute_carrier_density_and_DOS();
    else 
    dos = [obj.source.DOS, obj.gate.DOS, obj.drain.DOS];
end