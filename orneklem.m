function [egitim, egitimc, test, testc] = orneklem(data)
% ORNEKLEM ALMA FONKSIYONU (SISTEMATIK ORNEKLEME)
% Giris:
%   data -> Son sutunu sinif etiketi olan veri matrisi
% Cikis:
%   egitim, egitimc -> egitim ozellikleri ve etiketleri
%   test, testc     -> test ozellikleri ve etiketleri

% Teste ayrilacak veri orani (yuzde)
ornekyuzde = 30 ;

% Toplam gozlem sayisi
N =  size(data,1);
% Teste alinacak toplam ornek sayisi
n = floor(N*ornekyuzde/100) ;

% Sistematik ornekleme adimi (devir sayisi)
d = round(N/n) ; 

% Baslangic indeksi (istenirse 1..d araliginda rastgele secilebilir)
a = 1 ;
% Toplam sutun sayisi (son sutun sinif)
s = size(data,2) ;

% TEST VERI SETI OLUSTURMA:
% a, a+d, a+2d, ... indekslerinden satir secilir.
for i=1:n
    B=(a+d*(i-1));
    % Indeks N'i asarsa basa sararak devam et
    if (B>N)
        C=B-N;
    else
        C=B;
    end
	test1(i,:) = data(C,:) ;
end

test = test1(:,1:s-1) ;

testc = test1(:,s) ;

% EGITIM VERI SETI OLUSTURMA:
% Teste secilen satirlar ana veriden silinir.

egitim1 = data ;
for i=1:n
	silme(i) = (a+d*(i-1)) ;
end    
    
silme=sort(silme,'descend');

for i=1:n
    k = silme(i) ;
    egitim1(k,:) = [] ;
end    

egitim = egitim1(:,1:s-1) ;

egitimc = egitim1(:,s) ;

end