[n1,m1] = deal(5,2);
[n2,m2] = deal(7,5);

C1 = nanotube.C(n1,m1);
P1 = nanotube.P(n1,m1);
C2 = nanotube.C(n2,m2);
P2 = nanotube.P(n2,m2);

disp(['d1 = ' num2str(norm(C1)/pi) ' nm']); % Circumference = pi*diameter
disp(['d2 = ' num2str(norm(C2)/pi) ' nm']);

% metallic if (n-m)/3 is integer
is_metallic_1 = nanotube.is_metallic(n1,m1)
is_metallic_2 = nanotube.is_metallic(n2,m2)

% k-ranges
% k = k_|| + k_|_
% C,P orthogonal => reciprocal lattice orthogonal
k_orth_max_1 = 2*pi/norm(C1) / 2;
k_par_max_1 = 2*pi/norm(P1) / 2;
disp(['k_||_max_1 = (' num2str(-k_orth_max_1) '..' num2str(k_orth_max_1) ')/nm']);
disp(['k_|__max_1 = (' num2str(-k_par_max_1) '..' num2str(k_par_max_1) ')/nm']);

k_orth_max_2 = 2*pi/norm(C2) / 2;
k_par_max_2 = 2*pi/norm(P2) / 2;
disp(['k_||_max_2 = (' num2str(-k_orth_max_2) '..' num2str(k_orth_max_2) ')/nm']);
disp(['k_|__max_2 = (' num2str(-k_par_max_2) '..' num2str(k_par_max_2) ')/nm']);