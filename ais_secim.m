% SECIM ASAMASI
% Klonlarin fitness'i hesaplanir, mevcut populasyonla birlestirilir,
% en iyiler secilir, tekrarlar elenir ve cesitlilik korunur.

global n m populasyon antikor_fitness klon_populasyon klon_fitness ...
       Egitim Egitimc Test Testc aktivasyon_turleri lambda_degerleri ...
       best_antikor best_fitness d_degisecek sinir_degerleri

% Klon birey sayisi ve fitness vektoru
toplam_klon = size(klon_populasyon, 1);
klon_fitness = zeros(toplam_klon, 1);

warning('off', 'all'); % Egitim uyarilarini sustur

for i = 1:toplam_klon
    % Ekrani cok doldurmamak icin sadece belirli araliklarla bilgi ver
    if mod(i, 10) == 0 || i == 1 || i == toplam_klon
        fprintf('  -> [Klonlar] Mutant Klon %d / %d egitiliyor...\n', i, toplam_klon);
    end

    % Klonun genlerini parametrelere cevir
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
    
    % Klon antikorun temsil ettigi NN modelini egit
    mdl = fitcnet(Egitim, Egitimc, ...
        'LayerSizes', layers, ...
        'Activations', act, ...
        'Lambda', lmbd, ...
        'IterationLimit', 500, ...
        'Standardize', true);
        
    % Test tahmini ve fitness hesabi
    tahmin = predict(mdl, Test);

    dogru_sayisi = sum(tahmin == Testc);

    klon_fitness(i) = dogru_sayisi / length(Testc);
end

warning('on', 'all'); % Dongu sonu uyarilari ac

% Ana populasyon + klonlar birlikte degerlendirilir
combined = [populasyon; klon_populasyon];
combined_affinities = [antikor_fitness; klon_fitness];

% Fitness'e gore sirala
[sirali_affinities, sirali_idx] = sort(combined_affinities, 'descend');
% Ayni gene sahip tekrarli bireyleri tekille
[~, unique_idx] = unique(combined(sirali_idx, :), 'rows', 'stable');
gercek_idx = sirali_idx(unique_idx);

% Yeni nesil icin bellek ayir
yeni_populasyon = zeros(n, m);
yeni_fitness = zeros(n, 1);

% Uygun oldugu kadar en iyi bireyleri yeni populasyona aktar
alinan_sayi = min(n, length(gercek_idx));
yeni_populasyon(1:alinan_sayi, :) = combined(gercek_idx(1:alinan_sayi), :);
yeni_fitness(1:alinan_sayi) = combined_affinities(gercek_idx(1:alinan_sayi));

% Eksik kalan yerleri rastgele bireylerle doldur
for i = alinan_sayi+1:n
    for gen = 1:m
        yeni_populasyon(i, gen) = randi([sinir_degerleri(gen, 1), sinir_degerleri(gen, 2)]);
    end
    yeni_fitness(i) = 0;
end

% --- CESITLILIK KORUMA ---
% Son d_degisecek birey, yerel optimuma sikismayi azaltmak icin yenilenir.
for i = (n - d_degisecek + 1) : n
    for gen = 1:m
        yeni_populasyon(i, gen) = randi([sinir_degerleri(gen, 1), sinir_degerleri(gen, 2)]);
    end
    yeni_fitness(i) = 0; 
end

populasyon = yeni_populasyon;
antikor_fitness = yeni_fitness;

% Global en iyi cozum guncellemesi (elitist takip)
if antikor_fitness(1) > best_fitness
    best_fitness = antikor_fitness(1);
    best_antikor = populasyon(1, :);
end