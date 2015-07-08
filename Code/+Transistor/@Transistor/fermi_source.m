function out = fermi_source(obj, energy)
    %out = helper.fermi(energy-obj.E_f_source(), obj.T);
    
    % copied from helper.fermi
    k_B = 8.6173324e-5;
    if obj.T == 0 
       % this is necessary, because the calculation below breaks down
       % for T = 0 and returns NaN.
       if E == 0 
           out = 0.5;
       elseif E < 0
           out = 1;
       else
           out = 0;
       end
    else
       out = 1/(exp( (energy-obj.E_f_source)/k_B/obj.T ) + 1);
    end
end