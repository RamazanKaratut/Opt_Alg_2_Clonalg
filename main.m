global n m populasyon antikor_fitness klon_populasyon klon_fitness ...
       sinir_degerleri split_turleri surrogate_turleri Egitim Egitimc Test Testc ...
       best_antikor best_fitness ...
       n_secilen beta rho d_degisecek history

% CLONALG Parametreleri
n = 50;             
n_secilen = 20;     
beta = 1.0;         
rho = 2.0;          
d_degisecek = 10;   
iterasyon = 30;     

% Gen Sayisi 5'e cikarildi
m = 5;  

% Sinirlar: 
% 1:MaxNumSplits(1-100), 2:MinLeafSize(1-50), 3:SplitCriterion(1-3), 
% 4:Surrogate(1-2), 5:MinParentSize(2-100)
sinir_degerleri = [1 100; 1 50; 1 3; 1 2; 2 100];

% Kategorik genlerin karsiliklari
split_turleri = {'gdi', 'twoing', 'deviance'};
surrogate_turleri = {'off', 'on'};

history = zeros(iterasyon, 1); 

disp('========================================');
disp('  CLONALG & DECISION TREE OPTIMIZASYONU');
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
    
    fprintf('Iterasyon %d: En Iyi Dogruluk = %.6f | MaxSplits: %d, MinLeaf: %d, MinParent: %d\n', ...
            j, best_fitness, best_antikor(1), best_antikor(2), best_antikor(5));
end

calisma_suresi = toc; 

disp('========================================');
disp('               SONUCLAR');
disp('========================================');
fprintf('Calisma Suresi        : %.4f saniye\n', calisma_suresi);
fprintf('En yuksek dogruluk    : %.6f\n', best_fitness);
fprintf('En iyi MaxNumSplits   : %d\n', best_antikor(1));
fprintf('En iyi MinLeafSize    : %d\n', best_antikor(2));
fprintf('En iyi MinParentSize  : %d\n', best_antikor(5));
fprintf('En iyi SplitCriterion : %s\n', split_turleri{best_antikor(3)});
fprintf('En iyi Surrogate      : %s\n', surrogate_turleri{best_antikor(4)});
disp('========================================');

figure;
plot(1:iterasyon, history, '-o', 'LineWidth', 2);
xlabel('Iterasyon');
ylabel('En Iyi Dogruluk (Afinite)');
title(sprintf('CLONALG Yakinsama Grafigi\nEn Iyi Deger: %.6f | Sure: %.4fs', best_fitness, calisma_suresi));
grid on;