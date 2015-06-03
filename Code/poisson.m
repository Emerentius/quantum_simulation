function voltage = compute_modified_poisson(V_ds, V_g,  d_ch, d_ox, varargin)
initialise_constants;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Silizium
E_f_def = 0.1*eV;
E_g_def = 1*eV;

% Punktabstand
a_def = 0.5*nm;

lambda_ds_def = '1 lambda'; % in lambda_ch

l_ch_def = '5 lambda';
l_ds_def = '5 lambda'; % in lambda_ds

geometry_def = 'single gate';

% Silizium
eps_ox_def = eps_sio2;
eps_ch_def = eps_si;

expected_geometry = {'single gate','double gate','triple gate', 'tri-gate', 'nano-wire', 'nanowire'};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% parse input
p = inputParser;
is_numeric_scalar = @(x) isnumeric(x) && isscalar(x);
is_numeric_scalar_or_string = @(x) is_numeric_scalar(x) || ischar(x);

% required arguments
addRequired(p, 'V_ds', is_numeric_scalar);
addRequired(p, 'V_g', is_numeric_scalar); 
addRequired(p, 'd_ch', is_numeric_scalar);
addRequired(p, 'd_ox', is_numeric_scalar);

% overrides
addOptional(p, 'E_g', E_g_def, is_numeric_scalar);
addOptional(p, 'E_f', E_f_def, is_numeric_scalar);
addOptional(p, 'eps_ox', eps_ox_def, is_numeric_scalar);
addOptional(p, 'eps_ch', eps_ch_def, is_numeric_scalar);
addOptional(p, 'a', a_def, is_numeric_scalar);
addOptional(p, 'geometry', geometry_def, @(x) any(validatestring(x,expected_geometry)) );
addOptional(p, 'lambda_ds', lambda_ds_def, is_numeric_scalar_or_string); 
addOptional(p, 'l_ch', l_ch_def, is_numeric_scalar_or_string);
addOptional(p, 'l_ds', l_ds_def, is_numeric_scalar_or_string);

% parse input as described
parse(p, V_ds, V_g,  d_ch, d_ox, varargin{:});

% read parsed input into variables
E_g = p.Results.E_g;
E_f = p.Results.E_f;
eps_ox = p.Results.eps_ox;
eps_ch = p.Results.eps_ch;
a = p.Results.a;

% geometry
switch(p.Results.geometry)
    case {'single gate'}
        lambda = lambda_single_gate(d_ch,d_ox,eps_ch,eps_ox);
    case {'double gate'}
        lambda = lambda_double_gate(d_ch,d_ox,eps_ch,eps_ox);
    case {'triple gate', 'tri-gate'}
        lambda = lambda_triple_gate(d_ch,d_ox,eps_ch,eps_ox);
    case {'nano-wire', 'nanowire'}
        lambda = lambda_nanowire(d_ch,d_ox,eps_ch,eps_ox);
end

% lambda_ds
if ischar( p.Results.lambda_ds )
    lambda_ds = lambda * sscanf( p.Results.lambda_ds, '%f lambda');
else % it is a numeric scalar
    lambda_ds = p.Results.lambda_ds;
end

% l_ch
if ischar( p.Results.l_ch )
    l_ch = lambda * sscanf( p.Results.l_ch, '%f lambda');
else % it is a numeric scalar
    l_ch = p.Results.l_ch;
end

% l_ds, abhängig von lambda_ds
if ischar( p.Results.l_ds )
    l_ds = lambda_ds * sscanf( p.Results.l_ds, '%f lambda');
else % it is a numeric scalar
    l_ds = p.Results.l_ds;
end


% anonyme funktionen sind extrem beschränkt in matlab

% %%%% helper function
% parse_numeric_or_string = @(input, lamb) if ischar( input )
%         lambda * sscanf( input, '%f lambda')
%     else % it is a numeric scalar
%         input
%     end
% %%%%%

%lambda_ds = parse_numeric_or_string( p.Results.lambda_ds, lambda);
%l_ch = parse_numeric_or_string( p.Results.l_ch, lambda);
%l_ds = parse_numeric_or_string( p.Results.l_ds, lambda_ds);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

phi_bi = -(E_f + E_g/2);
phi_ds = -V_ds*eV;
phi_g = -V_g*eV;

%lambda_ds = lambda; %0.2*lambda;
%l_ch = 5*lambda;
%l_ds = 4*lambda_ds;
   
n_ds = floor(l_ds / a);
n_ch = floor(l_ch / a);
n_ges = 2*n_ds + n_ch;
%l_ges = l_ch + 2*l_ds;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

voltage = M\vec;