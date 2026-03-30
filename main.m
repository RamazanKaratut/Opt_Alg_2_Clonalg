global n m populasyon antikor_fitness klon_populasyon klon_fitness ...
       sinir_degerleri mesafe_turleri agirlik_turleri tie_turleri Egitim Egitimc Test Testc ...
       best_antikor best_fitness klon_sayisi mutasyon_katsayisi

% Baslangic Parametreleri
n = 20; 
m = 5;  
iterasyon = 15;
klon_sayisi = 5; 
mutasyon_katsayisi = 0.03;

% Sinirlar: k(1-30), Mesafe(1-4), Agirlik(1-2), Std(0-1), BreakTies(1-3)
sinir_degerleri = [1 75; 1 4; 1 2; 0 1; 1 3];

mesafe_turleri = {'euclidean', 'cityblock', 'chebychev', 'cosine'};
agirlik_turleri = {'Equal', 'Inverse'};
tie_turleri = {'smallest', 'nearest', 'random'};

disp('========================================');
disp('   YAPAY BAGISIKLIK & KNN BASLIYOR');
disp('========================================');

veri_on_isleme; 

disp('-> Ilk populasyon olusturuluyor...');
ais_populasyon_olustur;

disp('-> Ilk dogruluk hesaplaniyor...');
ais_hesapla_fitness;

% En iyi adayi bulma (Baslangic)
[best_fitness, idx] = max(antikor_fitness);
best_antikor = populasyon(idx, :);

fprintf('\nBaslangic En Iyi Dogruluk: %.4f\n', best_fitness);

sayac = 0; 
for j = 1:iterasyon
    fprintf('\n--- TUR %d ---\n', j);
    eski_best = best_fitness;
    
    ais_klonlama_ve_mutasyon;
    ais_secim;
    
    fark = best_fitness - eski_best;
    if fark > 0
        sayac = 0;
        fprintf('  -> Daha iyi bir sonuc bulundu! (+%.4f)\n', fark);
    else
        sayac = sayac + 1;
        fprintf('  -> Degisen bir sey yok. (%d keredir ayni)\n', sayac);
    end
    
    fprintf('  Guncel En Iyi Fitness : %.4f\n', best_fitness);
    fprintf('  En Iyi K degeri       : %d\n', best_antikor(1));
end

disp('========================================');
disp('               SONUC');
disp('========================================');
fprintf('En yuksek dogruluk : %.4f\n', best_fitness);
fprintf('En iyi k           : %d\n', best_antikor(1));
fprintf('En iyi mesafe      : %s\n', mesafe_turleri{best_antikor(2)});
fprintf('En iyi agirlik     : %s\n', agirlik_turleri{best_antikor(3)});
fprintf('En iyi standardize : %d\n', best_antikor(4));
fprintf('En iyi BreakTies   : %s\n', tie_turleri{best_antikor(5)});
disp('========================================');