% ILK POPULASYONU OLUSTUR
% Her satir bir antikoru, her sutun bir geni temsil eder.
% Gen degerleri, tanimlanan alt-ust sinirlar icinde rastgele uretilir.

global n m populasyon sinir_degerleri

% Populasyon matrisi: n adet antikor, m adet gen
populasyon = zeros(n, m);

for i = 1:n
    for gen = 1:m
        % Geni, kendi araligina uygun sekilde rastgele ata
        populasyon(i, gen) = randi([sinir_degerleri(gen, 1), sinir_degerleri(gen, 2)]);
    end
end