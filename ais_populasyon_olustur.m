global n m populasyon sinir_degerleri

populasyon = zeros(n, m);
for i = 1:n
    for k_var = 1:m
        min_val = sinir_degerleri(k_var, 1);
        max_val = sinir_degerleri(k_var, 2);
        populasyon(i, k_var) = round(min_val + rand() * (max_val - min_val));
    end
end