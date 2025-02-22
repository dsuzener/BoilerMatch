import networkx as nx

class BipartiteMatcher:
    def __init__(self):
        """
        Initialize an empty bipartite graph.
        """
        self.graph = nx.Graph()
    
    def add_user(self, user_id, group):
        """
        Add a user to one side of the bipartite graph.
        :param user_id: Unique ID for the user.
        :param group: Group name ('M' or 'W').
        """
        self.graph.add_node(user_id, bipartite=group)
    
    def add_preference(self, user1_id, user2_id, weight):
        """
        Add an edge with a preference weight between two users in different groups.
        :param user1_id: ID from group 'M'.
        :param user2_id: ID from group 'W'.
        :param weight: Preference score between users.
        """
        self.graph.add_edge(user1_id, user2_id, weight=weight)
    
    def find_optimal_matches(self):
        """
        Use the Hungarian algorithm to find optimal matches.
        :return: List of matched pairs.
        """
        return nx.algorithms.matching.max_weight_matching(self.graph)
