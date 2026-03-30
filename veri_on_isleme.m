global Egitim Egitimc Test Testc
disp('-> Veri hazirlama basladi...');

% Veri kaynağını çalışma alanından / MAT dosyasından / CSV'den al
if exist('StudentPerformanceFactors', 'var') == 1
    processed_table = StudentPerformanceFactors;
elseif exist('veri.mat', 'file') == 2
    temp_data = load('veri.mat');
    if isfield(temp_data, 'StudentPerformanceFactors') == 1
        processed_table = temp_data.StudentPerformanceFactors;
    else
        error('veri.mat içinde StudentPerformanceFactors bulunamadi.');
    end
elseif exist('StudentPerformanceFactors.csv', 'file') == 2
    processed_table = readtable('StudentPerformanceFactors.csv', 'TextType', 'string');
else
    error('Veri kaynagi bulunamadi: StudentPerformanceFactors/veri.mat/StudentPerformanceFactors.csv');
end

if ~istable(processed_table)
    error('Veri formati table olmali.');
end

% Eksik değerleri doldur ve kategorikleri sayısallaştır
var_names = processed_table.Properties.VariableNames;
for i = 1:length(var_names)
    col = var_names{i};
    col_data = processed_table.(col);

    if isnumeric(col_data)
        temiz = col_data(~isnan(col_data));
        if isempty(temiz)
            med_val = 0;
        else
            med_val = median(temiz);
        end
        col_data(isnan(col_data)) = med_val;
        processed_table.(col) = col_data;

    elseif iscategorical(col_data) || isstring(col_data) || iscell(col_data)
        str_col = string(col_data);
        str_col(ismissing(str_col)) = "Missing";
        processed_table.(col) = grp2idx(categorical(str_col));

    elseif islogical(col_data)
        processed_table.(col) = double(col_data);

    else
        str_col = string(col_data);
        str_col(ismissing(str_col)) = "Missing";
        processed_table.(col) = grp2idx(categorical(str_col));
    end
end

% Tamamen sayısallaştırılmış tabloyu matrise dönüştürme
data_cftr = table2array(processed_table);

% Hedef değişken sürekli ise sınıflandırma için sınıflara böl
target = data_cftr(:, end);
if numel(unique(target)) > 20
    q1 = quantile(target, 0.2);
    q2 = quantile(target, 0.4);
    q3 = quantile(target, 0.6);
    q4 = quantile(target, 0.8);

    sinif = zeros(size(target));
    for i = 1:length(target)
        if target(i) <= q1
            sinif(i) = 1;
        elseif target(i) <= q2
            sinif(i) = 2;
        elseif target(i) <= q3
            sinif(i) = 3;
        elseif target(i) <= q4
            sinif(i) = 4;
        else
            sinif(i) = 5;
        end
    end

    data_cftr(:, end) = sinif;

    disp('-> Hedef 5 seviyeye bolundu.');
end

% Veriyi eğitim ve test olarak ayırma
[Egitim, Egitimc, Test, Testc] = orneklem(data_cftr);

fprintf('-> Egitim boyutu: %d x %d\n', size(Egitim, 1), size(Egitim, 2));
fprintf('-> Test boyutu  : %d x %d\n', size(Test, 1), size(Test, 2));

siniflar = unique(data_cftr(:, end));
fprintf('-> Toplam sinif: %d\n', numel(siniflar));
disp('-> Sinif dagilimi:');
for i = 1:numel(siniflar)
    s = siniflar(i);
    n_egitim = sum(Egitimc(:) == s);
    n_test = sum(Testc(:) == s);
    fprintf('   Sinif %d -> E:%d T:%d\n', s, n_egitim, n_test);
end

[~, ~, idx_test] = unique(Testc(:));
test_sayim = accumarray(idx_test, 1);
test_baseline = max(test_sayim) / numel(Testc);
fprintf('-> Test baseline: %.4f\n', test_baseline);

disp('-> Veri Egitim/Test olarak ayrildi.');