# Tykky

## Intro

Tykky is a set of tools which wrap installations inside 
a container to improve startup times, 
reduce IO load, and lessen the number of files on large parallel filesystems. 

Additionally, Tykky will generate wrappers so that installed
software can be used (almost) as if it were not containerized. Depending
on tool selection and settings, either the whole host filesystem or
a limited subset is visible during execution and installation. This means that
it's possible to wrapp installation using e.g mpi4py relying on the host provided
mpi installation. 

This documentation covers a subset of the functionality and focuses on
conda and Python, a large part of the advanced use-cases
are not covered here yet. If you notice that your program or language behaves differently
or incorrectly, please contact support.

## Basic conda installation

```bash
conda-containerize new --prefix <install_dir> env.yml
```

Where **env.yml** is a conda environemnt file.
This file can be written manually, e.g:

env.yaml
```yaml
channels:
  - conda-forge
dependencies:
  - python=3.8.8
  - scipy
  - nglview
```

Or then generate them from an existing environment

```
export CONDA_DEFAULT_ENV=<target_env_name>
```

Then 

```
conda env export > env.yaml 
```
or 
```
conda list --explicit > env.txt
```

After the installation is done you simply need to add 
the bin diretory `<install_dir>/bin` to the path. 

```bash
export PATH="<install_dir>/bin:$PATH"
```
The you can call python and any other executables conda has installed in the same way as you would have activated the environment. 

If you also need to install some additional pip packages you can do by supplying
the `-r <req_file>` argument e.g: 

```
conda-containerize new -r req.txt --prefix <install_dir> env.yml
```

The tool also supports using [mamba](https://github.com/mamba-org/mamba) 
for installing packages. Enable this feature by adding the `--mamba` flag. 
`conda-containerize new --mamba ...`

## Modifying a conda installation

As Tykky installed software resides in a container, it can not be directly modified.
Small python packages can be added normally using `pip`, but then the python packages are
sitting on the parallel filesystem so not recommended for any larger installations.  

To actually modify the installation we can use the `update` keyword
together with the `--post-install <file>` option which specifies a bash script
with commands to run to update the installation. The commands are executed 
with the conda environment activated. 

```
conda-containerize update <existing installation> --post-install <file> 
```

Where `<file>` could e.g contain:

```
conda  install -y numpy
conda  remove -y pyyaml
pip install requests
```

In this mode the whole host system is available including all software and modules 

## Plain pip installations

Sometimes you don't need a full blown conda environment or then you prefer pip
to manage python installations. For this case we can use: 

```
pip-containerize new --prefix <install_dir> req.txt
```
Where `req.txt` is a standard pip requirements file. 
The  notes and options for modifying a conda installation apply here as well.

Note that the python version used by `pip-containerize` is the first python executable find in the path, so it's affected by loading modules. 

**Important:** This python can not be itself container-based as nesting is not possible.  

An additional flag `--slim` argument exists, which will instead use a pre-built minimal python
container with a much newer version of python as a base. Without the `--slim` flag, the whole host system is available,
and with the flag the system installations (i.e /usr, /lib64 ...) are no longer taken from the host, instead
coming from within container. 

## Existing containers 

Tykky also provides a tool to generate wrappers for existing containers, so that they can be used 
transparently (no need to prepend `singularity exec ...`, or modify scripts if switching between containerized versions of tools).

```
wrap-install -w </path/inside/container> <container> --prefix <install_dir> 
```
where `<container>` can be a filepath or any url accepted by singularity (e.g `docker//:` `oras//:` or any other singularity accepted format)
`-w` needs to be an absolute path (or comma separated list) inside the container. Wrappers will then be automatically
created for the executables in the target directories / for the target path.  

## Small more complicated example

_Tykky is still under development so some of the more advanced features
might change in exact usage_

Let's compile a small fftw toy code inside a container.

def.yml
```
channels:
  - conda-forge
  - eumetsat
dependencies:
  - fftw3
  - gxx
```

install_prog.sh
```
cp fftw.cpp $CW_INSTALLATION_PATH
cd $CW_INSTALLATION_PATH
export CPATH="$CPATH:$env_root/include"
g++ -lfftw3 -L $env_root/lib fftw.cpp -o fftw_prog
```
[fftw.cpp](https://github.com/SouthAfricaDigitalScience/fftw3-deploy/blob/master/hello-world.cpp)

Here the `CW_INSTALLATION_PATH` point to the root of the installation which will be containerized,
files placed outside this path will not be part of the installation. `env_root`
is a `conda-containerize` specific variable which point to the root of the conda environment.

```
mkdir Inst
conda-containerize new --prefix Inst/ --post install_test.sh -w fftw_prog def.yml 
```

After this we can now run our toy program 
``` 
$ Inst/bin/fftw_prog
0.868345
0.934584
1.01441
1.11207
1.23383
64.513
1.59397
.
.
.
```

The size of this installation is 591MB and 165 files, if we would have
installed it outside the container it would be 1.4GB and 34251 files.

## How it works

See the README in the source code repository. 
The source code can be found in the [GitHub repository](https://github.com/CSCfi/hpc-container-wrapper)
