import hnswlib  # Python wrapper for HNSW

class HNSWMatcher:
    def __init__(self, space='cosine', dim=128):
        """
        Initialize the HNSW index.
        :param space: Distance metric ('cosine', 'l2', etc.)
        :param dim: Dimensionality of the vectors.
        """
        self.index = hnswlib.Index(space=space, dim=dim)
        self.index.init_index(max_elements=10000, ef_construction=200, M=16)
    
    def add_profiles(self, profile_vectors):
        """
        Add user profiles to the HNSW index.
        :param profile_vectors: List of user vectors.
        """
        self.index.add_items(profile_vectors)
    
    def query(self, vector, k=10):
        """
        Query the nearest neighbors.
        :param vector: Query vector.
        :param k: Number of neighbors to return.
        :return: List of nearest neighbors.
        """
        return self.index.knn_query(vector, k=k)
