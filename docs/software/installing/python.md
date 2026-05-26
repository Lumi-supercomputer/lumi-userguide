[conda]: https://docs.conda.io/en/latest/
[conda-env]: https://conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html#sharing-an-environment
[pip]: https://pip.pypa.io/en/latest/
[pip-virt-env]: https://packaging.python.org/en/latest/tutorials/installing-packages/#creating-virtual-environments
[python]: https://www.python.org/
[scientific-python]: https://scientific-python.org/

[cotainr]: ../containers/singularity.md#building-containers-using-the-cotainr-tool
[csc-software-stack]: ../local/csc.md
[libsci]: ../../development/libraries/cray-libraries.md#libsci
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

As part of the [LUMI software stack][lumi-software-stack], we provide the
`cray-python` module which contains some basic Scientific Python packages like
NumPy and SciPy (built against [Cray LibSci][libsci]), mpi4py (built against Cray MPICH),
Pandas, and Dask. If what you need is such a basic Cray optimized Scientific
Python environment and, possibly, a few extra packages, you may load the
`cray-python` module and install the few extra packages on the file systems in
a [pip virtual environment][pip-virt-env].

!!! warning "Please don't install Python packages directly"
    To to provide the best user experience, it is **strongly discouraged**
    to install Python packages directly to the user home folder,
    `/scratch`, `/project`, etc. using [Conda][conda], [pip][pip], or similar
    package management tools. Please read this page carefully for better
    alternatives.

A Python installation usually consists of the Python interpreter, the Python
standard library and one or more third party Python packages. Such Python
packages may include both compiled code and a lot of so-called Python modules,
i.e. a lot of small files containing Python code. A sophisticated 
installation environment tends to contain tens to hundreds of thousands of
relatively small files.

Installing such a large number of small files to the user home folder or shared
locations like `/scratch`, `/project`, or even `/flash`, and trying to load
them from multiple processes at the same time, puts a lot of strain on the
[Lustre file system][lustre] serving these storage locations. Lustre simply
isn't designed for such use cases. Thus, to maintain good file system
performance for all users (it is a shared file system), care must be taken when
installing Python packages on LUMI.

## Recommended installation methods

The best way to get your Python environment installed on LUMI depends on the use
case. Below, we provide an overview of recommended ways to get access to Python
installations on LUMI.

!!! warning "The default Python is the OS Python"
    When you log into LUMI, running `python3` without loading a module or using
    a container will result in using the operating system Python installation.
    This is quite an old Python installation (version 3.6) without any Scientific
    Python packages, which is likely not what you want.

In general, we recommend using [Singularity/Apptainer
containers][singularity-containers] for managing Python installations. Using a container solves the "many
small files" performance problem and makes it easy to manage multiple different
Python environments at the same time. To use a container, you may either [use an existing
container](#use-an-existing-container), extend it further or [build a container tailored to your
needs](#use-a-container-you-build-specifically-tailored-to-your-needs). Another option is using
wrappers that [encapsule your environment](#wrap-up-your-environment-in-a-container) into a container.

### Use an existing container

We provide a number of custom built containers for LUMI. These containers are a flat sif
images share on a filesystem. You can use them as they are or extend further.

If somebody is already publishing a container which includes the Python
packages you need, you may [pull and use that container][pull-container]. 
Please note that containers are not always fully portable and there is a 
chance given image won't run on LUMI.

### Use an existing container with a pip virtual environment

If you have an existing container but need a few extra packages, you may
install such packages on the file systems in [pip virtual
environment][pip-virt-env] and use them with the container. 

### Wrap up your environment in a container

If you are used to managing [Conda][conda]/[pip][pip] environments locally, you may 
use [Cotainr][cotainr] or [LUMI container wrapper][tykky] to wrap your environment 
in a container for use on LUMI.

See [this GitHub issue](https://github.com/DeiC-HPC/cotainr/issues/37) for a more 
detailed discussion of when this approach may be preferred over using a container
directly.

### Extend an existing container

### Build your own image

If you are not able to find an existing container that suits your needs, you
may [build your own][singularity-build]. 

## Other installation methods 

For certain use cases, there may be better and/or easier alternatives to using
a container:

- If you only need **very few** (less than 5, including dependencies) extra
Python packages, you may use the pre-installed
`cray-python` module or [install a pip environment for use
with a container](#use-an-existing-container-with-a-pip-virtual-environment).

- If you are used to the managed software stacks on the CSC HPC systems, you may
prefer to [use pre-installed Python packages in the CSC software
stack][csc-software-stack] or other local software collections. Please note that 
these software stacks are only supported by others, not the LUMI User Support Team (LUST).

## Discouraged installation methods

**We strongly discourage installing large collections of Python packages
directly on the file systems on LUMI, i.e.**

- **Don't install conda/pip environments directly on the file systems**.
- **Don't install pip virtual environments directly on the file systems using
  the OS python**.
- **Don't install Python packages directly on the file systems using
  Easybuild**.
- **Don't install Python packages directly on the file systems using Spack**.
