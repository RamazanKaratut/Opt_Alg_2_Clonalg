global Egitim Egitimc Test Testc

% Workspace'te bu degiskenler yoksa veya bossa uyari verip ornek yukler
if isempty(Egitim) || isempty(Egitimc) || isempty(Test) || isempty(Testc)
    disp('-> Workspace''te veriler bulunamadi! Ornek (Fisher Iris) yukleniyor...');
    load fisheriris;
    cv = cvpartition(species, 'HoldOut', 0.3);
    Egitim = meas(training(cv), :);
    Egitimc = species(training(cv));
    Test = meas(test(cv), :);
    Testc = species(test(cv));
else
    disp('-> Egitim ve Test verileri basariyla alindi.');
end