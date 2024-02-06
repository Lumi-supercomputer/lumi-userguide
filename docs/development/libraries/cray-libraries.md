# Cray libraries

[1]: #cray-libraries
[2]: #libraries-supported-by-the-lust

[doc-fftw]: http://www.fftw.org/fftw3_doc/
[doc-hdf5]: https://portal.hdfgroup.org/display/HDF5/Learning+the+Basics
[doc-netcdf]: https://www.unidata.ucar.edu/software/netcdf/docs/
[doc-openblas]: https://github.com/xianyi/OpenBLAS/wiki/User-Manual
[doc-blis]: https://github.com/flame/blis/wiki

For the [Cray libraries](https://cpe.ext.hpe.com/docs/#hpe-cray-scientific-and-math-libraries) that are available as a modules prefixed by `cray-`, the compiler
wrappers will automatically take care of adding the search paths for the
include files and the libraries and provide the linker with the appropriate
options. This means that, as a user, you don't need to provide such information
to `cray-libsci`, `cray-fftw`, `cray-hdf5`, and `cray-netcdf`.

[libsci]: #libsci
[fftw]: #fftw
[hdf5]: #hdf5
[netcdf]: #netcdf
[netcdf-hdf5]: #netcdf-hdf5

#### LibSci

:material-package-variant: `module load cray-libsci`
:material-help-circle-outline: `man intro_libsci`

Cray LibSci is a collection of numerical routines tuned for performance on Cray
systems. Most users, for most codes, will find that they obtain better
performance by using Cray LibSci routines in their applications instead of
using public domain or user‐written versions.

The general components of Cray LibSci are:

- BLAS: Basic Linear Algebra Subroutines
- CBLAS: C interface to the legacy BLAS
- BLACS: Basic Linear Algebra Communication Subprograms
- LAPACK: Linear Algebra routines
- ScaLAPACK: parallel Linear Algebra routines

Two libraries unique to Cray are:

- IRT: Iterative Refinement Toolkit, a library of solvers and tools that
  provides solutions to linear systems using single‐precision factorizations
  while preserving accuracy through mixed‐precision iterative refinement.

- CrayBLAS: a library of BLAS routines auto-tuned for Cray EX series systems
  through extensive optimization and runtime adaptation.

!!! note "Multithreaded version"
    The OpenMP libraries will be linked in when the OpenMP compiler flag is set.

#### FFTW

:material-package-variant: `module load cray-fftw`
:material-help-circle-outline: `man intro_fftw3`

FFTW is a C subroutine library with Fortran interfaces for computing
complex-to-complex, real-to-complex, complex-to-real, and real-to-real single
and multidimensional discrete Fourier transforms (DFTs). The library also
includes routines to compute discrete cosine and sine transforms (DCTs/DSTs) on
even and odd data, respectively.

!!! note "Multithreaded version"
    The OpenMP libraries will be linked in when the OpenMP compiler flag is set.

[Official documentation][doc-fftw]

#### HDF5

:material-package-variant: `module load cray-hdf5` | `module load cray-hdf5-parallel`

HDF5 is a data model, library, and file format for storing and managing data.
It supports a variety of data types, and is designed for flexible and efficient
I/O and for high volume and complex data. HDF5 is portable and is extensible,
allowing applications to evolve in their use of HDF5. The HDF5 Technology suite
includes tools and applications for managing, manipulating, viewing, and
analyzing data in the HDF5 format.

[Official documentation][doc-hdf5]

#### NetCDF

:material-package-variant: `module load cray-netcdf` | `module load cray-parallel-netcdf`
:material-help-circle-outline: `man netcdf`

NetCDF (network Common Data Form) is a set of interfaces for array-oriented
data access and a freely distributed collection of data access libraries for C,
Fortran, C++, Java, and other languages. The netCDF libraries support a
machine-independent format for representing scientific data. Together, the
interfaces, libraries, and format support the creation, access, and sharing of
scientific data.

[Official documentation][doc-netcdf]

#### NetCDF + HDF5

:material-package-variant: `module load cray-netcdf-hdf5parallel`

A serial [NetCDF][netcdf] built against parallel [HDF5][hdf5].
