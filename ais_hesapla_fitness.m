global n populasyon antikor_fitness 
global Egitim Egitimc Test Testc
global split_turleri surrogate_turleri

antikor_fitness = zeros(n, 1);

for i = 1:n
    % Genlerden 5 agac parametresini cek
    max_splits = populasyon(i, 1);
    min_leaf   = populasyon(i, 2);
    split_crit = split_turleri{populasyon(i, 3)};
    surrogate  = surrogate_turleri{populasyon(i, 4)};
    min_parent = populasyon(i, 5); % 5. GEN
    
    try
        % Karar Agacini Egit (5 Parametre ile)
        mdl = fitctree(Egitim, Egitimc, ...
            'MaxNumSplits', max_splits, ...
            'MinLeafSize', min_leaf, ...
            'SplitCriterion', split_crit, ...
            'Surrogate', surrogate, ...
            'MinParentSize', min_parent);
        
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