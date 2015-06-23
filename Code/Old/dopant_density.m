function dopant_density = dopant_density(E_f, m);
    initialise_constants;
    dopant_density = sqrt(32*m*E_f)/h;
end