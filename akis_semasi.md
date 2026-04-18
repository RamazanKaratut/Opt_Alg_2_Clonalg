# Proje Akis Semasi

Alt akislar ayri cizildi ki gorunum karmasik olmasin ve her adimin girdisi/ciktisi net olsun.

Ana akista cagri eslestirmesi:
- ais_hesapla_fitness: Ana akis adimi F
- ais_klonlama_ve_mutasyon: Ana akis adimi J
- ais_secim: Ana akis adimi K

## 1) Ana Akis

```mermaid
flowchart TD
    A([Baslat main.m]) --> B[CLONALG parametrelerini ayarla]
    B --> C[Gen sinirlarini tanimla 6 gen]
    C --> D[veri_on_isleme]
    D --> E[Ilk populasyonu olustur n x m]
    E --> F[ais_hesapla_fitness cagir]
    F --> G[Baslangic best_fitness ve best_antikor sec]
    G --> H[tic baslat]
    H --> I{Iterasyon devam ediyor mu}
    I -- Evet --> J[ais_klonlama_ve_mutasyon cagir]
    J --> K[ais_secim cagir]
    K --> L[history degerini kaydet]
    L --> M[Iterasyon ozeti yazdir]
    M --> N[j degerini artir]
    N --> I
    I -- Hayir --> O[toc ile toplam sureyi al]
    O --> P[best_antikoru decode et]
    P --> Q[Sonuclari yazdir]
    Q --> R[Yakinsama grafigini ciz]
    R --> S[Final modeli egit]
    S --> T[Test tahmini al]
    T --> U[Confusion chart olustur]
    U --> V([Bitis])
```

## 2) ais_hesapla_fitness Alt Akisi

```mermaid
flowchart TD
    A([Girdi: populasyon]) --> B[for i = 1..n]
    B --> C[Genleri coz: L1 L2 L3 act lambda katman_sayisi]
    C --> D{Katman sayisi}
    D -- 1 --> E[layers L1]
    D -- 2 --> F[layers L1 L2]
    D -- 3 --> G[layers L1 L2 L3]
    E --> H[fitcnet ile modeli egit]
    F --> H
    G --> H
    H --> I[predict test]
    I --> J[fitness dogru_sayisi bolu test_adedi]
    J --> K([Cikti: antikor_fitness])
```

## 3) ais_klonlama_ve_mutasyon Alt Akisi

```mermaid
flowchart TD
    A([Girdi: populasyon + antikor_fitness]) --> B[Fitnesse gore sirala]
    B --> C[En iyi n_secilen antikoru sec]
    C --> D[Secilen afiniteleri topla]
    D --> E{Toplam afinite sifir mi}
    E -- Evet --> F[toplam_afinite = 1]
    E -- Hayir --> G[Mevcut degeri kullan]
    F --> H[Her secilen antikor icin]
    G --> H
    H --> I[n_clones hesapla]
    I --> J[mutation_rate hesapla]
    J --> K[Her klonda her gen icin mutasyon dene]
    K --> L[Mutant klonlari havuza ekle]
    L --> M([Cikti: klon_populasyon])
```

## 4) ais_secim Alt Akisi

```mermaid
flowchart TD
    A([Girdi: populasyon + antikor_fitness + klon_populasyon]) --> B[Toplam klon sayisini al]
    B --> C[Her klonu egit ve klon_fitness hesapla]
    C --> D[Populasyon ve klonlari birlestir]
    D --> E[Fitnesse gore sirala]
    E --> F[unique rows ile tekrarli bireyleri ele]
    F --> G[Yeni populasyon ve fitness alanini ayir]
    G --> H[En iyi benzersiz bireyleri kopyala]
    H --> I{Yeni nesil doldu mu}
    I -- Hayir --> J[Kalanlari rastgele doldur fitness sifir]
    I -- Evet --> K[Doldurma adimini atla]
    J --> L[Cesitlilik icin son d_degisecek bireyi yenile]
    K --> L
    L --> M[populasyon ve antikor_fitness guncelle]
    M --> N{best_fitness guncellenecek mi}
    N -- Evet --> O[best_fitness ve best_antikor guncelle]
    N -- Hayir --> P[best degeri koru]
    O --> Q([Cikti: yeni populasyon + best])
    P --> Q
```
