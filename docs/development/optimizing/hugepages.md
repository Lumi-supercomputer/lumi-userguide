# Using hugepages

Memory is managed in blocks known as pages. The default size of a page is 4KB.
CPUs have a built-in memory management unit that manages a list of these pages
in hardware. The Translation Lookaside Buffer (TLB) is a small hardware cache
of virtual-to-physical page mappings. If the virtual address passed in a
hardware instruction can be found in the TLB, the mapping can be determined
quickly. If not, a TLB miss occurs, and the system falls back to slower,
software-based address translation, resulting in performance issues.

## Reasons to use hugepages

Since the size of the TLB is fixed in the hardware, a way to reduce the chance
of a TLB miss is to increase the page size. Using very large page sizes can
improve system performance by reducing the amount of system resources required
to access page table entries by reducing the number of virtual to physical
address translations.

Hugepages can be beneficial

- for MPI applications, map the static data and/or heap onto huge pages
- for applications using shared memory that are concurrently registered with
  high-speed network drivers for remote communication
- to improve memory performance for common access patterns on large data sets
- for applications doing heavy I/O
- for SHMEM applications, map the static data and/or private heap onto huge
  pages
- for applications written in Unified Parallel C and other languages based on
  the PGAS programming model, to map the static data and/or private heap onto
  huge pages

## How to use hugepages

To use hugepages load the module corresponding to the page size you wish to
use. For example, to use a page size of 2 megabytes:

```bash
$ module load craype-hugepages2M
```

For x86 processors, which is the architecture of the LUMI CPUs, the supported
page sizes are 4KB, 2MB and 1GB. Once the module is loaded, you can compile
your application as usual using the compiler wrappers.

=== "C"

    ```bash
    cc -o myprogram source.c
    ```

=== "C++"

    ```bash
    CC -o myprogram source.cpp
    ```

=== "Fortran"

    ```bash
    ftn -o myprogram source.f90
    ```

The `hugepages` module should also be loaded in your job script when running
your application.

```bash
#!/bin/bash
#SBATCH ...

module load craype-hugepages2M

srun ./myprogram
```

If you execute multiple applications in your job, but only some of them can
benefit from using hugepages, export the `HUGETLB_RESTRICT_EXE` environment
variable in your job script to limit the usage of hugepages only to certain
applications.

```bash
export HUGETLB_RESTRICT_EXE=myprogram1:myprogram2
```
