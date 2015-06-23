%voltage_curve_nw = compute_modified_poisson(-1, 10, 'd_ox', 3, 'd_ch', 5, 'geometry', 'nano-wire');
%plot(voltage_curve_nw);

pos_args = {0, 5, 3} % necessary arguments, V_g, d_ch, d_ox
options = {'a', 0.5, 'l_ds', '4 lambda'};

% nanowire
for l_ch=30:-0.1:5
    v_nw_1V = poisson(-1, pos_args{:}, 'l_ch', l_ch, 'geometry', 'nano-wire');
    v_nw_0_5V = poisson(-0.5, pos_args{:}, 'l_ch', l_ch, 'geometry', 'nano-wire');
    DIBL = (max(v_nw_0_5V) - max(v_nw_1V))/0.5;
    if DIBL < 0.04
        min_l_ch_nw = l_ch;
    end
end

% single gate
for l_ch=30:-0.1:5
    v_sg_1V = poisson(-1, pos_args{:}, 'l_ch', l_ch, 'geometry', 'single gate');
    v_sg_0_5V = poisson(-0.5, pos_args{:}, 'l_ch', l_ch, 'geometry', 'single gate');
    DIBL = (max(v_sg_0_5V) - max(v_sg_1V))/0.5;
    if DIBL < 0.04
        min_l_ch_sg = l_ch;
    end
end

% print required lengths
min_l_ch_nw
min_l_ch_sg