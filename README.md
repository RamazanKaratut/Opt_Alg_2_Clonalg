# CLONALG ile Yapay Sinir Ağı (Neural Network) Optimizasyonu

Bu proje, biyolojik bağışıklık sisteminin antijenlere karşı antikor üretme sürecini taklit eden **Klonal Seçim Algoritması (CLONALG)** kullanılarak, MATLAB üzerinde geliştirilen çok katmanlı yapay sinir ağlarının (Trilayered Neural Network) hiperparametrelerini optimize etmeyi hedefler.

## 🚀 Projenin Amacı
Geleneksel hiperparametre arama yöntemleri yerine evrimsel bir yaklaşım olan CLONALG kullanılarak **Yapay Sinir Ağı (`fitcnet`)** modelinin en yüksek doğruluk (accuracy) değerlerine ulaşması hedeflenmiştir. 

Sinir ağının mimarisini ve öğrenme yeteneğini belirleyen **5 kritik hiperparametre** gen olarak kodlanmış ve optimize edilmiştir:
1. `Layer 1 Size`: İlk gizli katmandaki nöron sayısı (5-100)
2. `Layer 2 Size`: İkinci gizli katmandaki nöron sayısı (5-100)
3. `Layer 3 Size`: Üçüncü gizli katmandaki nöron sayısı (5-100)
4. `Activations`: Aktivasyon fonksiyonu (relu, tanh, sigmoid, none)
5. `Lambda`: L2 Regülarizasyon (Aşırı öğrenmeyi önleme) katsayısı

## 🧬 Algoritma Mantığı
CLONALG algoritması şu adımları izler:
1. **Antikor Üretimi:** Rastgele ağ mimarileri ve hiperparametre setleri (Kromozom/Gen) oluşturulur.
2. **Afinite Hesaplama:** Sinir ağları bu parametrelerle eğitilir ve test seti üzerindeki doğruluk oranları (afinite) ölçülür.
3. **Klonlama:** En başarılı antikorlar (ağ mimarileri) başarı oranlarına göre orantılı olarak çoğaltılır.
4. **Hipermutasyon:** Başarısı düşük olan klonlara daha yüksek, başarılı olanlara daha düşük mutasyon uygulanarak arama uzayı taranır.
5. **Çeşitlilik Koruma (Diversity Maintenance):** Popülasyonun en kötü üyeleri atılarak yerlerine tamamen rastgele yeni ağ çözümleri eklenir.

## 📂 Dosya Yapısı
* `main.m`: Projenin ana giriş noktasıdır ve optimizasyon döngüsünü yönetir.
* `veri_on_isleme.m`: Veri setini yükler ve Eğitim/Test olarak böler.
* `ais_populasyon_olustur.m`: Başlangıç antikorlarını üretir.
* `ais_hesapla_fitness.m`: `fitcnet` modelini eğiterek doğruluğu (afiniteyi) hesaplar.
* `ais_klonlama_ve_mutasyon.m`: En iyi modelleri seçer, orantılı klonlar ve ters orantılı mutasyona uğratır.
* `ais_secim.m`: Çeşitliliği koruyarak yeni jenerasyonu belirler.

## 📊 Elde Edilen Sonuçlar

| Model | Varsayılan Başarı | CLONALG Optimize Başarı | En İyi Ağ Mimarisi |
| :--- | :---: | :---: | :--- |
| Yapay Sinir Ağı (NN) | *[Hesaplanacak]* | ***[Hesaplanacak]*** | *Katmanlar: -* <br> *Aktivasyon: -* <br> *Lambda: -* |

## 🛠️ Kurulum ve Çalıştırma
Çalıştırmak için **MATLAB** ve **Statistics and Machine Learning Toolbox** gereklidir.
1. Proje dosyalarını (`.m`) aynı dizine yerleştirin.
2. Eğitim ve Test verilerinizi workspace'e alın.
3. `main.m` dosyasını çalıştırın.