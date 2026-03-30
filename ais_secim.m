global n m populasyon antikor_fitness klon_populasyon klon_fitness best_antikor best_fitness sinir_degerleri

% Eski antikorlar ve klonları rekabet havuzuna dahil edelim
tum_populasyon = [populasyon; klon_populasyon];
tum_fitness = [antikor_fitness; klon_fitness];

% Fitness değerlerine göre büyükten küçüğe sıralama
[sirali_fitness, sirali_idx] = sort(tum_fitness, 'descend');

% En iyi "n" tanesini alarak yeni nesli oluşturalım
yeni_populasyon = tum_populasyon(sirali_idx(1:n), :);
yeni_fitness = sirali_fitness(1:n);

% Receptor Editing (Popülasyon Çeşitliliği): En kötü %20'yi rastgele yenile
degisecek_sayi = round(n * 0.2);
for i = (n - degisecek_sayi + 1):n
    for k_var = 1:m
        min_val = sinir_degerleri(k_var, 1);
        max_val = sinir_degerleri(k_var, 2);
        yeni_populasyon(i, k_var) = round(min_val + rand() * (max_val - min_val));
    end
    yeni_fitness(i) = 0; % Bir sonraki turda klonlama öncesi yeniden hesaplanıp cezalandırılacak
end

% Global değişkenleri güncelleme
populasyon = yeni_populasyon;
antikor_fitness = yeni_fitness;

% Global en iyi (best_g muadili) güncellemesi
if antikor_fitness(1) > best_fitness
    best_fitness = antikor_fitness(1);
    best_antikor = populasyon(1, :);
end