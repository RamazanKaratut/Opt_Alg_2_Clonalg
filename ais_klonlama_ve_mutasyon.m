global n m populasyon antikor_fitness klon_populasyon klon_fitness ...
    sinir_degerleri klon_sayisi mutasyon_katsayisi mesafe_turleri agirlik_turleri tie_turleri Egitim Egitimc Test Testc
disp('  -> Klonlama+mutasyon yapiliyor...');

toplam_klon = n * klon_sayisi;
klon_populasyon = zeros(toplam_klon, m);
idx = 1;

% --- 1. KLONLAMA VE MUTASYON (Arama Uzayında Yeni Adaylar Üretme) ---
for i = 1:n
    mutasyon_orani = mutasyon_katsayisi * (1 - antikor_fitness(i)); 
    
    for k_clone = 1:klon_sayisi
        gecici_klon = populasyon(i, :);
        
        for k_var = 1:m
            if rand() < mutasyon_orani
                min_val = sinir_degerleri(k_var, 1);
                max_val = sinir_degerleri(k_var, 2);
                yeni_deger = round(gecici_klon(k_var) + randn() * (max_val - min_val) * 0.2);
                gecici_klon(k_var) = max(min_val, min(yeni_deger, max_val));
            end
        end
        klon_populasyon(idx, :) = gecici_klon;
        idx = idx + 1;
    end
end

% --- 2. KLONLARIN FİTNESS HESAPLAMASI (HATA DÜZELTİLDİ) ---
klon_fitness = zeros(toplam_klon, 1);
for i = 1:toplam_klon
    k_val = max(1, round(klon_populasyon(i, 1)));
    dist_idx = max(1, min(length(mesafe_turleri), round(klon_populasyon(i, 2))));
    weight_idx = max(1, min(length(agirlik_turleri), round(klon_populasyon(i, 3))));
    std_logical = (round(klon_populasyon(i, 4)) == 1);
    tie_idx = max(1, min(length(tie_turleri), round(klon_populasyon(i, 5)))); 
    
    try
        % ClassNames satırı kaldırıldı, etiketler otomatik tanınacak
        mdl = fitcknn(Egitim, Egitimc, ...
            'Distance', mesafe_turleri{dist_idx}, ...
            'NumNeighbors', k_val, ...
            'DistanceWeight', agirlik_turleri{weight_idx}, ...
            'Standardize', std_logical, ...
            'BreakTies', tie_turleri{tie_idx});
        
        tahmin = predict(mdl, Test);
        % Boyut uyuşmazlığını önlemek için (:) eklendi
        klon_fitness(i) = sum(tahmin(:) == Testc(:)) / length(Testc(:));
    catch ME
        % Klonlarda hata çıkarsa sebebi ekranda görülecek
        disp(['Klon ' num2str(i) ' için Hata: ' ME.message]);
        klon_fitness(i) = 0;
    end
end

% --- 3. ANA POPÜLASYON FİTNESS HESAPLAMASI (ZATEN DÜZELTİLMİŞTİ) ---
global n populasyon antikor_fitness mesafe_turleri agirlik_turleri tie_turleri Egitim Egitimc Test Testc
antikor_fitness = zeros(n, 1);
for i = 1:n
    k_val = max(1, round(populasyon(i, 1)));
    dist_idx = max(1, min(length(mesafe_turleri), round(populasyon(i, 2))));
    weight_idx = max(1, min(length(agirlik_turleri), round(populasyon(i, 3))));
    std_logical = (round(populasyon(i, 4)) == 1);
    tie_idx = max(1, min(length(tie_turleri), round(populasyon(i, 5)))); 
    
    try
        mdl = fitcknn(Egitim, Egitimc, ...
            'Distance', mesafe_turleri{dist_idx}, ...
            'NumNeighbors', k_val, ...
            'DistanceWeight', agirlik_turleri{weight_idx}, ...
            'Standardize', std_logical, ...
            'BreakTies', tie_turleri{tie_idx});
        
        tahmin = predict(mdl, Test);
        antikor_fitness(i) = sum(tahmin(:) == Testc(:)) / length(Testc(:));
    catch ME
        disp(['Aday ' num2str(i) ' için Hata: ' ME.message]);
        antikor_fitness(i) = 0;
    end
end