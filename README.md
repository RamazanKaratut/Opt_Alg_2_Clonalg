# CLONALG ile Makine Öğrenmesi Hiperparametre Optimizasyonu

Bu proje, biyolojik bağışıklık sisteminin antijenlere karşı antikor üretme sürecini taklit eden **Klonal Seçim Algoritması (CLONALG)** kullanılarak, makine öğrenmesi modellerinin hiperparametrelerini optimize etmek amacıyla geliştirilmiştir.

## 🚀 Projenin Amacı
Geleneksel hiperparametre arama yöntemleri (Grid Search, Random Search) yerine, evrimsel ve bağışıklık tabanlı bir yaklaşım olan CLONALG kullanılarak; **KNN**, **Lojistik Regresyon** ve **Gradyan Artırma (GBM)** modellerinin en yüksek doğruluk (accuracy) değerlerine ulaşması hedeflenmiştir.

## 🧬 Algoritma Mantığı
CLONALG algoritması şu adımları izleyerek en iyi parametre setini bulur:
1. **Antikor Üretimi:** Rastgele hiperparametre setleri oluşturulur.
2. **Afinite Hesaplama:** Modeller eğitilir ve Cross-Validation skorları (başarı oranı) ölçülür.
3. **Klonlama:** En başarılı antikorlar (parametreler) başarı oranlarına göre çoğaltılır.
4. **Hipermutasyon:** Başarısı düşük olan klonlara daha yüksek, başarılı olanlara daha düşük mutasyon uygulanarak arama uzayı taranır.
5. **Reseptör Düzenleme:** Popülasyonun en kötü üyeleri atılarak yerlerine yeni rastgele çözümler eklenir (lokal minimumdan kaçış).



## 📂 Dosya Yapısı
* `main.py`: Projenin ana giriş noktası. Veri setini yükler ve modelleri test eder.
* `clonalg_engine.py`: Algoritmanın matematiksel motoru ve optimizasyon döngüsü.
* `decoders.py`: Algoritmanın ürettiği ham değerleri gerçek hiperparametrelere dönüştüren köprü fonksiyonları.

## 📊 Elde Edilen Sonuçlar
Proje kapsamında **Breast Cancer (Göğüs Kanseri)** veri seti üzerinde yapılan testlerde şu sonuçlar elde edilmiştir:

| Model | Varsayılan Başarı | CLONALG Optimize Başarı | Artış |
| :--- | :---: | :---: | :---: |
| K-En Yakın Komşu (KNN) | % 96.49 | **% 96.84** | +0.35 |
| Lojistik Regresyon | % 98.07 | **% 98.42** | +0.35 |
| Gradyan Artırma (GBM) | % 95.96 | **% 96.14** | +0.18 |

## 🛠️ Kurulum ve Çalıştırma
Projenin çalışması için Python 3.8+ ve gerekli kütüphaneler yüklü olmalıdır.

1. Kütüphaneleri yükleyin:
   ```bash
   pip install -r requirements.txt