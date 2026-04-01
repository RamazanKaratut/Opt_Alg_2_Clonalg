% KLONLAMA VE HIPERMUTASYON
% En iyi antikorlar secilir, afiniteye orantili sayida klon uretilir,
% sonra her klon gen bazinda mutasyona tabi tutulur.

global populasyon antikor_fitness klon_populasyon n n_secilen beta rho m sinir_degerleri

% Fitness'e gore sirala ve en iyi n_secilen antikoru al
[sirali_afinite, sirali_idx] = sort(antikor_fitness, 'descend');
secilen_idx = sirali_idx(1:n_secilen);
secilen_antikorlar = populasyon(secilen_idx, :);
secilen_afiniteler = sirali_afinite(1:n_secilen);

% Normalize klon sayisi hesabinda kullanilacak toplam afinite
toplam_afinite = sum(secilen_afiniteler);
if toplam_afinite == 0
    toplam_afinite = 1; % Sifira bolme hatasini onlemek icin
end

% Klonlar dinamik artacagi icin gecici matriste toplanir
gecici_klonlar = [];

% --- KLONLAMA VE HIPERMUTASYON ---
for i = 1:n_secilen
    % Afinite yuksekse daha fazla klon üret
    n_clones = round(beta * n * (secilen_afiniteler(i) / toplam_afinite));
    n_clones = max(1, n_clones); % En az 1 klon
    
    % Yuksek fitness -> dusuk mutasyon (koruyucu davranis)
    mutation_rate = rho * exp(-secilen_afiniteler(i));
    
    orijinal_antikor = secilen_antikorlar(i, :);
    
    for c = 1:n_clones
        mutant_klon = orijinal_antikor;
        
        % Her gen icin mutasyon olasiligini ayri ayri uygula
        for gen = 1:m
            if rand() < mutation_rate
                % Ayrik gen alanina uygun rastgele yeniden atama
                mutant_klon(gen) = randi([sinir_degerleri(gen, 1), sinir_degerleri(gen, 2)]);
            end
        end
        % Uretilen mutant klonu havuza ekle
        gecici_klonlar = [gecici_klonlar; mutant_klon];
    end
end

% Sonraki adimda degerlendirilecek klon populasyonu
klon_populasyon = gecici_klonlar;