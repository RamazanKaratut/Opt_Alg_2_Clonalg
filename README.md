# CLONALG ile Karar Ağacı (Decision Tree) Hiperparametre Optimizasyonu

Bu proje, biyolojik bağışıklık sisteminin antijenlere karşı antikor üretme sürecini taklit eden **Klonal Seçim Algoritması (CLONALG)** kullanılarak, makine öğrenmesi modellerinin hiperparametrelerini optimize etmek amacıyla MATLAB üzerinde geliştirilmiştir.

## 🚀 Projenin Amacı
Geleneksel hiperparametre arama yöntemleri (Grid Search, Random Search) yerine, evrimsel ve bağışıklık tabanlı bir yaklaşım olan CLONALG kullanılarak **Karar Ağacı (Decision Tree - `fitctree`)** modelinin en yüksek doğruluk (accuracy) değerlerine ulaşması hedeflenmiştir. 

Optimizasyon sürecinde karar ağacının ezberlemesini (overfitting) önleyen ve yapısını belirleyen **5 kritik hiperparametre** hedeflenmiştir:
1. `MaxNumSplits` (Maksimum Bölünme Sayısı: 1-100)
2. `MinLeafSize` (Minimum Yaprak Boyutu: 1-50)
3. `MinParentSize` (Bölünme İçin Gereken Minimum Veri: 2-100)
4. `SplitCriterion` (Bölünme Kriteri: Gini, Twoing, Deviance)
5. `Surrogate` (Eksik Veri Kararları: On, Off)

## 🧬 Algoritma Mantığı
CLONALG algoritması şu adımları izleyerek en iyi parametre setini bulur:
1. **Antikor Üretimi:** Rastgele Decision Tree hiperparametre setleri (Kromozom/Gen) oluşturulur.
2. **Afinite Hesaplama:** Modeller bu parametrelerle eğitilir ve test seti üzerindeki doğruluk oranları (afinite) ölçülür.
3. **Klonlama:** En başarılı antikorlar (parametreler) başarı oranlarına göre orantılı olarak çoğaltılır (İyi olan çok kopyalanır).
4. **Hipermutasyon:** Başarısı düşük olan klonlara daha yüksek, başarılı olanlara daha düşük mutasyon uygulanarak arama uzayı taranır (Ters orantılı mutasyon).
5. **Çeşitlilik Koruma (Diversity Maintenance):** Popülasyonun en kötü üyeleri atılarak yerlerine tamamen rastgele yeni çözümler eklenir (Lokal minimumdan kaçış).

## 📂 Dosya Yapısı
Proje, modüler bir yapıda tasarlanmıştır:
* `main.m`: Projenin ana giriş noktasıdır. Başlangıç parametrelerini (pop_size, beta, rho vb.) belirler ve döngüyü başlatır.
* `veri_on_isleme.m`: Eğitim ve Test verilerini (Feature ve Label) workspace'e yükler veya düzenler.
* `ais_populasyon_olustur.m`: Başlangıç popülasyonunu belirlenen sınırlar dahilinde rastgele üretir.
* `ais_hesapla_fitness.m`: Popülasyondaki parametreleri `fitctree` modeline göndererek afinite (doğruluk) skorlarını hesaplar.
* `ais_klonlama_ve_mutasyon.m`: En iyi antikorları seçer, orantılı klonlar ve ters orantılı hipermutasyona uğratır.
* `ais_secim.m`: Ana popülasyon ile mutantları birleştirir, en iyileri seçer ve en kötüleri yenileyerek çeşitliliği korur.

## 📊 Elde Edilen Sonuçlar
Proje kapsamında veri seti üzerinde yapılan testlerde şu sonuçlar elde edilmiştir:

| Model | Varsayılan Başarı | CLONALG Optimize Başarı | Artış | En İyi Parametreler |
| :--- | :---: | :---: | :---: | :--- |
| Karar Ağacı (Decision Tree) | *[Hesaplanacak]* | ***[Hesaplanacak]*** | *[Hesaplanacak]* | *MaxSplits: -* <br> *MinLeaf: -* <br> *MinParent: -* <br> *Split: -* <br> *Surrogate: -* |

*(Not: Algoritma çalıştırıldıktan sonra elde edilen en iyi sonuçlar buraya eklenecektir.)*

## 🛠️ Kurulum ve Çalıştırma
Projenin çalışması için **MATLAB** ve **Statistics and Machine Learning Toolbox** kurulu olmalıdır. Harici bir kütüphane kurulumuna (örn. requirements.txt) gerek yoktur.

1. Proje dosyalarını (`.m` uzantılı) aynı klasöre dizin.
2. `Egitim`, `Egitimc`, `Test` ve `Testc` verilerinizi MATLAB workspace'ine alın (Eğer boşsa `veri_on_isleme.m` örnek olarak Fisher Iris veri setini yükleyecektir).
3. MATLAB üzerinden `main.m` dosyasını çalıştırın.
4. Komut penceresinden iterasyonları takip edebilir, çalışma sonunda ekrana gelecek yakınsama (convergence) grafiğini inceleyebilirsiniz.