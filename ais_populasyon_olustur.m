global n m populasyon sinir_degerleri

% Populasyon matrisini onceden tahsis et (hiz kazandirir)
populasyon = zeros(n, m);

for i = 1:n
    % 1. Gen: K Degeri
    populasyon(i, 1) = randi([sinir_degerleri(1,1), sinir_degerleri(1,2)]);
    % 2. Gen: Mesafe Turu
    populasyon(i, 2) = randi([sinir_degerleri(2,1), sinir_degerleri(2,2)]);
    % 3. Gen: Agirlik Turu
    populasyon(i, 3) = randi([sinir_degerleri(3,1), sinir_degerleri(3,2)]);
    % 4. Gen: Standardizasyon (0 veya 1)
    populasyon(i, 4) = randi([sinir_degerleri(4,1), sinir_degerleri(4,2)]);
    % 5. Gen: BreakTies
    populasyon(i, 5) = randi([sinir_degerleri(5,1), sinir_degerleri(5,2)]);
end