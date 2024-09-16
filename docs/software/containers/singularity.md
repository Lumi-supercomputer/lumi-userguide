# Singularity/Apptainer

[apptainer]: http://apptainer.org/docs/user/main/index.html
[conda-env]: https://conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html#sharing-an-environment
[cotainr]: https://cotainr.readthedocs.io/en/stable/
[cotainr-conda-env]: https://cotainr.readthedocs.io/en/stable/user_guide/conda_env.html#conda-environments
[cotainr-lumi-examples]: https://github.com/DeiC-HPC/cotainr/tree/main/examples/LUMI
[cotainr-usecases]: https://cotainr.readthedocs.io/en/stable/user_guide/index.html#use-cases
[dockerhub]: https://hub.docker.com/
[docker-wiki]: https://en.wikipedia.org/wiki/Docker_(software)
[infinity-hub]: https://www.amd.com/en/technologies/infinity-hub
[mpich-abi]: https://www.mpich.org/abi/
[osu-benchmark]: https://mvapich.cse.ohio-state.edu/benchmarks/
[singularityce]: https://docs.sylabs.io/guides/latest/user-guide/
[singularity-def-file]: https://docs.sylabs.io/guides/latest/user-guide/definition_files.html
[tykky-cotainr-diff]: https://github.com/DeiC-HPC/cotainr/issues/37

[container-jobs]: ../../runjobs/scheduled-jobs/container-jobs.md
[container-wrapper]: ../installing/container-wrapper.md
[copying-files]: ../../firststeps/movingdata.md
[easybuild]: ../../software/installing/easybuild.md
[interconnect]: ../../hardware/network.md
[lumi-g]: ../../hardware/lumig.md
[lumi-software-stack]: ../../runjobs/lumi_env/softwarestacks.md
[python-packages]: ../installing/python.md
[spack]: ../../software/installing/spack.md

We support [Singularity][singularityce]/[Apptainer][apptainer] containers as an
alternative way to bring your scientific application to LUMI instead of
installing it using [EasyBuild][easybuild] or [Spack][spack].

If you are familiar with [Docker containers][docker-wiki],
Singularity/Apptainer containers are essentially the same thing, but are better
suited for multi-user HPC systems such as LUMI. The main benefit of using a
container is that it provides an isolated software environment for each
application, which makes it easier to install and manage complex applications.

This page provides guidance on preparing your Singularity/Apptainer containers
for use with LUMI. Please consult the [container jobs page][container-jobs] for
guidance on running your container on LUMI.

!!! note
    There are two major providers of the `singularity` runtime, namely
    [Singularity CE][singularityce] and [Apptainer][apptainer], with the latter
    being a fork of the former. For most cases, these should be fully compatible.
    LUMI provides a Singularity CE runtime.

## Pulling container images from a registry

Singularity allows pulling existing container images (Singularity or Docker)
from container registries such as [DockerHub][dockerhub] or [AMD Infinity
Hub][infinity-hub]. Pulling container images from registries can be done on
LUMI. For instance, the Ubuntu image `ubuntu:22.04` can be pulled from
DockerHub with the following command:

```bash
$ singularity pull docker://ubuntu:22.04
```

This will create the Singularity image file `ubuntu_22.04.sif` in the directory
where the command was run. Once the image has been pulled, the container can be
run. Instructions for running the container may be found on the [container jobs
page][container-jobs].

!!! warning "Take care when pulling container images"
    Please take care to only use images uploaded from reputable sources as
    these images can easily be a source of security vulnerabilities or even
    contain malicious code.

!!! hint "Set cache directories when using Docker containers"
    When pulling or building from Docker containers using `singularity`, the
    conversion can be quite heavy. Speed up the conversion and avoid leaving
    behind temporary files by using the in-memory filesystem on `/tmp` as the
    Singularity cache directory, i.e.

    ```bash
    $ mkdir -p /tmp/$USER
    $ export SINGULARITY_TMPDIR=/tmp/$USER
    $ export SINGULARITY_CACHEDIR=/tmp/$USER
    ```

## Building Apptainer/Singularity SIF containers

