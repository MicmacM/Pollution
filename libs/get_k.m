function [k, wet] = get_k(i,j, matrice_pluie, logp)
    v_rain = matrice_pluie(i,j) * 3600 * 24 * 365 / 1000;
    %v_rain=3*10^(-7); %En m.s^-1
    t_dry=2; %en unité arbitraire (il faut juste que ça soit la même pour t_wet)
    t_wet=4;
    v_air_ae=0.001;
    h_air_u=240;
    h_air_s=1000;
    f_r_u=0.016;%proportion de sol non pavé en milieu urbain
    k_dry_s=v_air_ae/h_air_s;
    k_dry_u=v_air_ae/h_air_u*f_r_u;
    CE_ae=200000;
    v_wash_ae=(t_dry+t_wet)/t_wet*v_rain*CE_ae;
    k_wet_s=v_wash_ae/h_air_s;
    k_wet_u=v_wash_ae/h_air_u*f_r_u;
    k_tot=((1/k_dry_s)*t_dry/(t_dry+t_wet)+(1/k_wet_s)*t_wet/(t_dry+t_wet))^(-1); %On utilise les coefficients pour sol continental non urbain car majoritaire
    % Générer un nombre aléatoire entre 0 et 1
    random_number = rand;

    % Définir les probabilités pour chaque option
    prob_pluie = 2/3;

    % Tirage entre les deux valeurs de k en fonction de si il pleut ou pas
    if logp < 0
        if random_number < prob_pluie
            k = k_tot;
            wet = true;
        else
            k = k_dry_s;
            wet = false;
        end
    else
        k = k_dry_s;
        wet = false;
    end

    
end