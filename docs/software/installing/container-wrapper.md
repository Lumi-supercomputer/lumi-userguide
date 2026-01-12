[conda]: https://docs.conda.io/en/latest/
[conda-env]: https://conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html#sharing-an-environment
[mamba]: https://github.com/mamba-org/mamba
[pip]: https://pip.pypa.io/en/latest/
[pip-req]: https://pip.pypa.io/en/latest/reference/requirements-file-format/
[tykky-github]: https://github.com/CSCfi/hpc-container-wrapper

[python-install]: ./python.md
[softwarestacks]: ../../runjobs/lumi_env/softwarestacks.md

# LUMI container wrapper

The [LUMI container wrapper][tykky-github] is a set of tools which wrap
software installations inside an Apptainer/Singularity container to improve
startup times, reduce I/O load, and lessen the number of files on large
parallel file systems.

Additionally, the LUMI container wrapper will generate wrappers so that
installed software can be used (almost) as if it was not containerized.
Depending on tool selection and settings, either the whole host file system or
a limited subset is visible during execution and installation. This means that
it is possible to wrap installations using e.g., mpi4py while still relying on
the host provided MPI installation.

The LUMI container wrapper is a general purpose installation wrapper that
supports wrapping:

- **Existing installations on the filesystem**: Mainly to reduce the I/O load
  and improve startup times, but may also be used to containerize existing
  installations that cannot be re-installed.
- **Existing Singularity/Apptainer containers**: Mainly to hide the need for
  using the container runtime from the user.
- **Conda installations**: Directly wrap a [Conda][conda] installation based on
  a [Conda environment file][conda-env].
- **Pip installations**: Directly wrap a [pip][pip] installation based on a
  [requirements.txt file][pip-req].

!!! warning "The LUMI container wrapper is NOT generally recommended for managing Conda/pip installations"
    For some use cases, the LUMI container wrapper is an excellent tool for
    managing Conda/pip installations. For other use cases, there are better
    alternatives. See the [installing Python packages][python-install] guide
    for an overview the recommended ways to manage Python installations,
    including Conda/pip installations.

!!! warning "The LUMI container wrapper has some limitations"
    Please be aware of the [limitations when using the LUMI container wrapper
    ](https://github.com/CSCfi/hpc-container-wrapper#limitations) before
    wrapping your installations.

!!! warning "The LUMI container wrapper is experimental software"
    As the LUMI container wrapper is still under development, some of the
    more advanced features might change in exact usage and API.

## Examples of using the LUMI container wrapper

The tools provided by the LUMI container wrapper are accessible by loading the
`lumi-container-wrapper` module that is available in the `LUMI` and `CrayEnv`
[software stacks][softwarestacks].

```bash
$ module load LUMI
$ module load lumi-container-wrapper
```

Once the module has been loaded, you can use one of the front-end tools
`conda-containerize`, `pip-containerize`, `wrap-container`, and `wrap-install`.

### Wrapping a basic Conda installation

To wrap a basic [Conda][conda] installation, create an installation directory
and run the `conda-containerize` tool

```bash
$ mkdir <install_dir>
$ conda-containerize new --prefix <install_dir> env.yml
```

where `env.yml` is a [Conda environment file][conda-env].

This file can be written manually, e.g.:

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
$ conda env export -n <target_env_name> > env.yaml 
```

*Windows and macOS will need to add the `--from-history` flag to the export command*

or, alternatively,

```bash
$ conda list -n <target_env_name> --explicit > env.txt
```

*Using the `--explicit` option only works if the existing environment is on a
Linux machine with x86 CPU architecture. Otherwise the result will not be
transferable to LUMI.*

After the installation is done, you need to add the bin directory
`<install_dir>/bin` to your `PATH`.

```bash
$ export PATH="<install_dir>/bin:$PATH"
```

Then, you can call `python` or any other executables, Conda has installed, in
the same way as if you had activated the environment.

If you also need to install some additional pip packages, you can do so by
supplying the `-r <req_file>` argument e.g.:

```bash
$ conda-containerize new -r req.txt --prefix <install_dir> env.yml
```

where `req.txt` is a [standard pip requirements.txt file][pip-req].

The tool also supports using [Mamba][mamba] for installing packages. Enable
this feature by adding the `--mamba` flag, e.g. `conda-containerize new --mamba
...`

Make sure that you have read and understood the license terms for
[Miniconda](https://docs.conda.io/en/latest/miniconda.html) as well as any used
conda channels before using the command:

- [Terms of service](https://www.anaconda.com/terms-of-service)
- [Anaconda FAQ](https://www.anaconda.com/blog/anaconda-commercial-edition-faq)

#### End-to-end example of wrapping a Conda installation

Using the previous `env.yml`

```bash
$ mkdir MyEnv
$ conda-containerize new --prefix MyEnv env.yml 
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

### Modifying a wrapped Conda installation

As the wrapped installation resides in a container, it cannot be directly
modified. Small python packages can be added outside the container, in the
usual way, using `pip`, but then the python packages are sitting on the
parallel file system which is not recommended for larger installations.

To actually modify the installation inside the wrapping container, you can use
the `update` keyword together with the `--post-install <file>` option which
specifies a bash script with commands to run to update the installation. The
commands are executed with the Conda environment activated.

```bash
$ conda-containerize update <existing installation> --post-install <file> 
```

where `<file>` could e.g. contain

```bash
conda  install -y numpy
conda  remove -y pyyaml
pip install requests
```

In this mode, the whole host system is available including all software and modules.

### Wrapping a plain pip installation

Sometimes you don't need a full-blown Conda environment, or you may prefer to
manage your python installations using pip. For this case you can use the
`pip-containerize` wrapper via

```bash
pip-containerize new --prefix <install_dir> req.txt
```

where `req.txt` is a standard [pip requirements.txt file][pip-req]. The above
notes and options for modifying a Conda installation apply to pip installations
as well.

Note that the Python version used by `pip-containerize` is the first Python
executable found on the `PATH`, so it is affected by loading modules.

!!! note
    This python used to installed pip packages cannot itself be container-based
    as nesting of containers is not possible.  

Additionally, you may use the `--slim` argument, which will use a pre-built
minimal python container with a much newer version of python as a base. Without
the `--slim` argument, the whole host system is available. However, by using
the `--slim` argument, the system installations (i.e /usr, /lib64 ...) are no
longer taken from the host, but are instead taken from the minimal python
container.

### Wrapping existing containers

The LUMI container wrapper also provides a tool to generate wrappers for
existing Apptainer/Singularity containers, so that they can be used
transparently without the need for prepending `singularity exec ...`, or modify
scripts if switching between containerized versions of tools.

```bash
wrap-container -w </path/inside/container> <container> --prefix <install_dir> 
```

where `<container>` can be a filepath or any URL accepted by `singularity` (e.g
`docker//:`, `oras//:`, or a local .sif file), and `-w` needs to be an absolute
path (or comma-separated list) inside the container. Wrappers will then be
automatically created for the executables in the target directories or for the
target path.

### Additional examples

More examples may be found in the [LUMI container wrapper GitHub repository
examples](https://github.com/CSCfi/hpc-container-wrapper/blob/master/examples/).

## How it works

A description of how LUMI container wrapper works may be found in the [LUMI
container wrapper GitHub repository README
file](https://github.com/CSCfi/hpc-container-wrapper/blob/master/README.md). A
short discussion of how LUMI container wrapper works from the user perspective
may be found in [this GitHub
issue](https://github.com/Lumi-supercomputer/lumi-userguide/issues/110#issuecomment-1619599189).