Building your own container on LUMI is, unfortunately, not in general possible.
The `singularity build` command, in general, requires some level of root
privileges, e.g. `sudo` or `fakeroot`, which are disabled on LUMI for security
reasons. Thus, to build your own Singularity/Apptainer container for
LUMI, you have two options:

1. Use the [cotainr](#building-containers-using-the-cotainr-tool) tool to build
   containers on LUMI (only for certain use cases).
2. [Build your own container](#building-containers-on-local-hardware) on your
   local hardware, e.g. your laptop.

### Building containers using the cotainr tool

[Cotainr][cotainr] is a tool that makes it easy to build Singularity/Apptainer
containers on LUMI for certain [use cases][cotainr-usecases]. It is **not** a
general purpose container building tool.

On LUMI, `cotainr` is available in the 
[Cray Programming Environment][lumi-software-stack] and may be loaded using

```bash
$ module load CrayEnv
$ module load cotainr
```

When building containers using `cotainr build`, you may either specify a base
image for the container yourself (using the `--base-image` option) or you may
use the `--system` option to use the recommended base images for LUMI. To list
the available systems, run

```bash
$ cotainr info
...

System info
-------------------------------------------------------------------------------
Available system configurations:
    - lumi-g
    - lumi-c
```

As an example, you may then use `cotainr build` to create a container for
[LUMI-G][lumi-g] containing a Conda/pip environment by running

```bash
$ cotainr build my_container.sif --system=lumi-g --conda-env=my_conda_env.yml
```

where `my_conda_env.yml` is a file containing an [exported Conda
environment][conda-env]. The resulting `my_container.sif` container may be run
like any other [container job][container-jobs] on LUMI. For example:

```bash
$ srun --partition=<partition> --account=<account> singularity exec my_container.sif python3 my_script.py
```

where `my_script.py` is your Python script.

The installed Conda environment is automatically activated when you run the
container. See the [cotainr Conda environment docs][cotainr-conda-env] and the
[cotainr LUMI examples][cotainr-lumi-examples] for more details.

!!! warning "Make sure your Conda environment supports the hardware in LUMI"
    To take advantage of e.g. the GPUs in [LUMI-G][lumi-g], the
    packages you specify in your Conda environment must be compatible with
    LUMI-G, i.e. built against ROCm. Similarly, to take full advantage
    of the [Slingshot 11 interconnect][interconnect] when running MPI jobs, you
    must make sure your packages are built against Cray MPICH. Cotainr does
    **not** do any magic conversion of the packages specified in the Conda
    environment to make sure they fit the hardware of LUMI. It simply installs
    the packages exactly as listed in the `my_conda_env.yml` file.

!!! note
    Using `cotainr` to build a container from a Conda/pip environment is
    different from wrapping a Conda/pip environment using the [LUMI container
    wrapper][container-wrapper]. Each serves their own purpose. See
    the [Python installation guide][python-packages] for an overview of
    differences and [this GitHub issue][tykky-cotainr-diff] for a detailed
    discussion of the differences.

See the [cotainr documentation][cotainr] for more details about `cotainr`.

### Building containers on local hardware

You may also build a Singularity/Apptainer container for LUMI on your local
hardware and [transfer it to LUMI][copying-files].

As an example, consider building a container that is compatible with the
MPI stack on LUMI.

!!! warning
    For MPI-enabled containers, the application inside the container must be
    dynamically linked to an MPI version that is [ABI-compatible][mpich-abi]
    with the host MPI.

The following [Singularity definition file][singularity-def-file]
`mpi_osu.def`, installs MPICH-3.1.4, which is ABI-compatible with the
Cray-MPICH found on LUMI. That MPICH will be used to compile the [OSU
micro-benchmarks][osu-benchmark]. Finally, the OSU point to point bandwidth test
is set as the "runscript" of the image.

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

The image can be built **on your local hardware (not on LUMI)** with

```bash
$ sudo singularity build mpi_osu.sif mpi_osu.def
```

The `mpi_osu.sif` file must then be [transferred to LUMI][copying-files]. See
the [container jobs MPI documentation
page](../../runjobs/scheduled-jobs/container-jobs.md#running-containerized-mpi-applications)
for instructions on running this MPI container on LUMI.
