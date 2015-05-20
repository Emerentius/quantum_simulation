clear all;
close all;
initialise_constants
%profile on

%% input parameters
m = 0.2*m_e;
l = 10*nm;
a = 0.2*nm;

T = 300; % K

E_f = 1*eV;
E_min = -1*E_f;
E_max = E_f+5*k_B*T;

energy_step = (E_max-E_min)/100;
eta = 1*energy_step;
%%

t = h_bar^2 / (2*m * a^2);
%E_1 = (h_bar * pi)^2 / (2*m * l^2 ); % first state
n_ges = floor(l/a);
%phi = e*poisson(0,0,5*nm, 1*nm, 'a', a, 'l_ch', l/2+a, 'l_ds', l/4, 'geometry', 'nano-wire');


energies = E_min : energy_step : E_max;
%prefactor = 2e15/4.135; % 2e/h oder h_quer

for k=1:100
    phi = ones(n_ges,1) .* (-1*E_f)*k/100; % E_f willkürlich gewählt
    
    side_diag = ones(n_ges, 1) .*  (-t);
    for E_j=[energies; 1:length(energies)]
        E = E_j(1);
        j = E_j(2);

        % side diag above
        middle_diag = phi + ones(n_ges,1) .* (2*t);
        H = spdiags([side_diag, middle_diag, side_diag], [1,0,-1], n_ges, n_ges);

        diagonal = ones(n_ges,1) .* (E+ 1i*eta);
        E_i_eta = spdiags(diagonal, [0], n_ges, n_ges);

        matrix = E_i_eta - H;

        G = 1/a .* inv(matrix);
        densities(j, :) = -1/pi*imag(diag(G)).';
    end

    x_pos = 0:a:l-a;
    %p = surf(x_pos(1:n_ges), energies, densities);

    %% Integrieren
    int_res = 0; % integrierte elektronenzahl
    for i=1:length(energies)
        E = energies(i);
        int_res = int_res + sum(densities(i,:))*energy_step*a*fermi(E-E_f, T);
    end
    n_elektronen_ges(k) = int_res;
    %disp(int_res)
    
    if k == 1 
        figure(2)
        p = surf(x_pos(1:n_ges), energies, densities);
    end;
end
figure(1)
plot(n_elektronen_ges);
figure(3)
p = surf(x_pos(1:n_ges), energies, densities);
%% carrier density
% figure(2)
% for i=1:n_ges
%     x = x_pos(i);
%     n_tmp = 0;
%     for j=1:length(energies)
%         E=energies(j);
%         n_tmp = n_tmp + energy_step*fermi(E-E_f, T)*densities(j,i);
%     end
%     n(i)=n_tmp;
% end
%%
%plot(x_pos(1:n_ges), n)
%%

%profile off
%profile viewer