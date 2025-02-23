#pragma once
#include <vector>
#include <string>
#include <unordered_map>
#include <random>
#include <algorithm>
#include <cmath>

class HNSW {
public:
    HNSW(int dim, int max_elements, int M = 16, int ef_construction = 200);
    void add_item(const std::vector<float>& vec, const std::string& label);
    std::vector<std::pair<std::string, float>> search(const std::vector<float>& query, int k);

private:
    struct Node {
        std::vector<float> vec;
        std::string label;
        std::vector<std::vector<size_t>> neighbors;
    };

    int dim;
    int max_elements;
    int M;
    int ef_construction;
    int max_level;
    std::vector<Node> nodes;
    std::unordered_map<std::string, size_t> label_to_index;
    std::mt19937 rng;

    float distance(const std::vector<float>& a, const std::vector<float>& b);
    int get_random_level();
    std::vector<size_t> search_layer(const std::vector<float>& query, size_t ep, int ef, int level);
};
