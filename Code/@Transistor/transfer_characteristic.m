function [current, iterations, subthreshold_slope] = transfer_characteristic(obj, V_g_range)
    current = zeros(length(V_g_range), 1);
    iterations = zeros(length(V_g_range), 1);
    
    for Vgjj = [V_g_range; 1:length(V_g_range)]
        V_g = Vgjj(1);
        jj = Vgjj(2);
        obj.set_V_g(V_g);
        iterations(jj) = obj.make_self_consistent;
        current(jj) = obj.current;
    end
    
    subthreshold_slope = helper.subthreshold_slope(V_g_range, current);
end