function out = fermi_gate(obj, energy)
    out = helper.fermi(energy-obj.E_f_gate(), obj.T);
end