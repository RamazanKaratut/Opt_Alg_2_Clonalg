% VERI ON ISLEME
% Bu proje sadece kullanicinin veri seti ile calisir.
% Veri ayrimi orneklem(data) fonksiyonu ile yapilir.

global Egitim Egitimc Test Testc

% Workspace'te bu degiskenler yoksa veya bossa, sadece proje verisini yukle.
if isempty(Egitim) || isempty(Egitimc) || isempty(Test) || isempty(Testc)
    if exist('veri.mat', 'file') ~= 2
        error(['Veri bulunamadi. Ornek veri yedegi kapatildi. ', ...
               'Lutfen veri.mat dosyasini proje klasorune koyun.']);
    end

    s = load('veri.mat');

    % Ham veri beklenir: son sutun sinif etiketi.
    if isfield(s, 'data')
        ham_veri = s.data;
    elseif isfield(s, 'veri')
        ham_veri = s.veri;
    elseif isfield(s, 'dataset')
        ham_veri = s.dataset;
    else
        error(['veri.mat icinde ham veri bulunamadi. ', ...
               'Beklenen degisken adlari: data, veri veya dataset. ', ...
               'Veri son sutunda sinif etiketi olacak sekilde kaydedilmelidir.']);
    end

    if isnumeric(ham_veri) == 0 || size(ham_veri, 2) < 2
        error(['Ham veri formati gecersiz. ', ...
               'orneklem(data) icin en az 2 sutunlu sayisal bir matris gereklidir ', ...
               've son sutun sinif etiketi olmalidir.']);
    end

    [Egitim, Egitimc, Test, Testc] = orneklem(ham_veri);
    disp('-> Veri veri.mat dosyasindan yuklendi ve orneklem ile egitim/test olarak ayrildi.');
else
    % Disaridan uygun formatta veri geldiyse dogrudan kullan
    disp('-> Egitim ve Test verileri basariyla alindi.');
end