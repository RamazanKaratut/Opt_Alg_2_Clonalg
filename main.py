import warnings
from sklearn.datasets import load_breast_cancer
from sklearn.model_selection import cross_val_score
from sklearn.neighbors import KNeighborsClassifier
from sklearn.linear_model import LogisticRegression
from sklearn.ensemble import GradientBoostingClassifier
from sklearn.preprocessing import StandardScaler

# Diğer dosyalardaki fonksiyonları projeye dahil ediyoruz
from decoders import decode_knn, decode_logreg, decode_gbc
from clonalg_engine import clonalg_hpo

warnings.filterwarnings("ignore")

def main():
    # 1. Veri Setini Yükle
    data = load_breast_cancer()
    X = data.data
    y = data.target

    scaler = StandardScaler()
    X = scaler.fit_transform(X)

    print("="*60)
    print("CLONALG İLE MAKİNE ÖĞRENMESİ HİPERPARAMETRE OPTİMİZASYONU")
    print("="*60)
    print(f"Veri Seti: {X.shape[0]} Örnek, {X.shape[1]} Özellik\n")

    # 2. Test Edilecek Modeller ve Yapılandırmaları
    models_to_test = [
        ("K-En Yakın Komşu (KNN)", KNeighborsClassifier, decode_knn, 2),
        ("Lojistik Regresyon", LogisticRegression, decode_logreg, 2),
        ("Gradyan Artırma (GBM)", GradientBoostingClassifier, decode_gbc, 3)
    ]

    # 3. Kıyaslama Döngüsü
    for name, model_cls, decoder, num_genes in models_to_test:
        print(f"\n>>> Model: {name}")
        print("-" * 40)
        
        # Varsayılan (Default) model başarısı
        default_model = model_cls()
        default_score = cross_val_score(default_model, X, y, cv=5, scoring='accuracy').mean()
        print(f"Varsayılan Parametre Başarısı   : % {default_score * 100:.2f}")
        
        # CLONALG ile optimize edilmiş model başarısı
        best_params, best_score = clonalg_hpo(model_cls, decoder, num_genes, X, y)
        
        print(f"CLONALG Optimize Başarısı       : % {best_score * 100:.2f}")
        print(f"Bulunan En İyi Parametreler     : {best_params}")
        print("-" * 40)

    print("\nOptimizasyon süreci başarıyla tamamlandı!")

if __name__ == "__main__":
    main()