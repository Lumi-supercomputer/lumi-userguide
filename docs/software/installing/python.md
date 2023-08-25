[conda]: https://docs.conda.io/en/latest/
[conda-env]: https://conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html#sharing-an-environment
[pip]: https://pip.pypa.io/en/latest/
[pip-virt-env]: https://packaging.python.org/en/latest/tutorials/installing-packages/#creating-virtual-environments
[python]: https://www.python.org/
[scientific-python]: https://scientific-python.org/

[container-virt-env-example]: ../../software/packages/pytorch.md#installing-other-packages-along-the-containers-pytorch-installation
[cotainr]: ../containers/singularity.md#building-containers-using-cotainr
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
gained a lot of popularity in the data science and HPC communities. We do
support using Scientific Python packages on LUMI, however care must be taken to
*install* such packages in a way that *plays well with LUMI*.

!!! warning "Please don't install Python packages directly"
    In order to provide the best user experience, it is **strongly
    discouraged** to install Python packages directly to the user home folder,
    `/scratch`, `/project`, etc. using [Conda][conda], [pip][pip], or similar
    package management tools. Please read this page carefully for better
    alternatives.

A Python installation usually consists of the Python interpreter, the Python
standard library and one or more third party Python packages. Such Python
packages may include both compiled code and a lot of so-called Python modules,
i.e. of a lot of small files containing Python code, e.g. a typical
[Conda][conda] environment tends to contain tens to hundreds of thousands of
relatively small files.

Installing such a large number of small files to the user home folder or shared
locations like `/scratch`, `/project`, or even `/flash`, and trying to load
them from multiple processes at the same time, puts a lot of strain on the
[Lustre file system][lustre] serving these storage locations. Lustre simple
isn't designed for such use cases. Thus, in order to maintain good file system
performance for all users (it is a shared file system), care must be taken when
installing Python packages on LUMI.

## Which installation method should I use?

The best way to get access to a Python installation on LUMI depends on the use
case. Below we provide an overview of recommended ways to get access to Python
installations on LUMI.

!!! warning "The default Python is the OS Python"
    When you log into LUMI, running `python3` without loading a module or using
    a container will result in using the operating system Python installation.
    This is a Python installation without any Scientific Python packages - which
    is likely not what you want.

### Generally recommended

In general, we recommend using [Singularity/Apptainer
containers][singularity-containers] for managing Python installations instead
of installing directly to the file systems. Using a container solves the "many
small files" performance problem and makes it easy to manage multiple different
Python environments at the same time. Your options are:

- **Use an existing container**: If somebody is already publishing a container
  which includes the Python pacakages you need, e.g. this [PyTorch ROCm
  container](https://hub.docker.com/r/rocm/pytorch), you may [pull and use that
  container][pull-container].
- **Use a container you build specifically tailored to your needs**: If you are
  not able to find an existing container that suits your needs, you may [build
  your own][singularity-build]. If you are used to managing
  [Conda][conda]/[pip][pip] environments locally, you may use [cotainr] to
  build a container based on a [Conda environment][conda-env] file for use on
  LUMI.

### Conditionally recommended

For certain use cases, there may be better and/or easier alternatives to using
a container.

If you only need **very few** (less than 5, including dependencies) extra
Python packages, you may:

- **Use the cray-python module**: As part of the [LUMI software
  stack][lumi-software-stack], we provide the `cray-python` module which
  contains some basic Scientific Python packages like NumPy and SciPy (built
  against Cray LibSci), mpi4py (built against Cray MPICH), Pandas, and Dask. If
  what you need is such a basic Cray optimized Scientific Python environment
  and, possibly, a few extra packages, you may load the `cray-python` module
  and install the few extra packages on the file systems in a [pip virtual
  environment][pip-virt-env].
- **Use an existing container with a pip virtual environment**: If you have an
  existing container but need a few extra packages, you may install such
  packages on the file systems in [pip virtual environment][pip-virt-env] and
  use them with the container. [An example of this approach is given in the
  LUMI PyTorch guide][container-virt-env-example].

If your workflow relies on a fixed environment in which you run a single
binary/script and/or need intertwining with the host software environment, you
may:

- **Use the Tykky installation wrapper**: We provide the [Tykky installation
  wrapper][tykky] which may be used to solve the "many small files" performance
  problem by wrapping a [Conda][conda]/[pip][pip] installation. This is a
  convenient way to get access to a performant Python installation if you only
  run a single binary/script and/or need to intertwine with the host software
  environment without having to explicitly deal with containers. See [this
  GitHub issues](https://github.com/DeiC-HPC/cotainr/issues/37) for a more
  detailed discussion of when this approach may be preferred over using a
  container directly.

If you are used to managed software stacks on local HPC systems, and your local
organization provides a similar software stack on LUMI, you may prefer to use a
Python installation from such a local organization software stack:

- **Use the CSC software stack**: [CSC provides a software
  stack][csc-software-stack] on LUMI, similar to the software stacks provided
  on the Finish HPC systems, which contains some Python packages. Please note
  that this software stack is only supported by CSC, not the LUMI User Support
  Team (LUST).

### Not recommended

Finally, for the sake of completeness, you can technically also install Python
packages directly to the file systems using one of the methods listed below.
However, as already discussed previously on this page, **these methods are
strongly discouraged**.

- **Don't install conda/pip environments directly to the file systems**.
- **Don't install pip virtual environments directly to the file systems using
  the OS python**.
- **Don't install Python packages directly to the file systems using
  Easybuild**.
- **Don't install Python packages directly to the file systems using Spack**.
