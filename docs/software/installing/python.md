[conda]: https://docs.conda.io/en/latest/
[conda-env]: https://conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html#sharing-an-environment
[pip]: https://pip.pypa.io/en/latest/
[pip-virt-env]: https://packaging.python.org/en/latest/tutorials/installing-packages/#creating-virtual-environments
[python]: https://www.python.org/
[scientific-python]: https://scientific-python.org/

[container-virt-env-example]: ../../software/packages/pytorch.md#installing-other-packages-along-the-containers-pytorch-installation
[cotainr]: ../containers/singularity.md#building-containers-using-the-cotainr-tool
[csc-software-stack]: ../local/csc.md
[lumi-software-stack]: ../../runjobs/lumi_env/softwarestacks.md
[lustre]: ../../storage/parallel-filesystems/lustre.md
[pull-container]: ../containers/singularity.md#pulling-container-images-from-a-registry
[singularity-build]: ../containers/singularity.md#building-apptainersingularity-sif-containers
[singularity-containers]: ../containers/singularity.md
[tykky]: ./container-wrapper.md

# Installing Python packages

Over the past decade, the [Python programming language][python] and [Scientific
Python][scientific-python] packages like NumPy, SciPy, JAX, and PyTorch have
gained a lot of popularity in the data science and HPC communities.

We do support using Scientific Python packages on LUMI.
However, care must be taken to *install* such packages in a way that *plays well with LUMI*.

!!! warning "Please don't install Python packages directly"
    To to provide the best user experience, it is **strongly discouraged**
    to install Python packages directly to the user home folder,
    `/scratch`, `/project`, etc. using [Conda][conda], [pip][pip], or similar
    package management tools. Please read this page carefully for better
    alternatives.

A Python installation usually consists of the Python interpreter, the Python
standard library and one or more third party Python packages. Such Python
packages may include both compiled code and a lot of so-called Python modules,
i.e. a lot of small files containing Python code. A typical
[Conda][conda] environment tends to contain tens to hundreds of thousands of
relatively small files.

Installing such a large number of small files to the user home folder or shared
locations like `/scratch`, `/project`, or even `/flash`, and trying to load
them from multiple processes at the same time, puts a lot of strain on the
[Lustre file system][lustre] serving these storage locations. Lustre simply
isn't designed for such use cases. Thus, to maintain good file system
performance for all users (it is a shared file system), care must be taken when
installing Python packages on LUMI.

**Which installation method should I use then?**

The best way to get access to a Python installation on LUMI depends on the use
case. Below, we provide an overview of recommended ways to get access to Python
installations on LUMI.

!!! warning "The default Python is the OS Python"
    When you log into LUMI, running `python3` without loading a module or using
    a container will result in using the operating system Python installation.
    This is quite an old Python installation (version 3.6) without any Scientific
    Python packages, which is likely not what you want.

## Generally recommended installation methods

In general, we recommend using [Singularity/Apptainer
containers][singularity-containers] for managing Python installations. Using a container solves the "many
small files" performance problem and makes it easy to manage multiple different
Python environments at the same time. To use a container, you may either [use an existing
container](#use-an-existing-container) or [build a container tailored to your
needs](#use-a-container-you-build-specifically-tailored-to-your-needs).

### Use an existing container

If somebody is already publishing a container which includes the Python
packages you need, e.g. this [PyTorch ROCm
container](https://hub.docker.com/r/rocm/pytorch), you may [pull and use that
container][pull-container].

### Use a container you build specifically tailored to your needs

If you are not able to find an existing container that suits your needs, you
may [build your own][singularity-build]. If you are used to managing
[Conda][conda]/[pip][pip] environments locally, you may use [cotainr] to build
a container based on a [Conda environment][conda-env] file for use on LUMI.

## Installation methods recommended for specific use cases

For certain use cases, there may be better and/or easier alternatives to using
a container:

- If you only need **very few** (less than 5, including dependencies) extra
Python packages, you may [use the pre-installed
cray-python](#use-the-cray-python-module) or [install a pip environment for use
with a container](#use-an-existing-container-with-a-pip-virtual-environment).
- If your workflow relies on a fixed environment in which you run a single
binary/script and/or need intertwining with the host software environment, you
may [wrap it using the LUMI container wrapper](#use-the-lumi-container-wrapper).
- If you are used to the managed software stacks on the CSC HPC systems, you may
prefer to [use pre-installed Python packages in the CSC software
stack](#use-the-csc-software-stack).

### Use the cray-python module

As part of the [LUMI software stack][lumi-software-stack], we provide the
`cray-python` module which contains some basic Scientific Python packages like
NumPy and SciPy (built against Cray LibSci), mpi4py (built against Cray MPICH),
Pandas, and Dask. If what you need is such a basic Cray optimized Scientific
Python environment and, possibly, a few extra packages, you may load the
`cray-python` module and install the few extra packages on the file systems in
a [pip virtual environment][pip-virt-env].

### Use an existing container with a pip virtual environment

If you have an existing container but need a few extra packages, you may
install such packages on the file systems in [pip virtual
environment][pip-virt-env] and use them with the container. [An example of this
approach is given in the LUMI PyTorch guide][container-virt-env-example].

### Use the LUMI container wrapper

We provide the [LUMI container wrapper][tykky] which may be used to solve
the "many small files" performance problem by wrapping a
[Conda][conda]/[pip][pip] installation. This is a convenient way to get access
to a performant Python installation if you only run a single binary/script
and/or need to intertwine with the host software environment without having to
explicitly deal with containers. See [this GitHub
issues](https://github.com/DeiC-HPC/cotainr/issues/37) for a more detailed
discussion of when this approach may be preferred over using a container
directly.

### Use the CSC software stack

[CSC provides a small additional software stack][csc-software-stack] on LUMI, similar to the
software stacks provided on the Finnish HPC systems, which contains some Python
packages. Please note that this software stack is only supported by CSC, not
the LUMI User Support Team (LUST).

## Discouraged installation methods

**We strongly discourage installing large collections of Python packages
directly on the file systems on LUMI, i.e.**

- **Don't install conda/pip environments directly on the file systems**.
- **Don't install pip virtual environments directly on the file systems using
  the OS python**.
- **Don't install Python packages directly on the file systems using
  Easybuild**.
- **Don't install Python packages directly on the file systems using Spack**.
