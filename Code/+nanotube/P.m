function P = P(n,m)
    nanotube.initialise_constants;
    %a1 = [sqrt(3); +1]/2;
    %a2 = [sqrt(3); -1]/2; 
    
    [n_p, m_p] = nanotube.P_components(n,m);
    P = n_p * a1 + m_p * a2;
end

