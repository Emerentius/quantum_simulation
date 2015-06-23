function characteristic_line = f(steps, log_or_lin, T, V_ds, V_g, varargin)

% logarithmic
I(1:steps) = 0;
calc_log = strcmp(log_or_lin, 'log');

for i=1:steps;
    v_g = (i-1)/steps * V_g;
    band_curve = poisson(V_ds, v_g, varargin{:});
    current = current_landauer(band_curve, T);
    if calc_log
        I(i) = log10( current );
    else
        I(i) = current;
    end
end

characteristic_line = I;