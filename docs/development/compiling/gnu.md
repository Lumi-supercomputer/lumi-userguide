# GNU compilers

[gcc-opt]: https://gcc.gnu.org/onlinedocs/gcc/Optimize-Options.html
[gcc-debug]: https://gcc.gnu.org/onlinedocs/gcc/Debugging-Options.html
[gcc-dev]: https://gcc.gnu.org/onlinedocs/gcc/Developer-Options.html

The GNU Compiler Collection (GCC) includes front ends for the C (`gcc`), C++
(`g++`), and Fortran (`gfortran`) programming languages. Invoking these
compilers is done through the `ftn`, `cc` and `CC` [compilers
wrappers][wrappers].
The GNU compilers on LUMI support CPU-side OpenMP but do not support 
OpenMP offload. Given the poor performance of OpenMP offload
in the GNU compilers and lack of upstream support, the LUST has no intend 
to provide their own builds with OpenMP offload support. The much better
supported LLVM-based compilers are recommended for this.

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
$ module avail gcc-native
```

and then switch to the desired version using

```bash
$ module swap gcc-native gcc-native/<version>
```

!!! Note "'gcc' and 'gcc-native' modules"
    HPE Cray used to package their own build of the GNU compiler collection in
    the programming environment. These compilers were simply called via the 
    drivers `gcc`, `g++` and `gfortran`, and after loading the `gcc` module that
    provides them, they overwrite the system `gcc`, etc., as they are before those
    in the search path. They also came with the corresponding manual pages.

    In the 23.12 release, HPE switched to the regular SUSE development packages to
    provide the GNU compilers. They are installed in the regular system directories
    (`/usr/bin`) and to not clash with the system default compiler, they have their
    major version appended to the name of the compiler commands. So you can use those
    compilers even without loading any module by calling, e.g., `gcc-14`, etc.
    Since the January 2026 LUMI system update, after loading the corresponding
    `gcc-native` module, the compilers are again available using the regular `gcc`, etc., 
    commands. However, the manual pages are not, so if you need the manual page for, e.g.,
    `gcc` in `gcc-native/14.2`, you need to use the `man gcc-14` command. If not, you'll 
    get the manual page for `gcc` version 7.5.

    The `gcc-native` module version can also be a bit misleading. They point to the version
    of the GNU compilers that was offered when that version of the programming environment
    was released. However, after an OS update, the compiler may also have been updated to
    a different minor version of the compiler. This was the case after the January 2026
    update for the `gcc-native/13.2` module. Before the system update, when using SUSE 15SP5,
    that module offered the GNU compilers version 13.2 as expected, but after the update, when
    using SUSE 15SP6, version 13.3 of the compilers was used, though the name of the module did
    not change to maintain compatibility.


## OpenMP Support

OpenMP is turned off by default. You can turn it on using the `-fopenmp` flag.
Only host-side OpenMP is supported. OpenMP offload is not supported.


## Optimization options

:material-help-circle-outline: `man gcc-14` - `man gfortran-14`, etc.

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
optimization, so consider using the `-O0` level. The `-g` options comes
with a penalty of larger binary size and slower execution, hence it is
recommended using it only for debugging purposes.

- [GCC documentation about debug options][gcc-debug]
