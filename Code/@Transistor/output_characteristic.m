function [current, iterations] = output_characteristic(obj, V_ds_range)
    current = zeros(length(V_ds_range), 1);
    iterations = zeros(length(V_ds_range), 1);
    
    for Vdsjj = [V_ds_range; 1:length(V_ds_range)]
        V_ds = Vdsjj(1);
        jj = Vdsjj(2);
        obj.set_V_ds(V_ds);
        iterations(jj) = obj.make_self_consistent;
        current(jj) = obj.current;
    end
end