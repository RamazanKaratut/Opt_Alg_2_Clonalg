global n m populasyon sinir_degerleri

populasyon = zeros(n, m);

for i = 1:n
    for gen = 1:m
        % Sinir degerlerine gore m adet geni rastgele olustur
        populasyon(i, gen) = randi([sinir_degerleri(gen, 1), sinir_degerleri(gen, 2)]);
    end
end