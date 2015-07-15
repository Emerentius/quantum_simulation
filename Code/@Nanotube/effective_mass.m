% Calculate effective mass at minimum of conduction band.
% Optional second return value: effective mass for every k-value
function [m, d2Edk2] = effective_mass(obj)
    initialise_constants;
    [~, min_idx] = min(obj.conduction_band);
    d2Edk2 = helper.second_derivative(obj.conduction_band, (obj.k_range(2) - obj.k_range(1))*1e9 ); % 1/nm to 1/m
    m = h_bar^2 / d2Edk2( min_idx - 1 ) / e;
end
    