load('vent_1_mois.mat');
[data, txt, raw] = xlsread("map.xlsx");

%Importation des données depuis les tableaux
Nx = 93;
Ny = 60;
N = (Nx+2)*(Ny+2);
Pluvio = zeros(Nx+2, Ny+2);
Population = zeros(Nx+2, Ny+2);
for k = 1:N
    [i,j] = id_to_grid(data(k,1), Ny + 2);
    Pluvio(i, j) = data(k,17);
    Population(i,j) = data(k,31) + data(k,32);
end


%Conditions initiales

Nx = size(Ux, 1) - 2;
Ny = size(Ux, 2) - 2;
Nt = size(Ux, 3);
T = Nt*3;
D = 100;
logp = -10;

%Pour faire un vent constant, décommenter ces deux lignes
%Ux = 6 * ones(95, 62, 248);
%Uy = 6 * ones(95, 62, 248);

%Pour faire un petit monticule de polluant en conditions initiales,
%décommenter ces lignes : 
%sigma = 1;
%centre_x = 30;
%centre_y = 30;
%amplitude = 0.5;
%c0 = transpose(amplitude * exp(-((x - centre_x).^2 + (y - centre_y).^2) / (2 * sigma^2)));



c0 = zeros(Nx+2, Ny+2);
[c, soil_polution_dry, soil_polution_wet] = simulation(Nx,Ny,Nt,T,c0,Ux,Uy,D,Pluvio, logp);

%Exploitation de la simulation

soil_polution = (soil_polution_dry + soil_polution_wet);

exposition = soil_polution ./ Population;
exposition(Population == 0) = 0;
u_zinc = 0.214775050943749;
u_nickel = 0.0522988379789418;
u_cd = 7.65806856315388;
u_truc = 0.0537905868316157;
danger = Population .* soil_polution * (u_zinc + u_nickel + u_cd);
%danger = Population .* soil_polution * u_truc;
figure;
imagesc(soil_polution_dry)
xlabel('Latitude');
ylabel('Longitude');
title('Dépot sec moyen par cellule, en ug/m^3');
colorbar;
figure;
imagesc(soil_polution_wet)
xlabel('Latitude');
ylabel('Longitude');
title('Dépot humide moyen par cellule, en ug/m^3');
colorbar;
figure;
imagesc(exposition)
xlabel('Latitude');
ylabel('Longitude');
title('Exposition moyenne par cellule, en concentration reçue par habitant');
colorbar;
figure;
imagesc(danger)
xlabel('Latitude');
ylabel('Longitude');
title('Dangerosité moyenne par cellule, en CDUh/10^9');
colorbar;

