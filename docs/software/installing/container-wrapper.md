[softwarestacks]: ../../runjobs/lumi_env/softwarestacks.md

# Tykky installation wrapper

The container wrapper is a set of tools which wrap software installations
inside a Apptainer/Singularity container to improve startup times, reduce I/O
load, and lessen the number of files on large parallel file systems.

Additionally, the container wrapper will generate wrappers so that installed
software can be used (almost) as if it were not containerized. Depending on
tool selection and settings, either the whole host file system or a limited
subset is visible during execution and installation. This means that it's
possible to wrap installations using e.g. mpi4py while still relying on the
host provided MPI installation.

This documentation covers a subset of the functionality and focuses on examples
of wrapping conda and Python installations.

!!! warning "The container wrapper is experimental software"
    As the container wrapper is still under development, some of the more
    advanced features might change in exact usage and API.

## Basic conda installation

The tools provided by the container wrapper are accessible by loading the
`lumi-container-wrapper` module that is available in the `LUMI` and `CrayEnv`
[software stacks][softwarestacks].

```bash
module load LUMI/22.08 
module load lumi-container-wrapper
```

Then we can run the `conda-containerize` tool

```bash
conda-containerize new --prefix <install_dir> env.yml
```

where **env.yml** is a conda environment file.

This file can be written manually, e.g:

```yaml
channels:
  - conda-forge
dependencies:
  - python=3.8.8
  - scipy
  - nglview
```

or generated from an existing environment

```bash
conda env export -n <target_env_name> > env.yaml 
```
*Windows and MacOS will need to add the `--from-history` flag to the export command*

or, alternatively,
```bash
conda list -n <target_env_name> --explicit > env.txt
```

*Using the `--explicit` option only works if the existing environment is on a
Linux machine with x86 CPU architecture. Otherwise the result will not be
transferable to LUMI.*

After the installation is done, you simply need to add the bin directory
`<install_dir>/bin` to your `PATH`.

```bash
export PATH="<install_dir>/bin:$PATH"
```

Then, you can call `python` and any other executables, conda has installed, in
the same way as if you would have activated the environment.

If you also need to install some additional pip packages, you can do so by
supplying the `-r <req_file>` argument e.g:

```bash
conda-containerize new -r req.txt --prefix <install_dir> env.yml
```

where `req.txt` is a [standard pip requirements file](https://pip.pypa.io/en/latest/reference/requirements-file-format/).

The tool also supports using [mamba](https://github.com/mamba-org/mamba) for
installing packages. Enable this feature by adding the `--mamba` flag, e.g.
`conda-containerize new --mamba ...`

Make sure that you have read and understood the license terms for miniconda as
well as any used conda channels before using the command.

- [End-user license](https://www.anaconda.com/end-user-license-agreement-miniconda)
- [Terms of service](https://www.anaconda.com/terms-of-service)
- [Anaconda FAQ](https://www.anaconda.com/blog/anaconda-commercial-edition-faq)

### End-to-end example of a conda install

Using the previous `env.yml`

```bash
mkdir MyEnv
conda-containerize new --prefix MyEnv env.yml 
```

After the installation finishes, we can add the installation directory to our
`PATH` and use it like normal.

```bash
 $ export PATH="$PWD/MyEnv/bin:$PATH"
 $ python --version
3.8.8
 $ python3
Python 3.8.8 | packaged by conda-forge | (default, Feb 20 2021, 16:22:27) 
[GCC 9.3.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import scipy
>>> import nglview
>>> 
```

## Modifying a container wrapped conda installation

As the container wrapper installed software resides in a container, it cannot
be directly modified. Small python packages can be added outside the container,
in the usual way, using `pip`, but then the python packages are sitting on the
parallel file system which is not recommended for larger installations.

To actually modify the installation inside the wrapping container, we can use
the `update` keyword together with the `--post-install <file>` option which
specifies a bash script with commands to run to update the installation. The
commands are executed with the conda environment activated.

```bash
conda-containerize update <existing installation> --post-install <file> 
```

where `<file>` could e.g. contain

```bash
conda  install -y numpy
conda  remove -y pyyaml
pip install requests
```

In this mode the whole host system is available including all software and modules.

## Plain pip installations

Sometimes you don't need a full-blown conda environment or you may prefer to
manage your python installations using pip. For this case we can use the
container wrapper via

```bash
pip-containerize new --prefix <install_dir> req.txt
```

where `req.txt` is a standard pip requirements file. The above notes and
options for modifying a conda installation apply to pip installations as well.

Note that the python version used by `pip-containerize` is the first python
executable found on the `PATH`, so it's affected by loading modules.

!!! note
    This python used to installed pip packages cannot itself be container-based
    as nesting of containers is not possible.  

Additionally, you may use the `--slim` argument, which will use a pre-built
minimal python container with a much newer version of python as a base. Without
the `--slim` argument, the whole host system is available. However, by using
the `--slim` argument, the system installations (i.e /usr, /lib64 ...) are no
longer taken from the host, but are instead taken from the minimal python
container.

## Existing containers

The container wrapper also provides a tool to generate wrappers for existing
Apptainer/Singularity containers, so that they can be used transparently
without the need for prepending `singularity exec ...`, or modify scripts if
switching between containerized versions of tools.

```bash
wrap-container -w </path/inside/container> <container> --prefix <install_dir> 
```

where `<container>` can be a filepath or any URL accepted by singularity (e.g
`docker//:` `oras//:` or any other singularity accepted format), and `-w` needs
to be an absolute path (or comma-separated list) inside the container. Wrappers
will then be automatically created for the executables in the target
directories / for the target path.

## Additional example

- [Example in tool repository](https://github.com/CSCfi/hpc-container-wrapper/blob/master/examples/fftw.md)

## How it works

See the README in the source code repository. The source code can be found in
the [GitHub repository.](https://github.com/CSCfi/hpc-container-wrapper)
