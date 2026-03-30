global n m populasyon antikor_fitness klon_populasyon klon_fitness best_antikor best_fitness sinir_degerleri ...
    mesafe_turleri agirlik_turleri tie_turleri Egitim Egitimc Test Testc

disp('  -> Secim yapiliyor...');

tum_populasyon = [populasyon; klon_populasyon];
tum_fitness = [antikor_fitness; klon_fitness];

[sirali_fitness, sirali_idx] = sort(tum_fitness, 'descend');

yeni_populasyon = tum_populasyon(sirali_idx(1:n), :);
yeni_fitness = sirali_fitness(1:n);

% Receptor Editing (Popülasyon Çeşitliliği)
degisecek_sayi = round(n * 0.2);
for i = (n - degisecek_sayi + 1):n
    for k_var = 1:m
        min_val = sinir_degerleri(k_var, 1);
        max_val = sinir_degerleri(k_var, 2);
        yeni_populasyon(i, k_var) = round(min_val + rand() * (max_val - min_val));
    end

    % Yeni eklenen adaylari ayni iterasyonda dagerlendir
    k_val = max(1, round(yeni_populasyon(i, 1)));
    dist_idx = max(1, min(length(mesafe_turleri), round(yeni_populasyon(i, 2))));
    weight_idx = max(1, min(length(agirlik_turleri), round(yeni_populasyon(i, 3))));
    std_logical = (round(yeni_populasyon(i, 4)) == 1);
    tie_idx = max(1, min(length(tie_turleri), round(yeni_populasyon(i, 5))));

    try
        mdl = fitcknn(Egitim, Egitimc, ...
            'Distance', mesafe_turleri{dist_idx}, ...
            'NumNeighbors', k_val, ...
            'DistanceWeight', agirlik_turleri{weight_idx}, ...
            'Standardize', std_logical, ...
            'BreakTies', tie_turleri{tie_idx});

        tahmin = predict(mdl, Test);
        yeni_fitness(i) = sum(tahmin(:) == Testc(:)) / length(Testc(:));
    catch
        yeni_fitness(i) = 0;
    end
end
fprintf('  -> En kotu %d tanesi degistirildi.\n', degisecek_sayi);

populasyon = yeni_populasyon;
antikor_fitness = yeni_fitness;

if antikor_fitness(1) > best_fitness
    best_fitness = antikor_fitness(1);
    best_antikor = populasyon(1, :);
end