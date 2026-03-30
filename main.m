global n m populasyon antikor_fitness klon_populasyon klon_fitness ...
       sinir_degerleri mesafe_turleri agirlik_turleri tie_turleri Egitim Egitimc Test Testc ...
       best_antikor best_fitness klon_sayisi mutasyon_katsayisi

% Değişkenler Tanımlanır
n = 20; % Popülasyon (Antikor) hacmi
m = 5;  % Optimize edilecek hiperparametre sayısı (5'e çıkarıldı)
iterasyon = 15;
klon_sayisi = 5; % Her antikor için üretilecek klon miktarı
mutasyon_katsayisi = 0.5;

% Sınır Değerleri: [min max]
% 1: NumNeighbors (1-30)
% 2: Distance (1-4)
% 3: DistanceWeight (1-2)
% 4: Standardize (0-1)
% 5: BreakTies (1-3 -> smallest, nearest, random)
sinir_degerleri = [1 30; 1 4; 1 2; 0 1; 1 3];

% Sözel ifadelerin sayısal karşılıklarını tutan diziler
mesafe_turleri = {'euclidean', 'cityblock', 'chebychev', 'cosine'};
agirlik_turleri = {'Equal', 'Inverse'};
tie_turleri = {'smallest', 'nearest', 'random'};

disp('===================================================================');
disp('      CLONALG ile KNN denemesi basliyor  ');
disp('===================================================================');
disp('Bakilan parametreler:');
disp('1. NumNeighbors (k) : 1 ile 30 arası tam sayılar');
disp('2. Distance         : 1:euclidean, 2:cityblock, 3:chebychev, 4:cosine');
disp('3. DistanceWeight   : 1:Equal, 2:Inverse');
disp('4. Standardize      : 0:False, 1:True');
disp('5. BreakTies        : 1:smallest, 2:nearest, 3:random');
disp('-------------------------------------------------------------------');

% Veriyi yükle, sayısala çevir ve orneklem.m ile ayır
veri_on_isleme; 

% Yapay Bağışıklık Algoritması Başlangıcı
disp('-> Ilk populasyon olusturuluyor...');
ais_populasyon_olustur;

disp('-> Ilk fitness degerleri hesaplaniyor...');
ais_hesapla_fitness;

% En iyi ilk değer kendisidir (Başlangıç ataması)
[best_fitness, idx] = max(antikor_fitness);
best_antikor = populasyon(idx, :);

fprintf('\n[BASLANGIC] En iyi dogruluk: %.4f\n', best_fitness);
fprintf('Başlangıç Parametreleri: k: %d | Mesafe: %s | Ağırlık: %s | Std: %d | BreakTies: %s\n', ...
    round(best_antikor(1)), mesafe_turleri{round(best_antikor(2))}, ...
    agirlik_turleri{round(best_antikor(3))}, round(best_antikor(4)), ...
    tie_turleri{round(best_antikor(5))});
fprintf('===================================================================\n\n');

stagnasyon_sayaci = 0;

j = 1;
while (j <= iterasyon)
    fprintf('--- TUR %d ---\n', j);

    eski_best = best_fitness;
    
    ais_klonlama_ve_mutasyon;
    ais_secim;

    ort_fitness = mean(antikor_fitness);
    std_fitness = std(antikor_fitness);
    cesitlilik = size(unique(populasyon, 'rows'), 1);

    delta = best_fitness - eski_best;
    if delta > 0
        stagnasyon_sayaci = 0;
        fprintf('  -> Bu tur biraz daha iyi oldu (+%.4f)\n', delta);
    else
        stagnasyon_sayaci = stagnasyon_sayaci + 1;
        fprintf('  -> Gelisme yok. Ust uste: %d\n', stagnasyon_sayaci);
    end
    
    fprintf('Tur %d sonu:\n', j);
    fprintf('  En iyi fitness : %.4f\n', best_fitness);
    fprintf('  Ortalama       : %.4f\n', ort_fitness);
    fprintf('  Std            : %.4f\n', std_fitness);
    fprintf('  Cesitlilik     : %d/%d\n', cesitlilik, n);
    fprintf('  k              : %d\n', round(best_antikor(1)));
    fprintf('  Mesafe         : %s\n', mesafe_turleri{round(best_antikor(2))});
    fprintf('  Agirlik        : %s\n', agirlik_turleri{round(best_antikor(3))});
    fprintf('  Std acik mi    : %s\n', mat2str(logical(round(best_antikor(4)))));
    fprintf('  BreakTies      : %s\n', tie_turleri{round(best_antikor(5))});
    fprintf('-------------------------------------------------------------------\n');
    
    j = j + 1;
end

%% Optimizasyon Sonuçlarını Yazdırma
fprintf('\n===================================================\n');
fprintf('       Bitti - Sonuc       \n');
fprintf('===================================================\n');
fprintf('En yuksek dogruluk : %.4f\n', best_fitness);
fprintf('En iyi k           : %d\n', round(best_antikor(1)));
fprintf('En iyi mesafe      : %s\n', mesafe_turleri{round(best_antikor(2))});
fprintf('En iyi agirlik     : %s\n', agirlik_turleri{round(best_antikor(3))});
fprintf('En iyi standardize : %d (1:True, 0:False)\n', round(best_antikor(4)));
fprintf('En iyi BreakTies   : %s\n', tie_turleri{round(best_antikor(5))});
fprintf('===================================================\n');