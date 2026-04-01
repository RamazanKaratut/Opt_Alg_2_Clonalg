% VERI ON ISLEME
% Beklenen global degiskenler yoksa Fisher Iris veri setini ornek olarak
% yukler ve veriyi egitim/test olarak ayirir.

global Egitim Egitimc Test Testc

% Workspace'te bu degiskenler yoksa veya bossa uyari verip ornek yukler
if isempty(Egitim) || isempty(Egitimc) || isempty(Test) || isempty(Testc)
    disp('-> Workspace''te veriler bulunamadi! Ornek (Fisher Iris) yukleniyor...');
    load fisheriris;
    % HoldOut=0.3 => verinin %30'u test, %70'i egitim
    cv = cvpartition(species, 'HoldOut', 0.3);
    % Ozellik matrisi (meas) ve sinif etiketleri (species) olarak ayir
    Egitim = meas(training(cv), :);
    Egitimc = species(training(cv));
    Test = meas(test(cv), :);
    Testc = species(test(cv));
else
    % Disaridan uygun formatta veri geldiyse dogrudan kullan
    disp('-> Egitim ve Test verileri basariyla alindi.');
end