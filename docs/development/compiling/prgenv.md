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

[modules]: ../../computing/modules.md
[libraries]: libraries.md
[cray-libraries]: libraries.md#cray-libraries
[cce]: cce.md

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
particular, the `module load` command

```
$ module load PrgEnv-<name>
```

where `<name>` is the name of the compiler suite. There is 3 collections
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

After you have loaded a programming environment, [compiler wrappers][2] (`cc`,
`CC` and `ftn`) are available.

### Changing compiler versions

If the default compiler version does not suit you, you can change the version
after a programming environment versions. This operation is performed using
the `module swap` command.

```
module swap <compiler> <compiler>/<version>
```

Where `<compiler>` is the name of the compiler module for the loaded programming
environment and `<compiler>` the version you want to use. For example:

=== "CCE"

    ```
    module swap cce cce/11.0.2
    ```

=== "GNU"

    ```
    module swap gcc gcc/10.2.0
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

Detailed information about the available compilers option are available here:

- [Cray Compiling Environment][cce]

The man pages of the wrappers and of the underlying compilers are also a good 
place to explore the options. The command to access the man pages are presented 
in the table below.

| Language | Wrapper   | CCE           | GNU            |
|----------|-----------|---------------|----------------|
| C        | `man cc`  | `man craycc`  | `man gcc`      |
| C++      | `man CC`  | `man crayCC`  | `man g++`      |
| Fortran  | `man ftn` | `man crayftn` | `man gfortran` |

### Libraries Linking

The wrapper will pass the appropriate linking information to the compiler and 
linker for libraries accessible via 
[modules prefixed by `cray-`][cray-libraries]. These libraries don't require 
user-provided options in order to be linked. For other libraries, the user 
should provide the appropriate include (`-I`) and library (`-L`) search paths
as well as linking command (`-l`).

If you have used a Cray system in the past, you may be familiar with the legacy 
linking behaviour of the Cray compiler wrappers. Historically, the wrappers 
build statically linked executables. In recent version of the Cray programming 
environment this not the case anymore, libraries are now **dynamically linked**.
The following options are available to you to control the behaviour of your 
application

- Follow the default Linux policy and at runtime use the system default version
  of the shared libraries (so may change as and when system is upgraded)
- Hardcodes the path of each library into the binary at compile time so that a
  specific version is when the application start (as long as lib is still 
  installed). Set `CRAY_ADD_RPATH=yes` at compile time to use this mode.
- Allow the currently loaded programming environement modules to select the 
  library version at runtime. Application must not be linked with 
  `CRAY_ADD_RPATH=yes` and must add the following line to the Slurm script:
  ```
  export LD_LIBRARY_PATH=${CRAY_LD_LIBRARY_PATH}:$LD_LIBRARY_PATH
  ```

Static linking is unsupported at the moment.

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