% Diameter of nanotube defined by chiral vector n*a1 + m*a2
function d = diameter(n,m)
    d = norm(nanotube.C(n,m))/pi;
end