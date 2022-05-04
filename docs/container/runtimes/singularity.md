## Singularity

[software_installing]: ../../software/installing/easybuild.md

This section of the documentations               
describes briefly how to use singularity on LUMI 


Singularity is available on LUMI-C as the executable `singularity`. No modules need to be loaded.

## Background

If you are familiar with [Docker containers](https://en.wikipedia.org/wiki/Docker_(software)), [Singularity containers](https://apptainer.org/) are essentially the same thing, but are better suited for multi-user systems such as the LUMI supercomputer. Containers provide an isolated software environment for each application, which makes it easier to install complex applications. On shared file systems, launch times can also be much shorter for containers compared to alternatives such as conda.

You can [read more about Singularity in the official user guide](https://apptainer.org/docs/user/main/index.html).

!!! info
    The singularity project is in the process of being renamed to apptainer, so you might se both
    terms being used depending on the material you are reading


To use singularity containers on LUMI you can:

- [Download and existing container](#pulling-container-images-from-a-registry)
- Use a container provided by the computing environment
- Build your own container


## Pulling container images from a registry

Singularity allows pulling images from container registries such as DockerHub or AMD Infinity Hub. For instance, the Ubuntu image `ubuntu:21.04` can be pulled from DockerHub with the following command:
```bash
singularity pull docker://ubuntu:latest
```
This will create the Singularity image file `ubuntu_21.04.sif` in the directory where the command was run.

!!! The compute nodes of LUMI-C are not connected to the internet. As a consequence, the images need to be pulled in on the login nodes (or transferred to LUMI with other means such as `scp`).  **Please take care to only use images uploaded from reputable sources** as these images can easily be a source of security vulnerabilities or even contain malicious code.


!!! hint
    When pulling docker containers using singularity the conversion can be quite heavy.
    Speed up the conversion and avoid leaving behind temporary files by moving the temporary
    to `/tmp`
    
    ```
    mkdir -p /tmp/$USER
    export SINGULARITY_TMPDIR=/tmp/$USER
    export SINGULARITY_CACHEDIR=/tmp/$USER
    ```


## Running a container

Once the image has been pulled, the container can be run. For instance, here we check the version of Ubuntu running in the container
```bash
srun -p<partition> -A<account> singularity exec ubuntu_21.04.sif cat /etc/os-release
```
This prints
```
NAME="Ubuntu"
VERSION="21.04 (Hirsute Hippo)"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 21.04"
VERSION_ID="21.04"
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
VERSION_CODENAME=hirsute
UBUNTU_CODENAME=hirsute
```

By default, some file system partitions, such as `/scratch`,`/projappl` are not accessible from the container.
To make them available, they need to be explicitely bound by passing
the `-B/--bind` command line option to `singularity exec/run`. For instance
```
srun -p<partition> -A<account> singularity exec -B /scratch/<account> ubuntu_21.04.sif ls /scratch/<account>
```

## Running an MPI application within the container
Containerized MPI applications can be run with Singularity. However, in order to properly make use of LUMI's high speed network, it is necessary to mount a few host system directories inside the container and set `LD_LIBRARY_PATH` so that the necessary dynamic libraries are available at run time. Doing that, the MPI installed in the container image is replaced by the one of the host.

We have put together all the necessary setup in a module that can be installed by the user with EasyBuild:
```bash
module load LUMI partition/<lumi-partition> EasyBuild-user
eb singularity-bindings-system-cpeGNU-<toolchain-version>.eb -r
```
That will create the module `singularity-bindings/system-cpeGNU-<toolchain-version>`.
More information on installing software with EasyBuild can be found [here][software_installing].

!!! For MPI-enabled containers, the application inside the container must be dynamically linked to an MPI version that is [ABI-compatible](https://www.mpich.org/abi/) with the host MPI.

Let's consider an example to show how to use the `singularity-bindings` to run a containerized MPI application.
The following Singularity definition file `mpi_osu.def`, installs MPICH-3.1.4, which is ABI-compatible with the Cray-MPICH found on LUMI. Then the that MPICH is used later to compile the [OSU microbenchmarks](https://mvapich.cse.ohio-state.edu/benchmarks/). Finally, the OSU point to point bandwidth test is set as the runscript of the image.
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
The image can be built outside of LUMI with 
```bash
sudo singularity build mpi_osu.sif mpi_osu.def
```
The OSU point to point bandwidth test can be run with
```bash
module load singularity-bindings`
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

## Running an MPI application with the container's MPI installation
MPI applications can be run without replacing the container's MPI. To do so, Slurm needs to be instructed to use the PMI-2 process management interface by passing `--mpi=pmi2` to `srun`
```bash
srun -p<partition> -A<account> --mpi=pmi2 -N2 singularity run mpi_osu.sif
```
This gives
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
Like in this example, the performance obtained doing this might be quite low compared to the results obtained when using the host's MPI.

## Example: Running Julia within a container

Generic application containers can be easily run on the compute nodes. Here we use [Julia](http://julialang.org/) container, `julia` in the DockerHub, as an example of interactive run and batch submission. Julia can execute as both multithreaded and parallel application. It can be pulled with the command:
```bash
singularity pull docker://julia
```
Singularity file `julia_latest.sif` will be created. Julia can be executed interactively on a single LUMI-C node with N threads allocating N cpu cores:
```bash
srun --pty --nodes=1 --ntasks-per-node=1 --cpus-per-task=<N> --time=30 -p<partition> -A<account> singularity run --env JULIA_NUM_THREADS=<N> julia_latest.sif
```

Running with parallel (multiprocess) execution model requires specific Julia code, say in `my_parallel_script.jl` file. It can be executed with a batch submission on a single node with N parallel processes:
```bash
srun --nodes=1 --ntasks-per-node=<N> --cpus-per-task=1 --time=30 -p<partition> -A<account> singularity exec julia_latest.sif julia -p 20 my_parallel_script.jl
```
Both multithreading and multiprocessing can be combined with `--ntasks-per-node` (for a number o processes) and `--cpus-per-task` (for a number of threads) SLURM options.

Multinode, distributed execution would require custom "ClusterManager" plugin for integration with SLURM which will require specific version of the container. The same applies to GPU enabled execution on the LUMI-G compute nodes.
