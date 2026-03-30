global n populasyon antikor_fitness mesafe_turleri agirlik_turleri Egitim Egitimc Test Testc

antikor_fitness = zeros(n, 1);

for i = 1:n
    % Genleri (parametreleri) çek ve sınırları koru
    k_val = max(1, round(populasyon(i, 1)));
    dist_idx = max(1, min(length(mesafe_turleri), round(populasyon(i, 2))));
    weight_idx = max(1, min(length(agirlik_turleri), round(populasyon(i, 3))));
    std_logical = (round(populasyon(i, 4)) == 1);
    
    try
        mdl = fitcknn(Egitim, Egitimc, ...
            'Distance', mesafe_turleri{dist_idx}, ...
            'Exponent', [], ...
            'NumNeighbors', k_val, ...
            'DistanceWeight', agirlik_turleri{weight_idx}, ...
            'Standardize', std_logical, ...
            'ClassNames', [0; 1]);
        
        tahmin = predict(mdl, Test);
        
        % Fitness = Sınıflandırma Doğruluğu (Accuracy)
        dogruluk = sum(tahmin == Testc) / length(Testc);
        antikor_fitness(i) = dogruluk;
    catch
        % Uyumsuz bir parametre oluşursa (örn. k sayısı veri boyutunu aşarsa) sıfırla
        antikor_fitness(i) = 0;
    end
end