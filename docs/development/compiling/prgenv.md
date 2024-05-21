# Programming environment

[1]: #compiler-suites
  [1.1]: #switching-compiler-suites
  [1.2]: #changing-compiler-versions
[2]: #compiler-wrappers
  [2.1]: #wrapper-and-compiler-options
  [2.2]: #libraries-linking
  [2.3]: #using-the-wrapper-with-a-configure-script
[3]: #compile-an-mpi-program
[4]: #compile-an-openmp-application
[5]: #accessing-the-programming-environment-on-lumi

[modules]: ../../runjobs/lumi_env/Lmod_modules.md
[softwarestacks]: ../../runjobs/lumi_env/softwarestacks.md
[easybuild]: ../../software/installing/easybuild.md
[libraries]: ../../development/libraries/cray-libraries.md
[cce]: cce.md
[gnu]: gnu.md
[lumi-c]: ../../hardware/lumic.md
[lumi-d]: ../../hardware/lumid.md
[lumi-g]: ../../hardware/lumig.md
[eap]: ../../hardware/compute/eap.md

This page will give you an overview of the [Cray programming environment](https://cpe.ext.hpe.com/docs/) that is
available on LUMI. It starts with a presentation of the [compiler suites][1]
and [compiler wrappers][2] that you can use to compile your C, C++ or Fortran
code. Finally, some basic information on how to compile an [MPI][3] or
[OpenMP][4] program is given.

## Compiler Suites

On LUMI, the different compiler suites are accessible using module collections.
These collections load the appropriate modules to use one of the supported
programming environments for LUMI.

### Switching compiler suites

The compiler collections are accessible through [modules][modules] and in
particular, the `module load` command:

```bash
$ module load PrgEnv-<name>
```

where `<name>` is the name of the compiler suite. There are 3 collections
available on LUMI. The default collection is Cray.

|      | Description                   | Module collection |
|------|-------------------------------|-------------------|
| CCE  | Cray Compiling Environment    | `PrgEnv-cray`     |
| AMD  | AMD ROCm compilers            | `PrgEnv-amd`      |
| GCC  | GNU Compiler Collection       | `PrgEnv-gnu`      |
| AOCC | AMD Optimizing C/C++ Compiler | `PrgEnv-aocc`     |

For example, if you want to use the GNU’s compiler collection:

```bash
$ module load PrgEnv-gnu
```

After you have loaded a programming environment, the [compiler wrappers][2]
(`cc`, `CC` and `ftn`) are available.

??? Bug "PrgEnv-aocc broken in 21.08 and 21.12"
    The ``PrgEnv-aocc`` module does not work correctly in the 21.08 and 21.12
    releases of the Cray programming environment. This is due to different
    reasons. The ``aocc/3.0.0`` module (used as the default version of AOCC in
    the 21.08 release) is broken since the compilers themselves are not
    installed. The ``aocc/3.1.0`` module has a bug in the code of the module.
    This has been fixed in later releases of the Cray programming environment
    so that the problem will be solved when those releases are installed. Due to
    the way the installation of the Cray programming environment works, it is
    currently not possible for us to correct the module by hand.

### Changing compiler versions

If the default compiler version does not suit you, you can change the version
after having a loaded a programming environment. This operation is performed
using the `module swap` command.

```bash
$ module swap <compiler> <compiler>/<version>
```

where `<compiler>` is the name of the compiler module for the loaded
programming environment and `<version>` the version you want to use. For
example

=== "CCE"

    ```bash
    $ module swap cce cce/11.0.2
    ```

=== "GNU"

    ```bash
    $ module swap gcc gcc/10.2.0
    ```

## Compiler Wrappers

The module collection provides wrappers to the C, C++ and Fortran compilers. The
commands used to invoke these wrappers are listed below.

- `cc`: C compiler
- `CC`: C++ compiler
- `ftn`: Fortran compiler

No matter which vendor's compiler module is loaded, always use one of the above
commands to invoke the compiler. Using these wrappers will invoke the
underlying compiler according to the [compiler suite][1] that is loaded in the
environment. For some libraries, the appropriate option for the linking will
also be included. See [here][2.2] for more information.

!!! note "About MPI Wrappers"
    The Cray compiler wrappers replace other wrappers commonly found on HPC
    systems like the `mpicc`, `mpic++` and `mpif90` wrappers. You don't need to
    use these wrappers to compile an MPI code on LUMI. See [here][3].

Below are examples how to use the wrappers for the different programming languages.

=== "C"

    ```bash
    $ cc -c source1.c
    $ cc -c source2.c
    $ cc source1.o source2.o -o myprogram 
    ```

=== "C++"

    ```bash
    $ CC -c source1.cpp
    $ CC -c source2.cpp
    $ CC source1.o source2.o -o myprogram 
    ```

=== "Fortran"

    ```bash
    $ ftn -c source1.f90
    $ ftn -c source2.f90
    $ ftn source1.o source2.o -o myprogram 
    ```

In the example above, no additional options are provided. However, in most cases
this is not the case and the arguments used with the commands vary according to
which compiler module is loaded. For example, the arguments and options
supported by the GNU Fortran compiler are different from those supported by the
Cray Fortran compiler.

### Wrapper and compiler options

The following flags are a good starting point to achieve good performance:

| Compilers    | Good performance                                  | Aggressive optimizations |
|--------------|---------------------------------------------------|--------------------------|
| Cray C/C++   | `-O2 -funroll-loops -ffast-math`                  | `-Ofast -funroll-loops`  |
| Cray Fortran | Default                                           | `-O3 -hfp3`              |
| GCC          | `-O2 -ftree-vectorize -funroll-loops -ffast-math` | `-Ofast -funroll-loops`  |

Detailed information about the available compiler options is available here:

- [Cray Compiling Environment][cce]
- [The GNU Compilers][gnu]

The man pages of the wrappers and of the underlying compilers are also a good
place to explore the options. The commands to access the man pages are presented
in the table below.

| Language | Wrapper   | CCE           | GNU            |
|----------|-----------|---------------|----------------|
| C        | `man cc`  | `man craycc`  | `man gcc`      |
| C++      | `man CC`  | `man crayCC`  | `man g++`      |
| Fortran  | `man ftn` | `man crayftn` | `man gfortran` |

### Choosing the target architecture

When using the Cray programming environment, there is no need to specify
compiler flags to target specific CPU architecture, like `-march` and `-mtune`
in GCC or `--offload-arch` for GPU compilation. Instead, you load an appropriate
combination of modules to choose the target architecture when compiling. 
These modules influence the optimizations performed by the compiler, as well as
the libraries (e.g., which BLAS routines are used in Cray LibSci) used. Here is a
list of the relevant CPU target module available on LUMI:

- `craype-x86-trento` : GPU partition GPUs (LUMI-G)
- `craype-x86-milan`  : CPU partition CPUs (LUMI-C)
- `craype-x86-rome`   : Login nodes and data analytics partition CPUs (LUMI-D)

We recommend that you compile with `craype-x86-trento` for LUMI-G and 
`craype-x86-milan` for LUMI-C, even if the compiler optimizations for these 
processors are immature at the moment. **You have to load these modules yourself
when compiling your code from a login node** as the default module is 
`craype-x86-rome`.

In addition to the `craype-x86-*` modules for the CPUs, `craype-accel-*` modules 
can be used to specify the target GPU architecture. Here is a list of the
relevant modules:

- `craype-accel-amd-gfx90a` : GPU partition GPUs (AMD MI250x, LUMI-G)
- `craype-accel-nvidia80`   : data analytics and visualization GPUs (NVIDIA A40, LUMI-D)

Loading one of these modules will instruct the compiler wrappers to add the
necessary flags to optimize for the target GPU architecture. In addition, loading
a  `craype-accel-*` module will enable the linking to the GPU transfer library
(GTL) used for GPU-aware MPI as well as enabling OpenMP target offload.

### Libraries Linking

The wrapper will pass the appropriate linking information to the compiler and
linker for libraries accessible via [modules prefixed by
`cray-`][libraries]. These libraries don't require user-provided options
to be linked. For other libraries, the user should provide the
appropriate include (`-I`) and library (`-L`) search paths as well as linking
command (`-l`).

If you have used a Cray system in the past, you may be familiar with the legacy
linking behavior of the Cray compiler wrappers. Historically, the wrappers
built statically linked executables. In recent versions of the Cray programming
environment, this is not the case anymore: libraries are now **dynamically
linked**. The following options are available to you to control the behavior
of your application

- Follow the default Linux policy and at runtime use the system default version
  of the shared libraries (so may change as and when the system is upgraded)
- Hard code the path of each library into the binary at compile time so that a
  specific version is loaded when the application starts (as long as the library
  is still installed). Set `CRAY_ADD_RPATH=yes` at compile time to use this
  mode.
- Allow the currently loaded programming environment modules to select the
  library version at runtime. Applications must not be linked with
  `CRAY_ADD_RPATH=yes` and must add the following line to the Slurm script:
  
  ```bash
  export LD_LIBRARY_PATH=${CRAY_LD_LIBRARY_PATH}:$LD_LIBRARY_PATH
  ```

Static linking is unsupported by Cray at the moment.

### Using the wrappers with build systems

To compile an application that uses a series of `./configure`, `make`,
and `make install` commands, you can pass the compiler wrappers in the
appropriate environment variables.
This should be sufficient for a `configure` step to succeed.

```bash
$ ./configure CC=cc CXX=CC FC=ftn
```

CMake should automatically detect the Cray environment. If you want to be
on the safe side, you can explicitly provide the compiler wrappers at configure
time using the flags

```bash
cmake \
  -DCMAKE_C_COMPILER=cc \
  -DCMAKE_CXX_COMPILER=CC \
  -DCMAKE_Fortran_COMPILER=ftn \
  <other options>
```

For other tools, you can try to export environment variables so that the tool
you are using is aware of the wrappers.

=== "C"

    ```bash
    export CC=cc 
    ```

=== "C++"

    ```bash
    export CXX=CC
    ```

=== "Fortran"

    ```bash
    export FC=ftn
    export F77=ftn
    export F90=ftn
    ```

## Compile HIP Code

## Using the compiler wrapper

The `PrgEnv-cray` and `PrgEnv-amd` programming environments can compile HIP 
code using the compiler wrapper. The advantage of using the wrapper is that the
flags to use the Cray libraries (`cray-*` modules) are automatically added 
(including MPI).

=== "PrgEnv-cray"

    ```
    module load PrgEnv-cray
    module load craype-accel-amd-gfx90a
    module load rocm

    CC -xhip -o <yourapp> <hip_source.cpp>
    ```

=== "PrgEnv-amd"

    ```
    module load PrgEnv-amd
    module load craype-accel-amd-gfx90a
    module load rocm

    CC -xhip -o <yourapp> <hip_source.cpp>
    ```

### Using `hipcc`

Unlike the compiler wrappers, `hipcc` do not add automatically the flags to use
the Cray libraries (`cray-*` modules). Loading a `craype-accel-*` will have
no effect as well, i.e., you need to specify the target GPU architecture 
yourself with `--offload-arch`.

Still, you can set the value of `HIPCC_COMPILE_FLAGS_APPEND` and 
`HIPCC_LINK_FLAGS_APPEND` environment variables to make `hipcc` behave like the
Cray compiler wrappers.

```
module load PrgEnv-amd

export HIPCC_COMPILE_FLAGS_APPEND="--offload-arch=gfx90a $(CC --cray-print-opts=cflags)"
export HIPCC_LINK_FLAGS_APPEND=$(CC --cray-print-opts=libs)

hipcc -o <yourapp> <hip_source.cpp>
```

## Compile an MPI Program

When you load a programming environment, the appropriate MPI module is loaded in
the environment: `cray-mpich`. In addition, the `craype-network-ofi` network 
target module should be loaded. These two modules are loaded by default when you
log in to LUMI.

Compiling an MPI application is done using the set of compiler wrappers
(`cc`, `CC`, `ftn`). The wrappers will automatically link codes with the MPI
libraries. You can see the compiler wrappers as the more the familiar `mpicc`, 
`mpicxx` and `mpifort` wrappers.

If you are using a build system that uses a `configure` script, you may need to
provide the appropriate variables so that the correct wrapper is used.
For example

```bash
$ ./configure MPICC=cc MPICXX=CC MPIF77=ftn MPIF90=ftn
```

For CMake, if you already provided the compiler as described 
[in the previous section](#using-the-wrappers-with-build-systems), CMake should
correctly select the wrappers as the MPI compilers.

### GPU-aware MPI

If your application requires a GPU-aware MPI implementation, i.e., pass GPU 
memory pointers directly to MPI without copying to the host first, then you need to
link your code to the GPU Transfer Library (GTL). The compiler wrappers will
link automatically to this library if a GPU target module (`craype-accel-*`) is
loaded.

=== "PrgEnv-cray"

    ```
    module load PrgEnv-cray
    module load craype-accel-amd-gfx90a
    module load rocm
    ```

=== "PrgEnv-amd"

    ```
    module load PrgEnv-amd
    module load craype-accel-amd-gfx90a
    module load rocm
    ```

Then, for example, we can compile a simple MPI + HIP code with the following
command

```
CC -xhip -o <yourapp> <mpi_and_hip_code.cpp>
```

and inspect the linking of the resulting executable. That will show that both
the MPI and GPU transfer libraries are linked

``` 
$ ldd ./yourapp | grep libmpi
    libmpi_cray.so.12 => /opt/cray/pe/lib64/libmpi_cray.so.12
    libmpi_gtl_hsa.so.0 => /opt/cray/pe/lib64/libmpi_gtl_hsa.so.0
```

!!! warning "GPU support needs to be enabled at run time"

    When running your application, you need to enable the GPU support. This is done by
    setting the value of `MPICH_GPU_SUPPORT_ENABLED` to `1`:

    ```bash
    export MPICH_GPU_SUPPORT_ENABLED=1
    ```

## Compile an OpenMP Application

For all programming environments, the compilation of OpenMP host code is possible by
enabling OpenMP when invoking the compiler wrappers (`cc`, `CC`, `ftn`). The
flag to enable OpenMP is `-fopenmp` for all programming environments and 
compiler wrappers.

!!! info

    When using the OpenMP compiler flag, the wrapper will link to the
    [multithreaded version of the Cray libraries][libraries].

### Compile an application with OpenMP offloading

Using the `PrgEnv-cray`, `PrgEnv-amd`, you can compile application using OpenMP
target offloading. Like for OpenMP for the host (CPU), this is done by using the
`-fopenmp` flag but first you need to load a `craype-accel-*` target module.

=== "PrgEnv-cray"

    ```bash
    module load PrgEnv-cray
    module load rocm
    module load craype-accel-amd-gfx90a
    ```

=== "PrgEnv-amd"

    ```bash
    module load PrgEnv-amd
    module load craype-accel-amd-gfx90a
    ```

The `craype-accel-amd-gfx90a` will instruct the compiler wrappers to 
automatically add the appropriate flags for OpenMP offloading.

## Compile an OpenACC application

At the moment, the only compiler that supports OpenACC compilation on LUMI is the
Cray Fortran compiler. OpenACC can be enabled by the `-hacc` flag.

```
module load PrgEnv-cray
module load craype-accel-amd-gfx90a
module load rocm

ftn -hacc -o <yourapp> <openacc_source.f90>
```

## Accessing the programming environment on LUMI

The Cray programming environment can be accessed in three different ways on LUMI:

1. Right after login, ``PrgEnv-cray`` is loaded as most users familiar with
   Cray systems would expect. The set of target modules is not adapted to the
   node that you are on but a set that is safe for the whole system. Users are
   responsible for managing those modules and swapping with an appropriate set.
   Executing ``module purge`` will unload the target modules also and cause
   error messages when you subsequently try to load a programming environment
   as some modules (including ``cray-mpich`` and ``cray-fftw``) can only be
   loaded when a suitable target module is loaded.

2. Working in the ``CrayEnv`` [software stack][softwarestacks]: (Re)-loading
   the ``CrayEnv`` module will (re)set the target modules to an optimal set for
   the node type that you are on. Executing ``module purge`` will also trigger
   a reload of ``CrayEnv``, unless the ``--force`` option is used to unload the
   module.

     The ``CrayEnv`` stack also provides an updated set of build tools and some
   other tools useful to programmers in a way that they cannot conflict with
   tools in the ``LUMI`` software stacks (which is why they are not offered in
   the bare environment).

     We advise users who want to use the Cray programming environment but do not
   need any of the libraries etc. installed in the ``LUMI`` software stacks to
   use the ``CrayEnv`` stack rather than the bare environment.

3. Working in the ``LUMI`` [software stack][softwarestacks]: The ``LUMI``
   software stack offers a range of libraries and packages mostly installed via
   [EasyBuild][easybuild]. It is possible to install additional software on top
   of those stacks using EasyBuild, and use those libraries and tools to
   compile or develop other software outside the EasyBuild environment.

     Each ``LUMI`` stack corresponds to a particular release of the Cray
   programming environment. It is possible to use the ``PrgEnv`` modules in
   this environment. However, EasyBuild requires its own set of modules to
   integrate with the Cray programming environment and we advise users to use
   those instead when working in the ``LUMI`` stack: ``cpeCray`` replaces
   ``PrgEnv-cray``, ``cpeGNU`` replaces ``PrgEnv-gnu``, ``cpeAOCC`` replaces
   ``PrgEnv-aocc`` and ``cpeAMD`` will replace ``PrgEnv-amd`` when that
   environment becomes available on the [LUMI-G][lumi-g] partition. These
   modules also take care of the target architecture modules based on the
   ``partition`` module that is loaded (which offer a way to do cross-compiling
   for another section of LUMI than you are working on).

!!! Remark "Workaround for ``PrgEnv/aocc`` bug in 21.12"
    The ``cpeAOCC/21.12`` in ``LUMI/21.12`` contains a workaround for the
    problems with the ``aocc/3.1.0`` module. Hence, it is possible to use
    the AOCC compilers bh working in the ``LUMI/21.12`` stack and using
    ``cpeAOCC/21.12`` rather than loading the ``PrgEnv-aocc`` module.
