global n populasyon antikor_fitness mesafe_turleri agirlik_turleri tie_turleri Egitim Egitimc Test Testc
antikor_fitness = zeros(n, 1);
for i = 1:n
    k_val = max(1, round(populasyon(i, 1)));
    dist_idx = max(1, min(length(mesafe_turleri), round(populasyon(i, 2))));
    weight_idx = max(1, min(length(agirlik_turleri), round(populasyon(i, 3))));
    std_logical = (round(populasyon(i, 4)) == 1);
    tie_idx = max(1, min(length(tie_turleri), round(populasyon(i, 5)))); 
    
    try
        % ClassNames satırı kaldırıldı, MATLAB etiketleri otomatik bulacak
        mdl = fitcknn(Egitim, Egitimc, ...
            'Distance', mesafe_turleri{dist_idx}, ...
            'NumNeighbors', k_val, ...
            'DistanceWeight', agirlik_turleri{weight_idx}, ...
            'Standardize', std_logical, ...
            'BreakTies', tie_turleri{tie_idx});
        
        tahmin = predict(mdl, Test);
        % Boyut uyuşmazlığını önlemek için (:) eklendi
        antikor_fitness(i) = sum(tahmin(:) == Testc(:)) / length(Testc(:));
    catch ME
        % Eğer hala bir hata varsa gizlemeyip ekrana yazdıracak
        disp(['Aday ' num2str(i) ' için Hata: ' ME.message]);
        antikor_fitness(i) = 0;
    end
end