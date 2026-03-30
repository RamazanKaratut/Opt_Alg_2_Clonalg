global n m populasyon antikor_fitness klon_populasyon klon_fitness ...
       sinir_degerleri klon_sayisi mutasyon_katsayisi mesafe_turleri agirlik_turleri Egitim Egitimc Test Testc

toplam_klon = n * klon_sayisi;
klon_populasyon = zeros(toplam_klon, m);

idx = 1;
for i = 1:n
    % Doğruluk 0 ile 1 arasında. Fitness ne kadar düşükse mutasyon oranı o kadar artar.
    mutasyon_orani = mutasyon_katsayisi * (1 - antikor_fitness(i)); 
    
    for k_clone = 1:klon_sayisi
        gecici_klon = populasyon(i, :);
        
        for k_var = 1:m
            if rand() < mutasyon_orani
                min_val = sinir_degerleri(k_var, 1);
                max_val = sinir_degerleri(k_var, 2);
                
                % Hafif rastgele sapma eklentisi
                yeni_deger = round(gecici_klon(k_var) + randn() * (max_val - min_val) * 0.2);
                % Değerleri sınırlar içinde tut
                gecici_klon(k_var) = max(min_val, min(yeni_deger, max_val));
            end
        end
        klon_populasyon(idx, :) = gecici_klon;
        idx = idx + 1;
    end
end

% Klonların fitness (uygunluk) değerlerini hesaplama işlemi
klon_fitness = zeros(toplam_klon, 1);
for i = 1:toplam_klon
    k_val = max(1, round(klon_populasyon(i, 1)));
    dist_idx = max(1, min(length(mesafe_turleri), round(klon_populasyon(i, 2))));
    weight_idx = max(1, min(length(agirlik_turleri), round(klon_populasyon(i, 3))));
    std_logical = (round(klon_populasyon(i, 4)) == 1);
    
    try
        mdl = fitcknn(Egitim, Egitimc, ...
            'Distance', mesafe_turleri{dist_idx}, ...
            'Exponent', [], ...
            'NumNeighbors', k_val, ...
            'DistanceWeight', agirlik_turleri{weight_idx}, ...
            'Standardize', std_logical, ...
            'ClassNames', [0; 1]);
        
        tahmin = predict(mdl, Test);
        klon_fitness(i) = sum(tahmin == Testc) / length(Testc);
    catch
        klon_fitness(i) = 0;
    end
end