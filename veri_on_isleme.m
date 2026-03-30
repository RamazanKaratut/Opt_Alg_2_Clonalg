global Egitim Egitimc Test Testc

% Veriyi okuma
data_tbl = readtable('StudentPerformanceFactors.csv');
data_tbl = rmmissing(data_tbl); % Boş verileri temizle

% Kategorik (sözel) sütunları sayısala (indekslere) dönüştürme
varNames = data_tbl.Properties.VariableNames;
for c = 1:length(varNames)-1
    if iscell(data_tbl.(varNames{c})) || isstring(data_tbl.(varNames{c}))
        data_tbl.(varNames{c}) = grp2idx(categorical(data_tbl.(varNames{c})));
    end
end

% kNN 'ClassNames', [0; 1] kısıtı için hedef değişkeni binarize etme.
% Sınav notu >= 70 olanları 1 (Geçti), altındakileri 0 (Kaldı) yapıyoruz.
score = data_tbl.Exam_Score;
data_tbl.Exam_Score = double(score >= 70); 

% Tabloyu matrise çevirip orneklem.m fonksiyonuna gönderme
data_matris = table2array(data_tbl);

% Senin belirttiğin hoca kodunu kullanıyoruz
[Egitim, Egitimc, Test, Testc] = orneklem(data_matris);