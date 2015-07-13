function I = current(obj)
    e = 1.602176565e-19;
    h = 6.62606957e-34;

    energy_range = obj.energy_range;
    dE = obj.dE;
    I = 0;
    trans = obj.transmission_probability;
    for Ej = [energy_range; 1:length(energy_range)]
        E = Ej(1);
        jj = Ej(2);
        % 2*e/h is the prefactor of v(E)D(E)
        % todo: why factor of e?
        I = I + dE*e* 2*e/h * ...
                trans(jj) * ...
                (obj.fermi_source(E)-obj.fermi_drain(E)); 
    end
end