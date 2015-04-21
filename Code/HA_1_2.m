%voltage_curve_nw = compute_modified_poisson(-1, 10, 'd_ox', 3, 'd_ch', 5, 'geometry', 'nano-wire');
%plot(voltage_curve_nw);

% nanowire
for l_ch=30:-0.1:5
    v_nw_1V = compute_modified_poisson(-1, l_ch, 'd_ox', 3, 'd_ch', 5, 'geometry', 'nano-wire');
    v_nw_0_5V = compute_modified_poisson(-0.5, l_ch, 'd_ox', 3, 'd_ch', 5, 'geometry', 'nano-wire');
    DIBL = (max(v_nw_0_5V) - max(v_nw_1V))/0.5;
    if DIBL < 0.04
        min_l_ch_nw = l_ch;
    end
end

% single gate
for l_ch=30:-0.1:5
    v_sg_1V = compute_modified_poisson(-1, l_ch, 'd_ox', 3, 'd_ch', 5, 'geometry', 'single gate');
    v_sg_0_5V = compute_modified_poisson(-0.5, l_ch, 'd_ox', 3, 'd_ch', 5, 'geometry', 'single gate');
    DIBL = (max(v_sg_0_5V) - max(v_sg_1V))/0.5;
    if DIBL < 0.04
        min_l_ch_sg = l_ch;
    end
end

min_l_ch_nw
min_l_ch_sg