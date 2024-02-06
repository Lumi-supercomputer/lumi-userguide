# Cray compilers

[1]: #choose-the-cce-version
[2]: #cce-fortran-compiler

[wrappers]: ../../development/compiling/prgenv.md#compiler-wrappers

[The Cray Compiling Environment (CCE)](https://cpe.ext.hpe.com/docs/#hpe-cray-compiling-environment) provides the Cray Fortran and Cray C/C++
compilers. The Cray Fortran compiler supports the Fortran 2018 standard while
the C/C++ compiler is C17 and C++17 compliant. Invoking these compilers is done
through the `ftn`, `cc` and `CC` [compilers wrappers][wrappers].

CCE has support for the full OpenMP 4.5 specification as well as partial
support for OpenMP 5.0. PGAS languages (UPC and Fortran coarrays) are also
integrated.

## Overview

| Feature                       | Fortran                   | C/C++           |
|-------------------------------|---------------------------|-----------------|
| HIP compilation               | Not available             | -xhip           |
| Listing                       | -hlist=m                  | -fsave-loopmark |
| Free format                   | -ffree                    | N/A             |
| Vectorization                 | -O1 and above             | -O2 and above   |
| Link Time Optimization        | -hwp                      | -flto           |
| Floating-point optimizations  | -hfpN, N=0...4            | -ffp=N, N=0...4 |
| Suggested Optimization        | default                   | -O3             |
| Aggressive Optimization       | -O3 -hfp3                 | -Ofast -ffp=3   |
| OpenMP recognition            | -fopenmp                  | -fopenmp        |
| OpenACC recognition           | -hacc                     | Not available   |
| Variable sizes                | -s real64<br>-s integer64 | N/A             |
| Debug                         | -g                        | -g              |

## Choose the CCE version

The Cray Compiling Environment is available from the `PrgEnv-cray` module which
is loaded by default. This module loads the default version of the compilers. If
you wish to use an older or newer version, you can list the available version
with

```bash
$ module avail cce
```

and then switch to the desired version using

```bash
$ module swap cce cce/<version>
```

## OpenMP Support

:material-help-circle-outline: `man intro_openmp`

OpenMP **is turned off by default** which is the opposite of how earlier versions the CCE compilers worked.
It is turned on using the `-homp` or `-fopenmp` flag.

The CCE Fortran compiler allows controlling the level of optimization of OpenMP
directives with the `-hthreadN` (`N = 0...3`). A value `N = 0` being off and `N
= 3` specifying the most aggressive optimization. **The default value is `N =
2`**.

## OpenACC Support

:material-help-circle-outline: `man intro_openacc`

OpenACC is supported only by the Cray Fortran compiler. **The C and C++ 
compilers have no support for OpenACC**. To enable OpenACC, use the `-hacc` 
flag.

## Debugging

To ease a debugging process, it is useful to generate an executable containing
debugging information. For this purpose, you can use the `-g` option.

Most of the time, the debug information works best at low levels of code
optimization, so consider using the `-O0` level. The `-g` options can be
specified on a per-file basis so that only a small part of your application
incurs the debugging penalty.

## Compiler feedback

The compilers can generate loopmarks which indicate the type of optimization
performed. This feature is enabled by the `-hlist=m` option for the Fortran
compiler, and the `-fsave-loopmark` in the case of the C/C++ compilers. For
example

=== "Fortran"
    ```bash
    $ ftn -fopenmp -hlist=m -o saxpy saxpy.f08
    ```

=== "C"
    ```bash
    $ cc -fopenmp -fsave-loopmark -Ofast -o saxpy saxpy.c
    ```

=== "C++"
    ```bash
    $ CC -fopenmp -fsave-loopmark -Ofast -o saxpy saxpy.cpp
    ```

will produce a file called `saxpy.lst` where you can find a listing of your code
with annotations indicating which optimizations were performed by the compiler.

=== "Fortran"

    ```text
        1.                   subroutine saxpy(n, a, x, y) 
        2.                     real :: x(n), y(n), a
        3.                     integer :: n, i
        4.                   
        5.    M----------<     !$omp parallel do
        6.    M mVr2-----<     do i=1,n
        7.    M mVr2             y(i) = a*x(i)+y(i)
        8.    M mVr2----->     enddo
        9.    M---------->     !$omp end parallel do
      10.                   end subroutine saxpy
    ```

    The signification of the annotations can be found at the beginning of the 
    listing file. In our example, we can see for example that the compiler did 
    vectorized (`V`) and unrolled our loop (`r`).

=== "C/C++"

    ```text
    3.            void saxpy(int n, float a, 
    4.                float * restrict x, 
    5.                float * restrict y) {
    6. + I Vu--<>   #pragma omp parallel for
    7. +   M----<   for(int i = 0; i < n; i++) {
    8. +   M          y[i] = a*x[i] + y[i];
    9.     M---->   }
    10.            }
    ```

    The signification of the annotations can be found at the beginning of the 
    listing file. In our example, we can see for example that the compiler did
    vectorized (`V`) and unrolled our loop (`u`).

## Compiler Messages

:material-help-circle-outline: `man explain`

Use the explain command to display an explanation of any message issued by the
compiler. This message will be identified with a code looking like
`ftn-<number>`. You can pass this identifier as an argument to the `explain`
command to find out more about the error.

```bash
$ ftn -fopenmp -o saxpy saxpy.f08
    call saxpy(2**20, 2.0, x, y)
    ^                            
ftn-954 crayftn: ERROR MAIN, File = saxpy.f08, Line = 18, Column = 5 
  Procedure "SAXPY", defined at line 1 (saxpy.f08) must have an explicit
  interface because one or more arguments have the assumed-shape 
  DIMENSION attribute.

$ explain ftn-954
<explain output>
```

## CCE Fortran Compiler

:material-help-circle-outline: `man crayftn`

Once the `PrgEnv-cray` module is loaded (by default) you can invoke the Cray
Fortran compiler with the `ftn` command.

### Optimization options

The default optimization level of the CCE Fortran compiler is `-O2`. Aggressive
optimization can be enabled with the `-O3` option.

#### Vectorization

The level of automatic vectorizing is controlled with the `-hvectorN` option
(`N = 0...3`).

- the default value is `N = 2` enabling moderate vectorization and loop nests
  restructuring
- setting `N = 0` or `N = 1` enable minimal and moderate automatic vectorization
  respectively
- aggressive optimization is enabled by setting `N = 3`

#### Loop unrolling

Loop unrolling can be controlled with the `-hunrollN` flag with `N = 0...2`.

- the default value is `N = 2` for which the compiler will attempt to unroll
  all loops, except those marked with the `NOUNROLL` directive.
- setting `N = 0` requests that no loop unrolling is performed (also ignore the
  `UNROLL` directives).
- if you only want to unroll loops that are marked by the `UNROLL` directive use
  `N = 1`.

#### Floating point optimizations

The Cray compiler is aggressive by default in the floating-point optimization.
If your application is sensitive to the floating-point optimization, use the
`-hfpN` flag with `N = 0...4` to set the level of optimization.

- the default value is `N = 2` which performs various generally safe,
  nonconforming IEEE optimizations
- most applications can benefit from more aggressive optimization with `N = 3`
- use the value of `N = 0` or `N = 1` if the application you are compiling
  requires strong IEEE standard conformance

## CCE C and C++ compilers

:material-help-circle-outline: `man craycc` - `man crayCC` - `clang --help`

One the `PrgEnv-cray` module is loaded (by default) you can invoke the Cray C
compiler with the `cc` command. The C++ compiler may be invoked with the `CC`
command. These compilers are based on Clang/LLVM with Cray improvements. The
Cray improvements can be turned off with the `-fno-cray` flag.

Clang does not apply optimizations unless they are requested. Most optimizations
are enabled using the `-O2` level. Recommended flags are

- `-Ofast` to enable all the optimizations including aggressive optimizations
   that may violate strict compliance with language standards
- `-flto` to enable aggressive link time optimizations

For applications that are sensitive to floating−point optimizations, it may be
recommended to use `-O3` instead of `-Ofast`. These floating−point optimizations
can also be controlled with the `−ffp=N` flag with `N = 0...4`.

- using `−ffp=0`, will generate code with the highest precision and grants the
  compiler minimal freedom to optimize floating−point operations. Using
  `-ffp=0` will prevent the use of Cray math libraries.
- requesting the highest level (`−ffp=4`) will grant the compiler maximal
  freedom to aggressively optimize but likely will result in lower precision
