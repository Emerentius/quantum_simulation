% Calculates the 3D dopant density in source and drain
function dop_dens = dopant_density(obj)
    initialise_constants;
    dop_dens = nm*sqrt(32*obj.m*obj.E_f*eV)/h/obj.area_ch;
end