---
description: |
  Discover the LUMI programming environment.
---

# Programming Environment

[1]: #compiler-suites
  [1.1]: #switching-compiler-suites
  [1.2]: #changing-compiler-versions
[2]: #compiler-wrappers
  [2.1]: #wrapper-and-compiler-options
  [2.2]: #libraries-linking
  [2.3]: #using-the-wrapper-with-a-configure-script
[3]: #compile-an-mpi-program
[4]: #compile-an-openmp-program
[5]: #accessing-the-programming-environment-on-lumi

[modules]: ../../computing/Lmod_modules.md
[softwarestacks]: ../../computing/softwarestacks.md
[easybuild]: ../../software/installing/easybuild.md
[libraries]: libraries.md
[cray-libraries]: libraries.md#cray-libraries
[cce]: cce.md
[gnu]: gnu.md

This page will give you an overview of the Cray programming environment. It 
starts with a presentation of the [programming environments][1] and
[compiler wrappers][2] that you can use to compile your C, C++ or Fortran code.
Finally, some basic information on how to compile an [MPI][3] or [OpenMP][4]
programs are given.

## Compiler Suites

On LUMI, the different compiler suites are accessible using module collections.
These collections load the appropriates modules to use one of the supported
programming environments for LUMI.

### Switching compiler suites

The compiler collections are accessible through [modules][modules] and in 
particular, the `module load` command:

```
$ module load PrgEnv-<name>
```

where `<name>` is the name of the compiler suite. There are 3 collections
available on LUMI. The default collection is Cray.

|      | Description                   | Module collection |
|------|-------------------------------|-------------------|
| CCE  | Cray Compiling Environment    | `PrgEnv-cray`     |
| GCC  | GNU Compiler Collection       | `PrgEnv-gnu`      |
| AOCC | AMD Optimizing C/C++ Compiler | `PrgEnv-aocc`     |

For example, if you want to use the GNU’s compiler collection:

```
$ module load PrgEnv-gnu
```

After you have loaded a programming environment, the [compiler wrappers][2] (`cc`,
`CC` and `ftn`) are available.

### Changing compiler versions

If the default compiler version does not suit you, you can change the version
after having a loaded a programming environment. This operation is performed using
the `module swap` command.

```
$ module swap <compiler> <compiler>/<version>
```

Where `<compiler>` is the name of the compiler module for the loaded programming
environment and `<compiler>` the version you want to use. For example

=== "CCE"

    ```
    $ module swap cce cce/11.0.2
    ```

=== "GNU"

    ```
    $ module swap gcc gcc/10.2.0
    ```


## Compiler Wrappers

The module collection provides wrappers to the C, C++ and Fortran compilers. The
command used to invoke these wrappers are listed below.

- `cc`: C compiler
- `CC`: C++ compiler
- `ftn`: Fortran compiler

No matter which vendor's compiler module is loaded, always use one of the above
commands to invoke the compiler. Using these wrappers will invoke the underlying 
compiler according to the [compiler suite][1] that is loaded in the environment. 
For some libraries, the appropriate option for the linking will also be 
included. See [here][2.2] for more information.


!!! note "About MPI Wrappers"
    The Cray compiler wrappers replace other wrappers commonly found on HPC 
    systems like the `mpicc`, `mpic++` and `mpif90` wrappers. You don't need to
    use these wrappers to compile an MPI code on LUMI. See [here][3].

Below are examples on how to use the wrappers for the different programming
languages.

=== "C"

    ```
    cc -c source1.c
    cc -c source2.c
    cc source1.o source2.o -o myprogram 
    ```

=== "C++"

    ```
    CC -c source1.cpp
    CC -c source2.cpp
    CC source1.o source2.o -o myprogram 
    ```

=== "Fortran"

    ```
    ftn -c source1.f90
    ftn -c source2.f90
    ftn source1.o source2.o -o myprogram 
    ```

In the example above, no additional options are provided. However, in most cases
this is not the case and the arguments used with the commands vary according to
which compiler module is loaded. For example, the  arguments and options
supported by the GNU Fortran compiler are different from those supported by the
Cray Fortran compiler.

### Wrapper and compiler options

The following flags are a good starting point to achieved good performance:

| Compilers	   | Good performance                                  | Aggressive optimizations |
|--------------|---------------------------------------------------|-------------------------|
| Cray C/C++	 | `-O2 -funroll-loops -ffast-math`                  | `-Ofast -funroll-loops` |
| Cray Fortran | Default                                           | `-O3 -hfp3`             |
| GCC	         | `-O2 -ftree-vectorize -funroll-loops -ffast-math` | `-Ofast -funroll-loops` |

Detailed information about the available compiler options are available here:

- [Cray Compiling Environment][cce]
- [The GNU Compilers][gnu]


The man pages of the wrappers and of the underlying compilers are also a good 
place to explore the options. The command to access the man pages are presented 
in the table below.

| Language | Wrapper   | CCE           | GNU            |
|----------|-----------|---------------|----------------|
| C        | `man cc`  | `man craycc`  | `man gcc`      |
| C++      | `man CC`  | `man crayCC`  | `man g++`      |
| Fortran  | `man ftn` | `man crayftn` | `man gfortran` |

### Choosing the target architecture

When using the Cray programming environment, there is no need to specify compiler flags to target specific CPU architecture, like `-march` and `-mtune` in gcc. Instead, you load an appropriate combination of modules to choose the target architecture when compiling. These modules influence the optimizations performed by the compiler, as well as the libraries (e.g. which BLAS routines are used in Cray LibSci) used. Therefore, we recommend that you compile with `craype-x86-milan` for LUMI-C, even if the compiler optimizations for Zen 3 processors are immature at the moment.

The table below summarize the available modules.

