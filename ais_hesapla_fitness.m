global n populasyon antikor_fitness 
global Egitim Egitimc Test Testc
global mesafe_turleri agirlik_turleri tie_turleri

antikor_fitness = zeros(n, 1);
egitim_ornek_sayisi = size(Egitim, 1);

for i = 1:n
    % Genlerden parametreleri cek
    k_degeri   = populasyon(i, 1);
    mesafe     = mesafe_turleri{populasyon(i, 2)};
    agirlik    = agirlik_turleri{populasyon(i, 3)};
    std_flag   = populasyon(i, 4) == 1; % logical (true/false) yapar
    tie        = tie_turleri{populasyon(i, 5)};
    
    % K degeri egitim setindeki ornek sayisindan buyuk olamaz
    if k_degeri > egitim_ornek_sayisi
        k_degeri = egitim_ornek_sayisi;
    end
    
    try
        % Modeli Egit
        mdl = fitcknn(Egitim, Egitimc, ...
            'NumNeighbors', k_degeri, ...
            'Distance', mesafe, ...
            'DistanceWeight', agirlik, ...
            'Standardize', std_flag, ...
            'BreakTies', tie);
        
        % Test verisi ile tahmin yap
        tahmin = predict(mdl, Test);
        
        % Dogruluk hesapla (Veri turune gore karsilastirma)
        if iscategorical(Testc) || iscellstr(Testc) || isstring(Testc)
             dogru_sayisi = sum(strcmp(cellstr(tahmin), cellstr(Testc)));
        else
             dogru_sayisi = sum(tahmin == Testc);
        end
        
        antikor_fitness(i) = dogru_sayisi / length(Testc);
        
    catch
        % Uyumsuz parametre cakismalarinda (or: bazi mesafelerde agirlik hesabi patlayabilir)
        antikor_fitness(i) = 0; 
    end
end