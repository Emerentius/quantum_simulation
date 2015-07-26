%% Calculate subthreshold slope from the first n (5 default) elements
function slope = subthreshold_slope(voltages, currents, n_element)
    if ~exist('n_element', 'var')
        n_element = 5;
    end
    if length(currents) < n_element || length(voltages) < n_element
        error('too few elements in currents or voltages');
    end
    if n_element == 1
        error('can'' calculate slope from 1 element');
    end
    log_currents = log10(currents);
    slope = (voltages(n_element) - voltages(1) )/(log_currents(n_element)- log_currents(1)); % eV / dec
end