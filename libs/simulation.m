function [c, soil_polution_dry, soil_polution_wet] = simulation(Nx,Ny,Nt,T,c0,Ux,Uy,D, matrice_pluie, logp)
    dx = 70;
    dy = 70;
    dt = T/Nt;

    %Intensité des sources
    S_1 = 0.3726;
    S_2 = 1.3387;
    S_3 = 1.0024;

    %Coordonnées des sources
    s_1_x = 41;
    s_1_y = 38;
    s_2_x = 53;
    s_2_y = 36;
    s_3_x = 56;
    s_3_y = 34;


    c = zeros(Nx + 2, Ny + 2, Nt);
    c(:,:,1) = c0;
    figure;
    
    soil_polution_dry = zeros(Nx+2, Ny+2);
    soil_polution_wet = zeros(Nx+2, Ny+2);

    %Simulation
    for k = 1:Nt
        for i = 2:Nx+1
            for j = 2:Ny+1
                %Terme de dépot
                [lambda_ij, wet] = get_k(i,j, matrice_pluie, logp);
                lambda_ij = lambda_ij * 3600;
          
                A1 = (-Ux(i,j,k)/(2 * dx) + D / dx^2) * dt;
                A2 = (Ux(i,j,k)/(2 * dx) + D / dx^2) * dt;
                A3 = (-Uy(i,j,k)/(2 * dy) + D / dy^2) * dt;
                A4 = (Uy(i,j,k)/(2 * dy) + D / dy^2) * dt;
                A5 = -2 * dt * (D / dx^2 + D / dy^2) - lambda_ij * dt + 1;

                %Mise à jour de c en s'assurant qu'elle n'est pas négative
                c(i,j,k+1) = max(A1*c(i+1, j, k) + A2*c(i-1,j,k) + A3*c(i,j+1,k) + A4*c(i,j-1,k) + A5*c(i,j,k), 0);

                %Ajout des dépots aux matrices correspondantes
                if wet
                    soil_polution_wet(i,j) = soil_polution_wet(i,j) + lambda_ij * dt * c(i,j,k);
                else
                    soil_polution_dry(i,j) = soil_polution_dry(i,j) + lambda_ij * dt * c(i,j,k);
                end
            end
        end
        %Affectation des sources
        c(s_1_x, s_1_y, k+1) = c(s_1_x, s_1_y, k+1) + dt*S_1;
        c(s_2_x, s_2_y, k+1) = c(s_2_x, s_2_y, k+1) + dt*S_2;
        c(s_3_x, s_3_y, k+1) = c(s_3_x, s_3_y, k+1) + dt*S_3;

        %Respect des conditions aux limites
        c(1, :, k) = 0;
        c(Nx + 2, :, k) = 0;
        c(:, 1, k) = 0;
        c(:, Ny + 2, k) = 0;

        %Affichage de la simulation en direct
        %surf(c(:, :, k));
        imagesc(c(:, :, k));
        colorbar;
        xlabel('Latitude');
        ylabel('Longitude');
        title('Concentration moyenne par cellule, en ug/m^3');
        pause(1e-6);
    end
    c = c(:,:,end);
end





