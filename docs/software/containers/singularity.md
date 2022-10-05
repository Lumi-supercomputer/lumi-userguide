# Singularity/Apptainer containers

[singularityce]: https://docs.sylabs.io/guides/latest/user-guide/
[apptainer]: http://apptainer.org/docs/user/main/index.html
[dockerhub]: https://hub.docker.com/
[infinity-hub]: https://www.amd.com/en/technologies/infinity-hub
[mpich-abi]: https://www.mpich.org/abi/
[osu-benchmark]: https://mvapich.cse.ohio-state.edu/benchmarks/
[docker-wiki]: https://en.wikipedia.org/wiki/Docker_(software)
[container-jobs]: ../../runjobs/scheduled-jobs/container-jobs.md
[easybuild]: ../../software/installing/easybuild.md
[spack]: ../../software/installing/spack.md
[copying-files]: ../../firststeps/movingdata.md

We support [Singularity][singularityce]/[Apptainer][apptainer] containers as an
alternative way to bring your scientific application to LUMI instead of
installing it using [EasyBuild][easybuild] or [Spack][spack].

If you are familiar with [Docker containers][docker-wiki],
Singularity/Apptainer containers are essentially the same thing, but are better
suited for multi-user HPC systems such as LUMI. The main benefit of using a
container is that it provides an isolated software environment for each
application, which makes it easier to install complex applications.

This page provides guidance on preparing your Singularity/Apptainer containers
for use with LUMI. Please consult the [container jobs page][container-jobs] for
guidance on running your container on LUMI.

!!! note
    There are two major providers of the `singularity` runtime, namely
    [Singularity CE][singularityce] and [Apptainer][apptainer], with the latter
    being a fork of the former. For most cases these should be fully compatible.

## Building containers for LUMI

Building containers on LUMI is, unfortunately, not an option; The `singularity
build` command requires some level of root privileges, e.g. `sudo` or
`fakeroot`, which are disabled on LUMI for security reasons. Thus, in order to
prepare a Singularity/Apptainer container for LUMI, you have two options:

1. Pull an existing container image (Singularity or Docker) from a registry.
2. Build your own container on your local hardware, e.g. your laptop.

### Pulling container images from a registry

Singularity allows pulling images (Singularity or Docker) from container
registries such as [DockerHub][dockerhub] or [AMD Infinity Hub][infinity-hub].
Pulling container images from registries can be done on LUMI. For instance, the
Ubuntu image `ubuntu:22.04` can be pulled from DockerHub with the following
command:

```bash
$ singularity pull docker://ubuntu:22.04
```

This will create the Singularity image file `ubuntu_22.04.sif` in the directory
where the command was run. Once the image has been pulled, the container can be
run. Instructions for running the container may be found on the [container jobs
page][container-jobs].

!!! warning Take care when pulling container images
    Please take care to only use images uploaded from reputable sources as
    these images can easily be a source of security vulnerabilities or even
    contain malicious code.

!!! note
    The compute nodes are currently not connected to the internet. As a
    consequence, the container images need to be pulled in on the login nodes
    ([or transferred to LUMI][copying-files]).

!!! hint
    When pulling docker containers using singularity, the conversion can be
    quite heavy. Speed up the conversion and avoid leaving behind temporary
    files by using the in-memory filesystem on `/tmp` as the Singularity cache
    directory, i.e.

    ```bash
    $ mkdir -p /tmp/$USER
    $ export SINGULARITY_TMPDIR=/tmp/$USER
    $ export SINGULARITY_CACHEDIR=/tmp/$USER
    ```

### Building LUMI MPI compatible containers

Here we provide an example of building a container that is compatible with the
MPI stack on LUMI.

!!! warning
    For MPI-enabled containers, the application inside the container must be
    dynamically linked to an MPI version that is [ABI-compatible][mpich-abi]
    with the host MPI.

The following Singularity definition file `mpi_osu.def`, installs MPICH-3.1.4,
which is ABI-compatible with the Cray-MPICH found on LUMI. That MPICH will be
used to compile the [OSU microbenchmarks][osu-benchmark]. Finally, the OSU
point to point bandwidth test is set as the runscript of the image.

```bash
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

The image can be built **on your local hardware (not LUMI)** with

```bash
$ sudo singularity build mpi_osu.sif mpi_osu.def
```

The `mpi_osu.sif` file must then be [transferred to LUMI][copying-files]. See
the [container jobs MPI documentation
page](../../runjobs/scheduled-jobs/container-jobs.md#running-containerized-mpi-applications)
for instructions on running this MPI container on LUMI.
