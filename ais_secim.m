global n m populasyon antikor_fitness klon_populasyon klon_fitness best_antikor best_fitness ...
    sinir_degerleri mesafe_turleri agirlik_turleri tie_turleri Egitim Egitimc Test Testc

% Eskileri ve klonlari birlestir
tum_populasyon = [populasyon; klon_populasyon];
tum_fitness = [antikor_fitness; klon_fitness];

% Dogruluk oranina gore buyukten kucuge sirala
[sirali_fitness, sirali_indexler] = sort(tum_fitness, 'descend');

yeni_populasyon = zeros(n, m);
yeni_fitness = zeros(n, 1);

% Sadece en iyi n tanesini yeni populasyona al
for i = 1:n
    ind = sirali_indexler(i);
    yeni_populasyon(i, :) = tum_populasyon(ind, :);
    yeni_fitness(i) = sirali_fitness(i);
end

% En kotu olan %20'lik kismi yepyeni rastgele adaylarla degistir
degisecek_sayi = round(n * 0.2);
baslangic = n - degisecek_sayi + 1;

for i = baslangic:n
    for j = 1:m
        alt = sinir_degerleri(j, 1);
        ust = sinir_degerleri(j, 2);
        yeni_populasyon(i, j) = round(alt + rand() * (ust - alt));
    end
    
    % Yeni uretilen bu zayiflarin da egitimini hemen yap
    k_val = yeni_populasyon(i, 1);
    dist_idx = yeni_populasyon(i, 2);
    weight_idx = yeni_populasyon(i, 3);
    std_logical = yeni_populasyon(i, 4) == 1;
    tie_idx = yeni_populasyon(i, 5);
    
    mdl = fitcknn(Egitim, Egitimc, ...
        'Distance', mesafe_turleri{dist_idx}, ...
        'NumNeighbors', k_val, ...
        'DistanceWeight', agirlik_turleri{weight_idx}, ...
        'Standardize', std_logical, ...
        'BreakTies', tie_turleri{tie_idx});
        
    tahminler = predict(mdl, Test);
    yeni_fitness(i) = sum(tahminler(:) == Testc(:)) / length(Testc(:));
end

% Sonuclari kaydet
populasyon = yeni_populasyon;
antikor_fitness = yeni_fitness;

if antikor_fitness(1) > best_fitness
    best_fitness = antikor_fitness(1);
    best_antikor = populasyon(1, :);
end