global populasyon antikor_fitness klon_populasyon n n_secilen beta rho m sinir_degerleri

% En iyi n_secilen antikoru bul
[sirali_afinite, sirali_idx] = sort(antikor_fitness, 'descend');
secilen_idx = sirali_idx(1:n_secilen);
secilen_antikorlar = populasyon(secilen_idx, :);
secilen_afiniteler = sirali_afinite(1:n_secilen);

toplam_afinite = sum(secilen_afiniteler);
if toplam_afinite == 0
    toplam_afinite = 1; % Sifira bolme hatasini onlemek icin
end

% Klonlari tutacagimiz gecici hucre (kac tane uretilecegi bastan belli degil)
gecici_klonlar = [];

% --- KLONLAMA VE HIPERMUTASYON ---
for i = 1:n_secilen
    % Python'daki n_clones = int(beta * affinity / total_affinity) mantigi
    % MATLAB uyarlamasi: n_clones = max(1, round(beta * n * afinite / toplam))
    n_clones = round(beta * n * (secilen_afiniteler(i) / toplam_afinite));
    n_clones = max(1, n_clones); % En az 1 klon
    
    % Mutasyon oranini hesapla (Python'daki exp(-affinity) mantigi)
    % Yuksek dogruluk = dusuk mutasyon
    mutation_rate = rho * exp(-secilen_afiniteler(i));
    
    orijinal_antikor = secilen_antikorlar(i, :);
    
    for c = 1:n_clones
        mutant_klon = orijinal_antikor;
        
        % Her gen icin mutasyon ihtimalini kontrol et
        for gen = 1:m
            if rand() < mutation_rate
                % Gaussian yerine ayrilmis (discrete) genlere uygun rastgele mutasyon
                mutant_klon(gen) = randi([sinir_degerleri(gen, 1), sinir_degerleri(gen, 2)]);
            end
        end
        gecici_klonlar = [gecici_klonlar; mutant_klon];
    end
end

klon_populasyon = gecici_klonlar;