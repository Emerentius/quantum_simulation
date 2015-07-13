% EXPERIMENTAL
% calculate effective mass in units of m_e at minimum of conduction band
function m = effective_mass(obj)
    initialise_constants;
    [~, min_idx] = min(obj.conduction_band);
    d2Edk2 = helper.second_derivative(obj.conduction_band, obj.k_range(2) - obj.k_range(1) );
    m = h_bar^2 / d2Edk2( min_idx - 1 ) / e^2 / m_e;
end
    