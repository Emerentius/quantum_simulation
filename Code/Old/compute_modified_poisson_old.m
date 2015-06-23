function voltage = compute_modified_poisson(V_ds, V_g,  l_ch, varargin)
%p = inputParser;
%addRequired(p, V_ds, -1);
%addOptional(p, V_g, 0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
E_f = 0.1;
E_g = 1;
phi_bi = -(E_f + E_g/2); % == -0.55
%V_ds = -1;
%V_g = -1;
phi_ds = -V_ds;
phi_g = -V_g;

% Punktabstand
a = 0.5;
d_ch = 5;
d_ox = 5;
eps_ox = 3.9;
eps_ch = 11.2;

% single gate
%lambda = sqrt(d_ox*d_ch*eps_ch/eps_ox);

% double gate
lambda = sqrt(d_ox*d_ch*eps_ch/eps_ox/2);

% wrap-gate (nanowire)
%lambda = sqrt( eps_ch * d_ch*d_ch / 8 / eps_ox * ln(1+ 2*d_ox/d_ch) )  

lambda_ds = lambda; %0.2*lambda;
%l_ch = 30; %5*lambda;
l_ds = 4*lambda_ds;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% parse overrides
%
 
 	for k= 1:2:length(varargin);
         switch (varargin{k})
             case {'geometry'}
                 switch (varargin{k+1})
                     case {'single gate'}
                        lambda = sqrt(d_ox*d_ch*eps_ch/eps_ox);
                     case {'double gate'}
                         lambda = sqrt(d_ox*d_ch*eps_ch/eps_ox/2);
                     case {'triple gate'}
                         lambda = sqrt(d_ox*d_ch*eps_ch/eps_ox/3);
                     case {'nano-wire'}
                         lambda = sqrt( eps_ch * d_ch*d_ch / 8 / eps_ox * log(1+ 2*d_ox/d_ch) );
                 end
             case {'d_ox'}
                 d_ox = varargin{k+1};
             case {'d_ch'}
                 d_ch = varargin{k+1};
             case {'eps_ox'}
                 eps_ox = varargin{k+1};
             case {'a'} % lattice
                 a = varargin{k+1};
         end; 
     end; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
n_ds = floor(l_ds / a);
n_ch = floor(l_ch / a);
n_ges = 2*n_ds + n_ch;
l_ges = l_ch + 2*l_ds;

% Nullen verschwinden in fertiger Matrix
upper_diag = [0;2; ones(n_ges-2, 1)]/a^2;
lower_diag = [ones(n_ges-2,1); 2; 0]/a^2;
middle_diag = [ones(n_ds, 1)*(-2/a^2 - 1/lambda_ds^2);
               ones(n_ch, 1)*(-2/a^2 - 1/lambda^2);
               ones(n_ds, 1)*(-2/a^2 - 1/lambda_ds^2);
               ];
M = spdiags([upper_diag, middle_diag, lower_diag], [1,0,-1], n_ges, n_ges);

vec(1:n_ds, 1) = 0/lambda_ds^2;
vec(n_ds+1:n_ds+n_ch, 1) = (phi_g+phi_bi)/lambda^2;
vec(n_ds+n_ch+1 : n_ges, 1) = phi_ds/lambda_ds^2;

voltage = inv(M)*vec;