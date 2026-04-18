flowchart TD
    A([Baslat: main.m]) --> B[Global degiskenleri ve CLONALG parametrelerini tanimla]
    B --> C[Gen uzayi sinirlari: 6 gen]
    C --> D[veri_on_isleme cagir]
    D --> E{Egitim/Test verisi hazir mi?}
    E -- Evet --> F[Mevcut Egitim Egitimc Test Testc kullan]
    E -- Hayir --> G[Fisher Iris yukle ve HoldOut=0.3 ile bol]
    F --> H[ais_populasyon_olustur: n x m rastgele antikor uret]
    G --> H
    H --> I[ais_hesapla_fitness: ilk populasyon fitness hesapla]
    I --> J[best_fitness ve best_antikor baslangic secimi]
    J --> K[tic baslat]
    K --> L{j <= iterasyon ?}
    L -- Evet --> M[ais_klonlama_ve_mutasyon]
    M --> N[ais_secim]
    N --> O[history(j)=best_fitness kaydet]
    O --> P[Iterasyon ozetini yazdir]
    P --> Q[j = j + 1]
    Q --> L
    L -- Hayir --> R[toc ile toplam sureyi al]
    R --> S[best_antikor decode et: layers act lambda]
    S --> T[Sonuclari yazdir]
    T --> U[Yakinssama grafigi ciz: history]
    U --> V[Final modeli en iyi hiperparametrelerle egit]
    V --> W[Test tahmini al]
    W --> X[Confusion chart olustur]
    X --> Y([Bitis])

    subgraph F1 [ais_hesapla_fitness alt akisi]
        I1[for i=1..n] --> I2[Genleri coz: L1 L2 L3 act lambda katman_sayisi]
        I2 --> I3{katman_sayisi}
        I3 -- 1 --> I4[layers=[L1]]
        I3 -- 2 --> I5[layers=[L1 L2]]
        I3 -- 3 --> I6[layers=[L1 L2 L3]]
        I4 --> I7[fitcnet egit]
        I5 --> I7
        I6 --> I7
        I7 --> I8[predict(Test)]
        I8 --> I9[fitness=dogru_sayisi/|Testc|]
    end
    I -. icerir .-> I1

    subgraph F2 [ais_klonlama_ve_mutasyon alt akisi]
        M1[Fitness'e gore sirala] --> M2[En iyi n_secilen antikoru sec]
        M2 --> M3[toplam_afinite=sum(secilen_afiniteler)]
        M3 --> M4{toplam_afinite == 0 ?}
        M4 -- Evet --> M5[toplam_afinite=1 yap]
        M4 -- Hayir --> M6[devam et]
        M5 --> M7[Her secilen antikor icin]
        M6 --> M7
        M7 --> M8[n_clones hesapla]
        M8 --> M9[mutation_rate hesapla]
        M9 --> M10[Her klon icin her gende mutasyon dene]
        M10 --> M11[Mutant klonu havuza ekle]
        M11 --> M12[klon_populasyon olustur]
    end
    M -. icerir .-> M1

    subgraph F3 [ais_secim alt akisi]
        N1[toplam_klon belirle] --> N2[Her klonu egit ve klon_fitness hesapla]
        N2 --> N3[combined=populasyon+klonlar]
        N3 --> N4[Fitness'e gore sirala]
        N4 --> N5[unique rows ile tekrarli bireyleri ele]
        N5 --> N6[yeni_populasyon ve yeni_fitness ayir]
        N6 --> N7[En iyi benzersiz bireyleri yeni nesle kopyala]
        N7 --> N8{n doldu mu?}
        N8 -- Hayir --> N9[Kalanlari rastgele bireylerle doldur, fitness=0]
        N8 -- Evet --> N10[devam et]
        N9 --> N10
        N10 --> N11[Cesitlilik koruma: son d_degisecek bireyi yenile]
        N11 --> N12[populasyon ve antikor_fitness guncelle]
        N12 --> N13{antikor_fitness(1) > best_fitness ?}
        N13 -- Evet --> N14[best_fitness ve best_antikor guncelle]
        N13 -- Hayir --> N15[best degismez]
    end
    N -. icerir .-> N1