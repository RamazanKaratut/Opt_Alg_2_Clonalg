clc; clear all; close all;

global n m populasyon antikor_fitness klon_populasyon klon_fitness ...
       sinir_degerleri mesafe_turleri agirlik_turleri Egitim Egitimc Test Testc ...
       best_antikor best_fitness klon_sayisi mutasyon_katsayisi

% Değişkenler Tanımlanır
n = 20; % Popülasyon (Antikor) hacmi
m = 4;  % Optimize edilecek hiperparametre sayısı 
iterasyon = 15;
klon_sayisi = 5; % Her antikor için üretilecek klon miktarı
mutasyon_katsayisi = 0.5;

% Sınır Değerleri: [min max]
% 1. Sütun: NumNeighbors (1-30)
% 2. Sütun: Distance (1-4 -> euclidean, cityblock, chebychev, cosine)
% 3. Sütun: DistanceWeight (1-2 -> Equal, Inverse)
% 4. Sütun: Standardize (0-1 -> false, true)
sinir_degerleri = [1 30; 1 4; 1 2; 0 1];

% Sözel ifadelerin sayısal karşılıklarını tutan diziler
mesafe_turleri = {'euclidean', 'cityblock', 'chebychev', 'cosine'};
agirlik_turleri = {'Equal', 'Inverse'};

% Veriyi yükle, sayısala çevir ve orneklem.m ile ayır
veri_on_isleme; 

% Yapay Bağışıklık Algoritması Başlangıcı
ais_populasyon_olustur;
ais_hesapla_fitness;

% En iyi ilk değer kendisidir (Başlangıç ataması)
[best_fitness, idx] = max(antikor_fitness);
best_antikor = populasyon(idx, :);

j = 1;
while (j <= iterasyon)
    ais_klonlama_ve_mutasyon;
    ais_secim;
    
    fprintf('İterasyon %d: En İyi Doğruluk (Fitness) = %.4f\n', j, best_fitness);
    j = j + 1;
end

%% Optimizasyon Sonuçlarını Yazdırma
fprintf('\n--- EN İYİ HİPERPARAMETRELER ---\n');
fprintf('NumNeighbors   : %d\n', round(best_antikor(1)));
fprintf('Distance       : %s\n', mesafe_turleri{round(best_antikor(2))});
fprintf('DistanceWeight : %s\n', agirlik_turleri{round(best_antikor(3))});
fprintf('Standardize    : %d\n', round(best_antikor(4)));