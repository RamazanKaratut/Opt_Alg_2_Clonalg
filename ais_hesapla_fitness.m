% ILK POPULASYON FITNESSES HESAPLAMA
% Her antikor icin temsil ettigi NN hiperparametreleri ile model egitilir,
% test dogrulugu hesaplanir ve fitness olarak saklanir.

global n populasyon antikor_fitness 
global Egitim Egitimc Test Testc
global aktivasyon_turleri lambda_degerleri

% Her antikorun uygunluk (dogruluk) degeri
antikor_fitness = zeros(n, 1);

warning('off', 'all'); % Egitim sirasindaki gereksiz MATLAB uyarilarini engelle

for i = 1:n
    % Ekrana anlik durumu bas (ayni satirda guncellemek yerine alt alta yazar)
    fprintf('  -> [Ilk Populasyon] Antikor %d / %d egitiliyor...\n', i, n);
    
    % Antikor genlerini oku
    L1   = populasyon(i, 1);
    L2   = populasyon(i, 2);
    L3   = populasyon(i, 3);
    act  = aktivasyon_turleri{populasyon(i, 4)};
    lmbd = lambda_degerleri(populasyon(i, 5));
    katman_sayisi = populasyon(i, 6); % 6. GEN: Katman Sayisi
    
    % Katman sayisi genine gore LayerSizes vektorunu dinamik kur
    if katman_sayisi == 1
        layers = [L1];
    elseif katman_sayisi == 2
        layers = [L1, L2];
    else
        layers = [L1, L2, L3];
    end
    
    try
        % Modeli secilen hiperparametrelerle egit
        mdl = fitcnet(Egitim, Egitimc, ...
            'LayerSizes', layers, ...
            'Activations', act, ...
            'Lambda', lmbd, ...
            'IterationLimit', 500, ...
            'Standardize', true);
        
        % Test seti tahmini al
        tahmin = predict(mdl, Test);
        
        % Etiket turune gore dogru sayisini hesapla
        if iscategorical(Testc) || iscellstr(Testc) || isstring(Testc)
             dogru_sayisi = sum(strcmp(cellstr(tahmin), cellstr(Testc)));
        else
             dogru_sayisi = sum(tahmin == Testc);
        end
        
        % Fitness = dogru tahmin orani
        antikor_fitness(i) = dogru_sayisi / length(Testc);
        
    catch
        % Egitim basarisizsa antikoru en dusuk fitness ile cezalandir
        antikor_fitness(i) = 0; 
    end
end

warning('on', 'all');