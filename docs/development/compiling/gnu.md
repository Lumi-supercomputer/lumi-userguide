# GNU Compilers


The GNU Compiler Collection (GCC) includes front ends for the C (`gcc`), C++ 
(`g++`), and Fortran (`gfortran`) programming languages. Invoking these 
compilers is done through the `ftn`, `cc` and `CC` 
[compilers wrappers][wrappers].

[wrappers]: prgenv.md#compiler-wrappers

## Choose a version

The Cray Compiling Environment is available from the `PrgEnv-gnu` module. This
module load the default version of the compiler. 

```
module load PrgEnv-gnu
```

If you wish to use an older or newer version, you can list the available version 
with

```
module avail gcc
```

and then switch to the desired version using

```
module swap gcc gcc/<version>
```

## OpenMP Support

OpenMP is turned off by default, it's turned on using the `-fopenmp` flag.

## Optimization options

:material-help-circle-outline: `man gcc` - `man gfortran`

The default optimization level of the GNU compiler is `-O0` it's therefore 
necessary to add additional optimization flags. A good starting point is

```
-O2 -ftree-vectorize -funroll-loops -ffast-math
```

- the `-O2` option performs nearly all supported optimizations
- the `-ffast-math` relax the IEEE specifications for math functions. This option
  can produce incorrect results, don't use this flag if you code is sensitive 
  to floating-point optimizations.
- the `-funroll-loops` option allows the compiler to unroll loops

A more aggressive option might be

```
-O3 -funroll-loops
```

or for even more aggressive optimization

```
-Ofast -funroll-loops
```

The `-Ofast` enables all `-O3` optimizations and disregard strict standards 
compliance.

## Compiler Feedback

Information about the optimizations and transformations performed by the 
compiler can be obtained using the `-fopt-info` option.

## Debugging

To ease a debugging process, it's useful to generate an executable containing 
debugging information. For this purpose, you can use the `-g` option. 

Most of the time, the debug information works best at low levels of code 
optimization, so consider using the `-O0` level. The `-g` options can be 
specified on a per-file basis so that only a small part of your application incur
the debugging penalty.