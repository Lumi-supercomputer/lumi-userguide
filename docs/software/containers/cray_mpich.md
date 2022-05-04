# Containerized MPI applications

[software_installing]: ../../software/installing/easybuild.md
[mpich-abi]: https://www.mpich.org/abi/
[permedcoe-mpi]: https://permedcoe.github.io/mpi-in-container
[osu-benchmark]: https://mvapich.cse.ohio-state.edu/benchmarks/

## Using the host MPI

### Binding to the host

Containerized MPI applications can be run with Singularity. However, in order to
properly make use of LUMI's high-speed network, it is necessary to mount a few
host system directories inside the container and set `LD_LIBRARY_PATH` so that
the necessary dynamic libraries are available at run time. Doing that, the MPI
installed in the container image is replaced by the host's.

We have put together all the necessary setup in a module that can be installed
by the user with EasyBuild:

```bash
module load LUMI partition/<lumi-partition> EasyBuild-user
eb singularity-bindings-system-cpeGNU-<toolchain-version>.eb -r
```

That will create the module `singularity-bindings/system-cpeGNU-<toolchain-version>`.
More information on installing software with EasyBuild can be found
[here][software_installing].

### Create a container compatible with LUMI

Let's consider a simple example to see how to use the `singularity-bindings` to
run a containerized MPI application. 

!!! warning
    For MPI-enabled containers, the application inside the container must be
    dynamically linked to an MPI version that is [ABI-compatible][mpich-abi]
    with the host MPI.

First we are going to prepare an image. The
following Singularity definition file `mpi_osu.def`, installs MPICH-3.1.4, which
is ABI-compatible with the Cray-MPICH found on LUMI. That MPICH will be used to
compile the [OSU microbenchmarks][osu-benchmark]. Finally, the OSU point to
point bandwidth test is set as the runscript of the image.

```
bootstrap: docker
from: ubuntu:21.04

%post
    # Install software
    apt-get update
    apt-get install -y file g++ gcc gfortran make gdb strace wget ca-certificates --no-install-recommends

    # Install mpich
    wget -q http://www.mpich.org/static/downloads/3.1.4/mpich-3.1.4.tar.gz
    tar xf mpich-3.1.4.tar.gz
    cd mpich-3.1.4
    ./configure --disable-fortran --enable-fast=all,O3 --prefix=/usr
    make -j$(nproc)
    make install
    ldconfig

    # Build osu benchmarks
    wget -q http://mvapich.cse.ohio-state.edu/download/mvapich/osu-micro-benchmarks-5.3.2.tar.gz
    tar xf osu-micro-benchmarks-5.3.2.tar.gz
    cd osu-micro-benchmarks-5.3.2
    ./configure --prefix=/usr/local CC=$(which mpicc) CFLAGS=-O3
    make
    make install
    cd ..
    rm -rf osu-micro-benchmarks-5.3.2
    rm osu-micro-benchmarks-5.3.2.tar.gz

%runscript
    /usr/local/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_bw
```

The image can be built **outside of LUMI** with 

```bash
sudo singularity build mpi_osu.sif mpi_osu.def
```

The OSU point-to-point bandwidth test can be run with

```bash
module load singularity-bindings
srun -p<partition> -A<account> -N2 singularity run mpi_osu.sif
```

which gives the bandwidth measured for different message sizes

```
# OSU MPI Bandwidth Test v5.3.2
# Size      Bandwidth (MB/s)
1                       3.00
2                       6.01
4                      12.26
8                      24.53
16                     49.83
32                     97.97
64                    192.37
128                   379.80
256                   716.64
512                  1386.52
1024                 2615.18
2048                 4605.69
4096                 6897.21
8192                 9447.54
16384               10694.19
32768               11419.39
65536               11802.31
131072              11997.96
262144              12100.20
524288              12162.28
1048576             12207.27
2097152             12230.66
4194304             12242.46
```

## Using the container MPI

MPI applications can be run without replacing the container's MPI. To do so,
Slurm needs to be instructed to use the PMI-2 process management interface by
passing `--mpi=pmi2` to `srun`

```bash
srun --partition=<partition> --account=<account> \
     --mpi=pmi2 --nodes=2 singularity run mpi_osu.sif
```

This gives lower bandwidths, especially for the larger message sizes

```
# OSU MPI Bandwidth Test v5.3.2
# Size      Bandwidth (MB/s)
1                       0.50
2                       1.61
4                       3.57
8                       6.54
16                      9.65
32                     18.04
64                     35.27
128                    67.76
256                    91.12
512                   221.09
1024                  278.88
2048                  471.54
4096                  917.02
8192                 1160.74
16384                1223.41
32768                1397.97
65536                1452.23
131072               2373.07
262144               2104.56
524288               2316.71
1048576              2478.30
2097152              2481.68
4194304              2380.51
```

Like in this example, the performance obtained doing this might be quite low
compared to the results obtained when using the host's MPI.

For a higher-level overview, you can read a [tutorial on MPI in
containers][permedcoe-mpi].
