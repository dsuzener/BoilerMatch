#include <pybind11/pybind11.h>
#include <pybind11/stl.h>
#include "hnsw.h"

namespace py = pybind11;

PYBIND11_MODULE(hnsw_matcher, m) {
    py::class_<HNSW>(m, "HNSW")
        .def(py::init<int, int, int, int>(),
             py::arg("dim"),
             py::arg("max_elements"),
             py::arg("M") = 16,
             py::arg("ef_construction") = 200)
        .def("add_item", &HNSW::add_item)
        .def("search", &HNSW::search);
}
