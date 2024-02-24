# GNU compilers

[gcc-opt]: https://gcc.gnu.org/onlinedocs/gcc/Optimize-Options.html
[gcc-debug]: https://gcc.gnu.org/onlinedocs/gcc/Debugging-Options.html
[gcc-dev]: https://gcc.gnu.org/onlinedocs/gcc/Developer-Options.html

The GNU Compiler Collection (GCC) includes front ends for the C (`gcc`), C++
(`g++`), and Fortran (`gfortran`) programming languages. Invoking these
compilers is done through the `ftn`, `cc` and `CC` [compilers
wrappers][wrappers].

[wrappers]: ../../development/compiling/prgenv.md#compiler-wrappers

## Choose a version

The GNU Compiler Collection is available from the `PrgEnv-gnu` module. This
module loads the default version of the compiler.

```bash
$ module load PrgEnv-gnu
```

If you wish to use an older or newer version, you can list the available
version with

```bash
$ module avail gcc
```

and then switch to the desired version using

```bash
$ module swap gcc gcc/<version>
```

As of April 2022, GCC versions 9.3.0, 10.3.0, and 11.2.0 are available on LUMI.
We recommend using GCC 11, if possible, because it can optimize code
specifically for the Zen 3 processors in LUMI (with the `craype-x86-milan`
module or the compiler flag `-march=znver3`). GCC 9 and 10 can only optimize
for Zen 2 processors.
The performance difference is quite small, though (on average ca 1%, according to e.g.
[these tests from Phoronix](https://www.phoronix.com/scan.php?page=article&item=amd-znver3-gcc11&num=1)).

## OpenMP Support

OpenMP is turned off by default. You can turn it on using the `-fopenmp` flag.

## Optimization options

:material-help-circle-outline: `man gcc` - `man gfortran`

The default optimization level of the GNU compiler is `-O0`. It is therefore
necessary to add additional optimization flags. A good starting point is

```bash
-O2 -ftree-vectorize -funroll-loops -ffast-math
```

- the `-O2` option performs nearly all supported optimizations
- the `-ffast-math` relax the IEEE specifications for math functions. This option
  can produce incorrect results, don't use this flag if your code is sensitive 
  to floating-point optimizations.
- the `-funroll-loops` option allows the compiler to unroll loops

A more aggressive option might be

```bash
-O3 -funroll-loops
```

or for even more aggressive optimization

```bash
-Ofast -funroll-loops
```

The `-Ofast` enables all `-O3` optimizations and disregards strict standards
compliance.

- [GCC documentation about optimization options][gcc-opt]

## Legacy Fortran codes

It is common to experience problems when compiling older Fortran codes with GCC
10 and newer versions. Typically, these codes are not fully compliant with the
Fortran standard. The most common error message is `Error: Type mismatch ...`
in connection with MPI calls. In those cases, a less strict compiler mode can
be activated with the extra flags:

```bash
-fallow-argument-mismatch
```

or

```bash
-std=legacy
```

## Compiler Feedback

Information about the optimizations and transformations performed by the
compiler can be obtained using the `-fopt-info` option.

- [GCC documentation about developer options][gcc-dev]

## Debugging

To ease a debugging process, it is useful to generate an executable containing
debugging information. For this purpose, you can use the `-g` option.

Most of the time, the debug information works best at low levels of code
optimization, so consider using the `-O0` level. The `-g` options can be
specified on a per-file basis so that only a small part of your application
incurs the debugging penalty.

- [GCC documentation about debug options][gcc-debug]
