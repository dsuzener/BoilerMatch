from setuptools import setup, Extension
from pybind11.setup_helpers import Pybind11Extension, build_ext

ext_modules = [
    Pybind11Extension(
        "hnsw_matcher",
        ["cpp_modules/bindings.cpp", "cpp_modules/hnsw.cpp"],
        include_dirs=["cpp_modules"],
        extra_compile_args=['-O3'],
    ),
]

setup(
    name="hnsw_matcher",
    version="0.1",
    author="Your Name",
    author_email="your.email@example.com",
    description="HNSW matcher for BoilerMatch",
    ext_modules=ext_modules,
    cmdclass={"build_ext": build_ext},
    zip_safe=False,
    python_requires=">=3.6",
)
