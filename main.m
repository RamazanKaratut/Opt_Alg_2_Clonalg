global n m populasyon antikor_fitness klon_populasyon klon_fitness ...
       sinir_degerleri aktivasyon_turleri lambda_degerleri Egitim Egitimc Test Testc ...
       best_antikor best_fitness ...
       n_secilen beta rho d_degisecek history

% CLONALG Parametreleri
n = 50;             
n_secilen = 20;     
beta = 1.0;         
rho = 2.0;          
d_degisecek = 10;   
iterasyon = 30;     

% Gen Sayisi: 6 (3 gizli katman boyutu, 1 aktivasyon, 1 lambda, 1 katman sayisi)
m = 6;  

% Sinirlar: 
% 1:Layer1(5-100), 2:Layer2(5-100), 3:Layer3(5-100), 
% 4:Activations(1-4), 5:Lambda(1-6), 6:Katman_Sayisi(1-3)
sinir_degerleri = [5 100; 5 100; 5 100; 1 4; 1 6; 1 3];

% Kategorik ve Sayisal Haritalamalar
aktivasyon_turleri = {'relu', 'tanh', 'sigmoid', 'none'};
lambda_degerleri = [0, 1e-5, 1e-4, 1e-3, 1e-2, 1e-1];

history = zeros(iterasyon, 1); 

disp('========================================');
disp('  CLONALG & NEURAL NETWORK OPTIMIZASYONU');
disp('========================================');

veri_on_isleme; 
disp('-> Ilk populasyon olusturuluyor...');
ais_populasyon_olustur;

disp('-> Ilk afiniteler (dogruluk) hesaplaniyor...');
ais_hesapla_fitness;

[best_fitness, idx] = max(antikor_fitness);
best_antikor = populasyon(idx, :);

tic; 

for j = 1:iterasyon
    ais_klonlama_ve_mutasyon;
    ais_secim;
    
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

% Finalde En Iyi Katman Dizisini Olustur
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

% 1. Grafik: Yakinsama
figure;
plot(1:iterasyon, history, '-o', 'LineWidth', 2);
xlabel('Iterasyon'); ylabel('En Iyi Dogruluk (Afinite)');
title(sprintf('CLONALG - Yapay Sinir Agi\nEn Iyi Deger: %.6f', best_fitness));
grid on;

% 2. Grafik: Final Modeli ve Karmasiklik Matrisi
disp('-> Final modeli egitiliyor ve matris ciziliyor...');
warning('off', 'all'); % Olası uyarıları kapat
final_mdl = fitcnet(Egitim, Egitimc, ...
    'LayerSizes', best_layers, ...
    'Activations', best_act, ...
    'Lambda', best_lmbd, ...
    'IterationLimit', 500, ...
    'Standardize', true);
warning('on', 'all'); % Uyarıları geri aç

final_tahmin = predict(final_mdl, Test);
figure;
cm = confusionchart(Testc, final_tahmin);
cm.Title = sprintf('Optimize Edilmis NN Karmasiklik Matrisi (%%%.2f)', best_fitness * 100);
cm.RowSummary = 'row-normalized'; 
cm.ColumnSummary = 'column-normalized';