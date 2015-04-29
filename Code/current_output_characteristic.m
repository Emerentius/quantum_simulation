function characteristic_line = f(steps, T, V_ds, V_g, varargin)

% logarithmic
I(1:steps) = 0;

for i=1:steps;
    v_ds = (i-1)/steps * V_ds;
    band_curve = poisson(v_ds, V_g, varargin{:});
    current = current_landauer(band_curve, T);
    I(i) = current;
end

characteristic_line = I;