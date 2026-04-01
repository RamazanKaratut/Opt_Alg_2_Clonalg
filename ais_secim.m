global n m populasyon antikor_fitness klon_populasyon klon_fitness ...
       Egitim Egitimc Test Testc aktivasyon_turleri lambda_degerleri ...
       best_antikor best_fitness d_degisecek sinir_degerleri

toplam_klon = size(klon_populasyon, 1);
klon_fitness = zeros(toplam_klon, 1);

warning('off', 'all'); % Egitim uyarilarini sustur

for i = 1:toplam_klon
    L1   = klon_populasyon(i, 1);
    L2   = klon_populasyon(i, 2);
    L3   = klon_populasyon(i, 3);
    act  = aktivasyon_turleri{klon_populasyon(i, 4)};
    lmbd = lambda_degerleri(klon_populasyon(i, 5));
    katman_sayisi = klon_populasyon(i, 6); % 6. GEN
    
    if katman_sayisi == 1
        layers = [L1];
    elseif katman_sayisi == 2
        layers = [L1, L2];
    else
        layers = [L1, L2, L3];
    end
    
    try
        mdl = fitcnet(Egitim, Egitimc, ...
            'LayerSizes', layers, ...
            'Activations', act, ...
            'Lambda', lmbd, ...
            'IterationLimit', 500, ...
            'Standardize', true);
            
        tahmin = predict(mdl, Test);
        
        if iscategorical(Testc) || iscellstr(Testc) || isstring(Testc)
             dogru_sayisi = sum(strcmp(cellstr(tahmin), cellstr(Testc)));
        else
             dogru_sayisi = sum(tahmin == Testc);
        end
        klon_fitness(i) = dogru_sayisi / length(Testc);
    catch
        klon_fitness(i) = 0;
    end
end

warning('on', 'all'); % Dongu sonu uyarilari ac

combined = [populasyon; klon_populasyon];
combined_affinities = [antikor_fitness; klon_fitness];

[sirali_affinities, sirali_idx] = sort(combined_affinities, 'descend');
[~, unique_idx] = unique(combined(sirali_idx, :), 'rows', 'stable');
gercek_idx = sirali_idx(unique_idx);

yeni_populasyon = zeros(n, m);
yeni_fitness = zeros(n, 1);

alinan_sayi = min(n, length(gercek_idx));
yeni_populasyon(1:alinan_sayi, :) = combined(gercek_idx(1:alinan_sayi), :);
yeni_fitness(1:alinan_sayi) = combined_affinities(gercek_idx(1:alinan_sayi));

for i = alinan_sayi+1:n
    for gen = 1:m
        yeni_populasyon(i, gen) = randi([sinir_degerleri(gen, 1), sinir_degerleri(gen, 2)]);
    end
    yeni_fitness(i) = 0;
end

% --- CESITLILIK KORUMA ---
for i = (n - d_degisecek + 1) : n
    for gen = 1:m
        yeni_populasyon(i, gen) = randi([sinir_degerleri(gen, 1), sinir_degerleri(gen, 2)]);
    end
    yeni_fitness(i) = 0; 
end

populasyon = yeni_populasyon;
antikor_fitness = yeni_fitness;

if antikor_fitness(1) > best_fitness
    best_fitness = antikor_fitness(1);
    best_antikor = populasyon(1, :);
end