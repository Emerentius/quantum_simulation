function out = fermi_source(obj, energy)
    out = helper.fermi(energy-obj.E_f_source(), obj.T);
end