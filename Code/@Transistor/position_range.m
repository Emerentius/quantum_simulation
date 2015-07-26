function pos_range = position_range(obj)
    pos_range = [1:obj.n_ges]*obj.a; % - 0.5 * obj.a <-- actual position
end