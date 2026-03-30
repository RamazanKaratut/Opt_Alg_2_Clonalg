global n m populasyon antikor_fitness klon_populasyon klon_fitness ...
    sinir_degerleri klon_sayisi mutasyon_katsayisi mesafe_turleri agirlik_turleri tie_turleri Egitim Egitimc Test Testc

toplam_klon = n * klon_sayisi;
klon_populasyon = zeros(toplam_klon, m);
klon_index = 1;

for i = 1:n
    mutasyon_orani = mutasyon_katsayisi * (1 - antikor_fitness(i)); 
    
    for k = 1:klon_sayisi
        gecici_klon = populasyon(i, :);
        
        for sutun = 1:m
            if rand() < mutasyon_orani
                alt = sinir_degerleri(sutun, 1);
                ust = sinir_degerleri(sutun, 2);
                
                % Eger K degeri (1. sutun) degisiyorsa ufak bir sapma ekle
                if sutun == 1
                    sapma = round(randn() * (ust - alt) * 0.3);
                    % Sapma 0 kaldiysa zorla 1 veya -1 birim degistirmeye calis
                    if sapma == 0
                        sapma = sign(randn()); 
                        if sapma == 0; sapma = 1; end
                    end
                    yeni_deger = gecici_klon(sutun) + sapma;
                    
                % Eger mesafe, agirlik gibi dar aralikli kategorik bir seyse
                % tamamen yeni rastgele bir secenek ata (aksi halde aynı kalıp sıkışıyordu)
                else
                    yeni_deger = round(alt + rand() * (ust - alt));
                end
                
                % Deger sinirlari asarsa sinirlara sabitle
                if yeni_deger < alt
                    yeni_deger = alt;
                end
                if yeni_deger > ust
                    yeni_deger = ust;
                end
                
                gecici_klon(sutun) = yeni_deger;
            end
        end
        klon_populasyon(klon_index, :) = gecici_klon;
        klon_index = klon_index + 1;
    end
end

klon_fitness = zeros(toplam_klon, 1);

for i = 1:toplam_klon
    k_val = klon_populasyon(i, 1);
    dist_idx = klon_populasyon(i, 2);
    weight_idx = klon_populasyon(i, 3);
    std_logical = klon_populasyon(i, 4) == 1;
    tie_idx = klon_populasyon(i, 5); 
    
    mdl = fitcknn(Egitim, Egitimc, ...
        'Distance', mesafe_turleri{dist_idx}, ...
        'NumNeighbors', k_val, ...
        'DistanceWeight', agirlik_turleri{weight_idx}, ...
        'Standardize', std_logical, ...
        'BreakTies', tie_turleri{tie_idx});
    
    tahminler = predict(mdl, Test);
    klon_fitness(i) = sum(tahminler(:) == Testc(:)) / length(Testc(:));
end