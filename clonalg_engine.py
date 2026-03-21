import numpy as np
from sklearn.model_selection import cross_val_score

def clonalg_hpo(model_class, decode_func, num_genes, X, y, pop_size=20, max_iter=15):
    """CLONALG Algoritması ile Hiperparametre Optimizasyonu Yapar."""
    
    beta = 1.0  # Klonlama çarpanı
    rho = 2.0   # Mutasyon sabiti
    select_size = int(pop_size * 0.4) 
    random_size = int(pop_size * 0.2) 
    
    population = np.random.rand(pop_size, num_genes)
    best_overall_score = 0
    best_overall_params = None
    
    for iteration in range(max_iter):
        affinities = np.zeros(pop_size)
        for i in range(pop_size):
            params = decode_func(population[i])
            model = model_class(**params)
            score = cross_val_score(model, X, y, cv=5, scoring='accuracy').mean()
            affinities[i] = score
            
        sorted_indices = np.argsort(affinities)[::-1] 
        selected_pop = population[sorted_indices[:select_size]]
        selected_affinities = affinities[sorted_indices[:select_size]]
        
        if selected_affinities[0] > best_overall_score:
            best_overall_score = selected_affinities[0]
            best_overall_params = decode_func(selected_pop[0])
            
        clones = []
        total_affinity = np.sum(selected_affinities)
        
        for i in range(select_size):
            clone_count = max(1, int(round(beta * (selected_affinities[i] / total_affinity) * select_size)))
            
            for _ in range(clone_count):
                clone = np.copy(selected_pop[i])
                mutation_rate = rho * np.exp(-selected_affinities[i])
                
                for j in range(num_genes):
                    if np.random.rand() < mutation_rate:
                        clone[j] += mutation_rate * np.random.randn()
                        clone[j] = np.clip(clone[j], 0.0, 1.0)
                clones.append(clone)
                
        clones = np.array(clones)
        
        clone_affinities = np.zeros(len(clones))
        for i in range(len(clones)):
            params = decode_func(clones[i])
            model = model_class(**params)
            clone_affinities[i] = cross_val_score(model, X, y, cv=5, scoring='accuracy').mean()
            
        combined_pop = np.vstack((population, clones))
        combined_aff = np.concatenate((affinities, clone_affinities))
        
        new_sorted_indices = np.argsort(combined_aff)[::-1]
        population = combined_pop[new_sorted_indices[:pop_size]]
        
        population[-random_size:] = np.random.rand(random_size, num_genes)
        
    return best_overall_params, best_overall_score