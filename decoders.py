import numpy as np

def decode_knn(genes):
    """K-En Yakın Komşu (KNN) için genleri hiperparametrelere çevirir."""
    n_neighbors = int(np.clip(genes[0] * 50, 1, 50)) 
    weights = 'distance' if genes[1] > 0.5 else 'uniform'
    return {'n_neighbors': n_neighbors, 'weights': weights}

def decode_logreg(genes):
    """Lojistik Regresyon için genleri hiperparametrelere çevirir."""
    C = 10 ** (genes[0] * 4 - 2)  
    penalty = 'l2' if genes[1] > 0.5 else 'l1'
    return {
        'C': C, 
        'penalty': penalty, 
        'solver': 'liblinear',
        'max_iter': 50  # Çok yüksek tutma, CLONALG zaten birçok kez deneyecek
    }

def decode_gbc(genes):
    """GBM'i hızlandırmak için hiperparametre sınırlarını daraltıyoruz."""
    # Ağaç sayısını 10 ile 50 arasına çekiyoruz (Çok daha hızlı)
    n_estimators = int(np.clip(genes[0] * 40 + 10, 10, 50))
    
    # Öğrenme oranını sabit tutabiliriz
    learning_rate = genes[1] * 0.19 + 0.01 
    
    # Derinliği maksimum 3 yapıyoruz (Hesaplamayı devasa hızlandırır)
    max_depth = int(np.clip(genes[2] * 1 + 2, 2, 3))         
    
    return {
        'n_estimators': n_estimators, 
        'learning_rate': learning_rate, 
        'max_depth': max_depth,
        'random_state': 42
    }