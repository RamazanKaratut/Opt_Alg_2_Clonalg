global n m populasyon antikor_fitness klon_populasyon klon_fitness ...
       sinir_degerleri split_turleri surrogate_turleri Egitim Egitimc Test Testc ...
       best_antikor best_fitness ...
       n_secilen beta rho d_degisecek history

% CLONALG Parametreleri (Python koduna sadik kalinarak)
n = 50;             % pop_size: Populasyon buyuklugu
n_secilen = 20;     % n_selected: Secilecek en iyi antikor sayisi
beta = 1.0;         % Klon carpani
rho = 2.0;          % Mutasyon sabiti (hipermutasyon icin)
d_degisecek = 10;   % d: Her iterasyonda yenilenecek antikor sayisi
iterasyon = 30;     % max_iter

m = 4;  % Genler: 1:MaxNumSplits, 2:MinLeafSize, 3:SplitCriterion, 4:Surrogate

% Sinirlar: MaxNumSplits(1-100), MinLeafSize(1-50), SplitCriterion(1-3), Surrogate(1-2)
sinir_degerleri = [1 100; 1 50; 1 3; 1 2];

% Kategorik genlerin karsiliklari
split_turleri = {'gdi', 'twoing', 'deviance'};
surrogate_turleri = {'off', 'on'};

history = zeros(iterasyon, 1); % Yakinsama grafigi icin

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

tic; % Sure olcumu baslangici

for j = 1:iterasyon
    % 1. Adim: Klonlama ve Hipermutasyon
    ais_klonlama_ve_mutasyon;
    
    % 2. Adim: Yeni Afiniteleri Hesapla, Secim Yap ve Cesitliligi Koru (d parametresi)
    ais_secim;
    
    % Tarihceyi kaydet
    history(j) = best_fitness;
    
    fprintf('Iterasyon %d: En Iyi Dogruluk = %.6f | MaxSplits: %d, MinLeaf: %d\n', ...
            j, best_fitness, best_antikor(1), best_antikor(2));
end

calisma_suresi = toc; % Sure olcumu bitisi

disp('========================================');
disp('               SONUCLAR');
disp('========================================');
fprintf('Calisma Suresi        : %.4f saniye\n', calisma_suresi);
fprintf('En yuksek dogruluk    : %.6f\n', best_fitness);
fprintf('En iyi MaxNumSplits   : %d\n', best_antikor(1));
fprintf('En iyi MinLeafSize    : %d\n', best_antikor(2));
fprintf('En iyi SplitCriterion : %s\n', split_turleri{best_antikor(3)});
fprintf('En iyi Surrogate      : %s\n', surrogate_turleri{best_antikor(4)});
disp('========================================');

% Yakinsama Grafigi (Python'daki plt.plot karsiligi)
figure;
plot(1:iterasyon, history, '-o', 'LineWidth', 2);
xlabel('Iterasyon');
ylabel('En Iyi Dogruluk (Afinite)');
title(sprintf('CLONALG Yakinsama Grafigi\nEn Iyi Deger: %.6f | Sure: %.4fs', best_fitness, calisma_suresi));
grid on;