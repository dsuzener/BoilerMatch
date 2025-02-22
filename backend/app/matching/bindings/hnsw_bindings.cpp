#include <pybind11/pybind11.h>
#include <hnswlib/hnswlib.h>

namespace py = pybind11;

class HNSW {
public:
    hnswlib::L2Space space;
    hnswlib::HierarchicalNSW<float> *index;

    HNSW(int dim) : space(dim) {
       index = new hnswlib::HierarchicalNSW<float>(&space, 10000);
    }

    void add_items(std::vector<std::vector<float>> data) {
       for (size_t i = 0; i < data.size(); i++) {
           index->addPoint(data[i].data(), i);
       }
    }

    std::vector<int> query(std::vector<float> query_point, int k) {
       auto result = index->searchKnn(query_point.data(), k);
       std::vector<int> indices;
       while (!result.empty()) {
           indices.push_back(result.top().second);
           result.pop();
       }
       return indices;
    }
};

PYBIND11_MODULE(hnsw_bindings, m) {
   py::class_<HNSW>(m, "HNSW")
       .def(py::init<int>())
       .def("add_items", &HNSW::add_items)
       .def("query", &HNSW::query);
}
