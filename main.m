% ANA AKIS DOSYASI
% Bu script, CLONALG tabanli arama ile yapay sinir agi hiperparametrelerini
% optimize eder. Her antikor bir NN mimarisi ve egitim ayarini temsil eder.

global n m populasyon antikor_fitness klon_populasyon klon_fitness ...
       sinir_degerleri aktivasyon_turleri lambda_degerleri Egitim Egitimc Test Testc ...
       best_antikor best_fitness ...
       n_secilen beta rho d_degisecek history

% CLONALG parametreleri:
% n            : populasyon buyuklugu
% n_secilen    : her iterasyonda secilecek en iyi antikor sayisi
% beta         : klon sayisini etkileyen katsayi
% rho          : mutasyon orani katsayisi
% d_degisecek  : cesitlilik icin rastgele yenilenecek birey sayisi
% iterasyon    : toplam dongu sayisi
n = 50;             
n_secilen = 20;     
beta = 1.0;         
rho = 2.0;          
d_degisecek = 10;   
iterasyon = 30;     

% Gen sayisi: 6
% 1-3: gizli katman nöron sayilari, 4: aktivasyon tipi,
% 5: lambda, 6: kullanilacak katman sayisi
m = 6;  

% Her gen icin alt-ust sinirlar
sinir_degerleri = [5 100; 5 100; 5 100; 1 4; 1 6; 1 3];

% Ayrik gen degerlerinin gercek parametreye map edilmesi
aktivasyon_turleri = {'relu', 'tanh', 'sigmoid', 'none'};
lambda_degerleri = [0, 1e-5, 1e-4, 1e-3, 1e-2, 1e-1];

% Her iterasyondaki en iyi fitness degerini saklar (yakinsama grafigi icin)
history = zeros(iterasyon, 1); 

disp('========================================');
disp('  CLONALG & NEURAL NETWORK OPTIMIZASYONU');
disp('========================================');

% Veri hazirla ve ilk populasyonu/fiteness'i olustur
veri_on_isleme; 
disp('-> Ilk populasyon olusturuluyor...');
ais_populasyon_olustur;

disp('-> Ilk afiniteler (dogruluk) hesaplaniyor...');
ais_hesapla_fitness;

% Baslangic en iyi bireyi belirle
[best_fitness, idx] = max(antikor_fitness);
best_antikor = populasyon(idx, :);

tic; % toplam calisma suresini olcmek icin

for j = 1:iterasyon
    % Secilen antikorlari klonla ve mutasyona ugrat
    ais_klonlama_ve_mutasyon;
    % Klonlari degerlendir, yeni populasyonu kur ve en iyi bireyi guncelle
    ais_secim;
    
    % Iterasyon sonu en iyi degeri kaydet
    history(j) = best_fitness;
    
    % Hangi katman yapisi secildi ise ekrana onu basmak icin
    katman_sayisi = best_antikor(6);
    if katman_sayisi == 1
        k_str = sprintf('[%d]', best_antikor(1));
    elseif katman_sayisi == 2
        k_str = sprintf('[%d, %d]', best_antikor(1), best_antikor(2));
    else
        k_str = sprintf('[%d, %d, %d]', best_antikor(1), best_antikor(2), best_antikor(3));
    end
    
    fprintf('Iterasyon %d: En Iyi Dogruluk = %.6f | Katmanlar: %s, Akt: %s\n', ...
            j, best_fitness, k_str, aktivasyon_turleri{best_antikor(4)});
end

calisma_suresi = toc; 

% Final modelini kurmak icin en iyi antikorun katman dizisini cikar
best_katman_sayisi = best_antikor(6);
if best_katman_sayisi == 1
    best_layers = [best_antikor(1)];
elseif best_katman_sayisi == 2
    best_layers = [best_antikor(1), best_antikor(2)];
else
    best_layers = [best_antikor(1), best_antikor(2), best_antikor(3)];
end
best_act  = aktivasyon_turleri{best_antikor(4)};
best_lmbd = lambda_degerleri(best_antikor(5));

disp('========================================');
disp('               SONUCLAR');
disp('========================================');
fprintf('Calisma Suresi        : %.4f saniye\n', calisma_suresi);
fprintf('En yuksek dogruluk    : %.6f\n', best_fitness);
fprintf('En iyi LayerSizes     : %s\n', mat2str(best_layers));
fprintf('En iyi Activations    : %s\n', best_act);
fprintf('En iyi Lambda         : %g\n', best_lmbd);
disp('========================================');

% 1) Yakinsama grafigi: iterasyonlara gore en iyi fitness
figure;
plot(1:iterasyon, history, '-o', 'LineWidth', 2);
xlabel('Iterasyon'); ylabel('En Iyi Dogruluk (Afinite)');
title(sprintf('CLONALG - Yapay Sinir Agi\nEn Iyi Deger: %.6f', best_fitness));
grid on;

% 2) En iyi hiperparametrelerle final modeli egit ve karmasiklik matrisi ciz
disp('-> Final modeli egitiliyor ve matris ciziliyor...');
warning('off', 'all'); % Olası uyarıları kapat
final_mdl = fitcnet(Egitim, Egitimc, ...
    'LayerSizes', best_layers, ...
    'Activations', best_act, ...
    'Lambda', best_lmbd, ...
    'IterationLimit', 500, ...
    'Standardize', true);
warning('on', 'all'); % Uyarıları geri aç

% Test tahmini ve siniflandirma performansini gorsellestirme
final_tahmin = predict(final_mdl, Test);
figure;
cm = confusionchart(Testc, final_tahmin);
cm.Title = sprintf('Optimize Edilmis NN Karmasiklik Matrisi (%%%.2f)', best_fitness * 100);
cm.RowSummary = 'row-normalized'; 
cm.ColumnSummary = 'column-normalized';