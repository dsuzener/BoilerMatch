import networkx as nx  # NetworkX for graph operations

class GraphNNMatcher:
    def __init__(self):
        """
        Initialize an empty graph for user connections.
        """
        self.graph = nx.Graph()
    
    def add_profile(self, user_id, attributes):
        """
        Add a user profile as a node in the graph.
        :param user_id: Unique ID for the user.
        :param attributes: User attributes (e.g., preferences).
        """
        self.graph.add_node(user_id, **attributes)
    
    def connect_profiles(self, user1_id, user2_id, weight):
        """
        Add an edge between two profiles with a similarity weight.
        :param user1_id: ID of the first user.
        :param user2_id: ID of the second user.
        :param weight: Similarity score between users.
        """
        self.graph.add_edge(user1_id, user2_id, weight=weight)
    
    def find_matches(self, user_id, top_k=10):
        """
        Find top-k matches for a given user based on edge weights.
        :param user_id: ID of the target user.
        :param top_k: Number of matches to return.
        :return: List of matched user IDs.
        """
        neighbors = sorted(
            self.graph[user_id].items(),
            key=lambda x: x[1]['weight'],
            reverse=True
        )
        
        return [neighbor[0] for neighbor in neighbors[:top_k]]