| Module                    | Target                                     |
|---------------------------|--------------------------------------------|
| `craype-x86-milan`        | LUMI-C CPUs                                |
| `craype-x86-rome`         | LUMI-D CPUs, login nodes CPUs and EAP CPUs |
| `craype-accel-amd-gfx908` | EAP GPUs                                   |
| `craype-accel-nvidia75`   | LUMI-D GPUs                                | 

### Libraries Linking

The wrapper will pass the appropriate linking information to the compiler and 
linker for libraries accessible via 
[modules prefixed by `cray-`][cray-libraries]. These libraries don't require 
user-provided options in order to be linked. For other libraries, the user 
should provide the appropriate include (`-I`) and library (`-L`) search paths
as well as linking command (`-l`).

If you have used a Cray system in the past, you may be familiar with the legacy 
linking behaviour of the Cray compiler wrappers. Historically, the wrappers 
built statically linked executables. In recent versions of the Cray programming 
environment, this not the case anymore, libraries are now **dynamically linked**.
The following options are available to you to control the behaviour of your 
application

- Follow the default Linux policy and at runtime use the system default version
  of the shared libraries (so may change as and when system is upgraded)
- Hard code the path of each library into the binary at compile time so that a
  specific version is loaded when the application start (as long as the library is still 
  installed). Set `CRAY_ADD_RPATH=yes` at compile time to use this mode.
- Allow the currently loaded programming environment modules to select the 
  library version at runtime. Applications must not be linked with 
  `CRAY_ADD_RPATH=yes` and must add the following line to the Slurm script:
  ```
  export LD_LIBRARY_PATH=${CRAY_LD_LIBRARY_PATH}:$LD_LIBRARY_PATH
  ```

Static linking is unsupported by Cray at the moment.

### Using the wrapper with a `configure` script

In order to compile an application that uses a series of `./configure`,
`make`, and `make install` commands, you can pass the compiler  wrappers in the
appropriate environment variables. This should be sufficient for a configure
step to succeed.

```
./configure CC=cc CXX=CC FC=ftn
```

For other tools, you can try to export environment variables so that the tool
you are using is aware of the wrappers.

=== "C"

    ```
    export CC=cc 
    ```

=== "C++"

    ```
    export CXX=CC
    ```

=== "Fortran"

    ```
    export FC=ftn
    export F77=ftn
    export F90=ftn
    ```

## Compile an MPI Program

When you load a programming environment, the appropriate MPI module is loaded in
the environment (`cray-mpich`). In order to compile your MPI program, you
should use the set of compiler wrappers (`cc`, `CC`, `ftn`). The wrappers
will automatically link codes with the MPI libraries.

If you are using a build system that uses a `configure` script, you may need to
provide the appropriate variables so that the correct wrapper is used.
For example:

```
./configure MPICC=cc MPICXX=CC MPIF77=ftn MPIF90=ftn
```

## Compile an OpenMP Program

The table below summarizes the compiler flags used to enable OpenMP for the
different compilers.

| Language | CCE        | GCC        | AOCC       |
|----------|------------|------------|------------|
| C/C++    | `-fopenmp` | `-fopenmp` | `-fopenmp` |
| Fortran  | `-h omp`   | `-fopenmp` | n.a.       |

When using the OpenMP compiler flag, the wrapper will link to the 
[multithreaded version of the Cray libraries][cray-libraries].


## Accessing the programming environment on LUMI

The Cray programming environment can be accessed in three different ways on LUMI:

1.  Right after login, ``PrgEnv-cray`` is loaded, pretty much as users familiar with
    Cray systems would expect. The set of target modules however is not adapted to the
    node that you are on but a set that is safe for the whole system. Users are 
    responsible for managing those modules and swapping with an additional set. Executing
    ``module purge`` will unload the target modules also and cause error messages when you
    try to subsequently load a programming environment as some modules (including
    ``cray-mpich``) can only be loaded when a suitable target module is loaded.

2.  Working in the ``CrayEnv`` [software stack][softwarestacks]: (Re)-loading the 
    ``CrayEnv`` module will (re)set the target modules to an optimal set for the
    node type that you are on. Executing ``module purge`` will also trigger a reload
    of ``CrayEnv``, unless the ``--force`` option is used. 

    The ``CrayEnv`` stack also provides an updated set of build tools and some other tools
    useful to programmers in a way that they cannot conflict with tools in the ``LUMI``
    software stacks (which is why they are not offered in the bare environment).

    We advise users who want to use the Cray programming environment but do not need
    any of the libraries etc. installed in the ``LUMI`` software stacks to use the
    ``CrayEnv`` stack rather than the bare environment.

3.  Working in the ``LUMI`` [software stack][softwarestacks]: The ``LUMI`` software stack
    offers a range of libraries and packages mostly installed via [EasyBuild][easybuild].
    It is possible to install additional software on top of those stacks using EasyBuild,
    and use those libraries and tools to compile or develop other software outside the
    EasyBuild environment.

    Each ``LUMI`` stack corresponds to a particular release of the Cray programming environment.
    It is possible to use the ``PrgEnv`` modules in this environment. However, EasyBuild
    requires its own set of modules to integrate with the Cray programming environment and we 
    advise users to use those instead when working in the ``LUMI`` stack: ``cpeCray`` replaces
    ``PrgEnv-cray``, ``cpeGNU`` replaces ``PrgEnv-gnu``, ``cpeAOCC`` replaces ``PrgEnv-aocc``  
    and ``cpeAMD`` will replace ``PrgEnv-amd`` when that environment becomes available on the
    LUMI-G partition. These modules also take care of the target architecture modules based
    on the ``partition`` module that is loaded (which offer a way to do cross-compiling for
    another section of LUMI than you are working on).

