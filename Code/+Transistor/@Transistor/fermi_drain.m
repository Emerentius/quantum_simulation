function out = fermi_drain(obj, energy)
    out = helper.fermi(energy-obj.E_f_drain(), obj.T);
end