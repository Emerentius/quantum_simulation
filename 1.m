clear;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
E_f = 0.1;
E_g = 1;
phi_bi = -(E_f + E_g/2);
V_ds = -1;
phi_ds = -V_ds;
phi_g = 0;

a = 0.5;
d_ch = 2;
d_ox = 3;
eps_ox = 4;
eps_ch = 11.2;
lambda = sqrt(d_ox*d_ch*eps_ch/eps_ox)
lambda_sd = 0.2*lambda;
l_ch = 5*lambda;
l_sd = 6*lambda_sd;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

n_sd = floor(l_sd / a);
n_ch = floor(l_ch / a);
n_ges = 2*n_sd + n_ch;
l_ges = l_ch + 2*l_sd

% Nullen verschwinden in fertiger Matrix
upper_diag = [0;2; ones(n_ges-2, 1)]/a^2;
lower_diag = [ones(n_ges-2,1); 2; 0]/a^2;
middle_diag = [ones(n_sd, 1)*(-2/a^2 - 1/lambda_sd^2);
               ones(n_ch, 1)*(-2/a^2 - 1/lambda^2);
               ones(n_sd, 1)*(-2/a^2 - 1/lambda_sd^2);
               ];
M = spdiags([upper_diag, middle_diag, lower_diag], [1,0,-1], n_ges, n_ges);

vec(1:n_sd, 1) = 0/lambda_sd^2;
vec(n_sd+1:n_sd+n_ch, 1) = (phi_g+phi_bi)/lambda^2;
vec(n_sd+n_ch+1 : n_ges, 1) = phi_ds/lambda_sd^2;

plot(1:n_ges, inv(M)*vec)