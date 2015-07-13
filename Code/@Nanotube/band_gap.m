function E_g = band_gap(obj)
    E_g = min(obj.conduction_band) - max(obj.valence_band);
end