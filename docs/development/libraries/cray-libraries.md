# Cray libraries

[1]: #cray-libraries
[2]: #libraries-supported-by-the-lust

[doc-fftw]: http://www.fftw.org/fftw3_doc/
[doc-hdf5]: https://portal.hdfgroup.org/display/HDF5/Learning+the+Basics
[doc-netcdf]: https://docs.unidata.ucar.edu/nug/current/
[doc-netcdf-c]: https://docs.unidata.ucar.edu/netcdf-c/current/
[doc-netcdf-c++]: https://docs.unidata.ucar.edu/netcdf-cxx/current/
[doc-netcdf-fortran]: https://docs.unidata.ucar.edu/netcdf-fortran/current/
[doc-netcdf-hdf5]: https://docs.unidata.ucar.edu/netcdf-c/4.9.3/interoperability_hdf5.html
[doc-openblas]: https://github.com/xianyi/OpenBLAS/wiki/User-Manual
[doc-pnetcdf]: https://parallel-netcdf.github.io/

For the [Cray Scientific and Math Libraries](https://cpe.ext.hpe.com/docs/latest/csml/index.html),
that are available as modules, prefixed by `cray-`, the compiler wrappers
will, automatically update the include path and provide the linker with the
appropriate options for the library to use them. This means that, as a
user, all you have to do is to load the respective module.

[libsci]: #libsci
[fftw]: #fftw
[hdf5]: #hdf5
[netcdf]: #netcdf
[netcdf-hdf5]: #netcdf-hdf5

#### LibSci

:material-package-variant: `module load cray-libsci`<br/>
:material-help-circle-outline: `man intro_libsci` or the
["Cray LibSci" web page](https://cpe.ext.hpe.com/docs/latest/csml/cray_libsci.html)

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

:material-package-variant: `module load cray-fftw`<br/>
:material-help-circle-outline: `man intro_fftw3` or the
["Cray FFTW" web page](https://cpe.ext.hpe.com/docs/latest/csml/cray_fftw.html)

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

!!! Tip "Finding out the configuration of HDF5 on LUMI"
    If you want to see how the HDF5 libraries offered by those modules are configured,
    you can check the `libhdf5.settings` file in `$HDF5_ROOT/lib` (after loading
    the module).

[Official documentation][doc-hdf5]

#### NetCDF

:material-package-variant: `module load cray-netcdf` | `module load cray-netcdf-hdf5parallel`<br/>
:material-help-circle-outline: `man netcdf` | `man netcdf_f77` | or `man netcdf_f90` and
manual pages for the `nccopy`, `ncdump`, `ncgen` and `ncgen3` commands.

NetCDF (network Common Data Form) is a set of interfaces for array-oriented
data access and a freely distributed collection of data access libraries for C,
Fortran, C++, Java, and other languages. The netCDF libraries support a
machine-independent format for representing scientific data. Together, the
interfaces, libraries, and format support the creation, access, and sharing of
scientific data.

Both NetCDF libraries run on top of HDF5. So to access `cray-netcdf`, you first
need to load `cray-hdf5`, and to access `cray-netcdf-hdf5parallel`, you first need
to load `cray-hdf5-parallel`.

!!! Tip "Finding out the configuration of NetCDF"
    If you want to see how the NetCDF libraries offered by those modules are configured,
    you can check the various `*.settings` files in `$NETCDF_DIR/lib` (after loading
    the module).

[Official documentation netCDF][doc-netcdf], 
[netCDF C API][doc-netcdf-c],
[netCDF C++ API][doc-netcdf-c++]
and [netCDF Fortran API][doc-netcdf-fortran]<br/>
[More information about netCDF on HDF5][doc-netcdf-hdf5]


#### Parallel NetCDF (or PnetCDF)

:material-package-variant: `module load cray-parallel-netcdf`<br/>
:material-help-circle-outline: `man pnetcdf` | `man pnetcdf_f77` | `man pnetcdf_f90`
and manual pages for commands.

PnetCDF is a high-performance parallel I/O library for accessing 
Unidata's NetCDF, files in classic formats, specifically the formats of CDF-1, 2, and 5.
The API is more extensive then the regular netCDF API, also offering a set of 
nonblocking APIs that can give better performance when used well.

!!! Tip "Finding out the configuration of PnetCDF"
    The `pnetcdf_version` command will show how the library is configured on LUMI.

[Official documentation of PnetCDF](doc-pnetcdf)
