global n populasyon antikor_fitness 
global Egitim Egitimc Test Testc
global aktivasyon_turleri lambda_degerleri

antikor_fitness = zeros(n, 1);

warning('off', 'all'); % Egitim sirasindaki gereksiz MATLAB uyarilarini engelle

for i = 1:n
    % Ekrana anlik durumu bas (ayni satirda guncellemek yerine alt alta yazar)
    fprintf('  -> [Ilk Populasyon] Antikor %d / %d egitiliyor...\n', i, n);
    
    % Genleri cek
    L1   = populasyon(i, 1);
    L2   = populasyon(i, 2);
    L3   = populasyon(i, 3);
    act  = aktivasyon_turleri{populasyon(i, 4)};
    lmbd = lambda_degerleri(populasyon(i, 5));
    katman_sayisi = populasyon(i, 6); % 6. GEN: Katman Sayisi
    
    % Dinamik Katman Dizisi
    if katman_sayisi == 1
        layers = [L1];
    elseif katman_sayisi == 2
        layers = [L1, L2];
    else
        layers = [L1, L2, L3];
    end
    
    try
        % Neural Network Egitimi
        mdl = fitcnet(Egitim, Egitimc, ...
            'LayerSizes', layers, ...
            'Activations', act, ...
            'Lambda', lmbd, ...
            'IterationLimit', 500, ...
            'Standardize', true);
        
        tahmin = predict(mdl, Test);
        
        if iscategorical(Testc) || iscellstr(Testc) || isstring(Testc)
             dogru_sayisi = sum(strcmp(cellstr(tahmin), cellstr(Testc)));
        else
             dogru_sayisi = sum(tahmin == Testc);
        end
        
        antikor_fitness(i) = dogru_sayisi / length(Testc);
        
    catch
        antikor_fitness(i) = 0; 
    end
end

warning('on', 'all');