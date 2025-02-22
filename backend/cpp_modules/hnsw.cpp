#include "hnsw.h"
#include <queue>
#include <limits>
#include <unordered_set>

HNSW::HNSW(int dim, int max_elements, int M, int ef_construction)
    : dim(dim), max_elements(max_elements), M(M), ef_construction(ef_construction), max_level(0), rng(std::random_device{}()) {
    nodes.reserve(max_elements);
}

void HNSW::add_item(const std::vector<float>& vec, const std::string& label) {
    if (nodes.size() >= max_elements) {
        throw std::runtime_error("Cannot add more elements, max_elements reached");
    }

    int level = get_random_level();
    Node new_node{vec, label, std::vector<std::vector<size_t>>(level + 1)};
    size_t new_index = nodes.size();

    if (nodes.empty()) {
        nodes.push_back(std::move(new_node));
        label_to_index[label] = new_index;
        max_level = level;
        return;
    }

    size_t ep = 0;  // entry point
    for (int lc = max_level; lc >= 0; lc--) {
        std::vector<size_t> neighbors = search_layer(vec, ep, 1, lc);
        ep = neighbors[0];

        if (lc <= level) {
            std::vector<size_t>& new_node_neighbors = new_node.neighbors[lc];
            new_node_neighbors = search_layer(vec, ep, M, lc);

            for (size_t neighbor : new_node_neighbors) {
                nodes[neighbor].neighbors[lc].push_back(new_index);
                if (nodes[neighbor].neighbors[lc].size() > M) {
                    std::partial_sort(nodes[neighbor].neighbors[lc].begin(),
                                      nodes[neighbor].neighbors[lc].begin() + M,
                                      nodes[neighbor].neighbors[lc].end(),
                                      [this, &neighbor](size_t a, size_t b) {
                                          return distance(nodes[neighbor].vec, nodes[a].vec) <
                                                 distance(nodes[neighbor].vec, nodes[b].vec);
                                      });
                    nodes[neighbor].neighbors[lc].resize(M);
                }
            }
        }
    }

    nodes.push_back(std::move(new_node));
    label_to_index[label] = new_index;
    max_level = std::max(max_level, level);
}

std::vector<std::pair<std::string, float>> HNSW::search(const std::vector<float>& query, int k) {
    size_t ep = 0;  // entry point
    for (int lc = max_level; lc > 0; lc--) {
        std::vector<size_t> neighbors = search_layer(query, ep, 1, lc);
        ep = neighbors[0];
    }

    std::vector<size_t> neighbors = search_layer(query, ep, ef_construction, 0);
    
    std::partial_sort(neighbors.begin(), neighbors.begin() + std::min(k, static_cast<int>(neighbors.size())), neighbors.end(),
                      [this, &query](size_t a, size_t b) {
                          return distance(query, nodes[a].vec) < distance(query, nodes[b].vec);
                      });

    std::vector<std::pair<std::string, float>> result;
    for (int i = 0; i < std::min(k, static_cast<int>(neighbors.size())); i++) {
        result.emplace_back(nodes[neighbors[i]].label, distance(query, nodes[neighbors[i]].vec));
    }

    return result;
}

float HNSW::distance(const std::vector<float>& a, const std::vector<float>& b) {
    float sum = 0;
    for (int i = 0; i < dim; i++) {
        float diff = a[i] - b[i];
        sum += diff * diff;
    }
    return std::sqrt(sum);
}

int HNSW::get_random_level() {
    std::uniform_real_distribution<float> distribution(0.0, 1.0);
    float r = distribution(rng);
    return static_cast<int>(-std::log(r) * (1.0 / std::log(2)));
}

std::vector<size_t> HNSW::search_layer(const std::vector<float>& query, size_t ep, int ef, int level) {
    std::priority_queue<std::pair<float, size_t>> candidates;
    std::priority_queue<std::pair<float, size_t>> result;
    std::unordered_set<size_t> visited;

    float d = distance(query, nodes[ep].vec);
    candidates.emplace(-d, ep);
    result.emplace(d, ep);
    visited.insert(ep);

    while (!candidates.empty()) {
        auto current = candidates.top();
        if (-current.first > result.top().first) {
            break;
        }
        candidates.pop();

        for (size_t neighbor : nodes[current.second].neighbors[level]) {
            if (visited.find(neighbor) == visited.end()) {
                visited.insert(neighbor);
                float d = distance(query, nodes[neighbor].vec);
                if (d < result.top().first || result.size() < ef) {
                    candidates.emplace(-d, neighbor);
                    result.emplace(d, neighbor);
                    if (result.size() > ef) {
                        result.pop();
                    }
                }
            }
        }
    }

    std::vector<size_t> neighbors;
    while (!result.empty()) {
        neighbors.push_back(result.top().second);
        result.pop();
    }
    std::reverse(neighbors.begin(), neighbors.end());
    return neighbors;
}
