[helpdesk]: ../../helpdesk/index.md

# Spack

[Spack](https://spack.readthedocs.io/en/latest/) is a package manager that
automates the download-build-install process for HPC software. It is especially
useful for building and maintaining installations of many different versions of
the same software. It also comes with a virtual environment feature that is
useful when developing software.

LUMI provides pre-configured Spack instances as Lmod modules, one per compute
partition: `spack-cpu/1.1` for the LUMI-C (CPU) nodes and `spack-gpu/1.1` for
the LUMI-G (GPU) nodes. The version number (`1.1`) is the Spack release version.

Both modules reuse the compilers and system libraries already present on LUMI —
from the Cray Programming Environment and from the operating system — rather
than rebuilding them, and both install the software you build into a location
you control through the environment variable `$SPACK_USER_PREFIX`.

!!! important "The `spack-cpu` and `spack-gpu` modules belong to the `LUMI_SoftwareStack` family."
    Loading one automatically unloads the other, and both conflict with the
    LUMI software stacks (`CrayEnv`, `LUMI/<version>`). Use one software stack
    per shell session — either a Spack module or a LUMI stack, not both.

## What the Spack modules provide

The setup is organized per compute partition rather than per Cray Programming
Environment release: a single configuration lists every compiler installed on
the system, so it is not tied to one CPE version.

* `spack-cpu/1.1` — for the LUMI-C CPU nodes. It uses the system `libfabric`
  and builds `mpich`/`openmpi` without GPU support.
* `spack-gpu/1.1` — for the LUMI-G GPU nodes. Everything in the CPU
  configuration, plus the AMD ROCm/HIP stack as external packages (currently
  ROCm 6.3.4, from `/opt/rocm-6.3.4`), the AMD `llvm-amdgpu` compiler, and
  `+rocm amdgpu_target=gfx90a` applied by default so that packages are built for
  the MI250X GPUs.

Both modules share the following defaults:

* **Compilers** (all external, from the Cray Programming Environment or the
  system): `gcc@14.3.0` (the default), `gcc@12.2.0`, `gcc@7.5.0`, `cce@20.0.0`
  and `cce@19.0.0`. The GPU module additionally offers `llvm-amdgpu@6.3.4`. The
  default compiler is a soft preference — you can override it per spec with
  `%<compiler>@<version>`.
* **Target microarchitecture** `zen3`, matching the LUMI compute nodes. The
  concretizer is configured with `host_compatible: false` so that you can
  concretize and build for the Zen3 compute nodes from the Zen2 login nodes.
* **BLAS/LAPACK** provided by OpenBLAS, and **MPI** by `mpich` (preferred) or
  `openmpi`.

## Installing software

**To install software with Spack**, perform the following steps. In this
example, we will install [kokkos](https://kokkos.org/about/), a C++ parallel
programming framework, with AMD GPU support and extra array bounds checking for
debugging, into a project storage folder `/project/project_465000XYZ/spack`.

1. Load the Spack module for the partition you are targeting. Because we want a
   GPU build, we use `spack-gpu`:

    ```bash
    $ export SPACK_USER_PREFIX=/project/project_465000XYZ/spack
    $ module load spack-gpu/1.1
    ```

    `$SPACK_USER_PREFIX` determines where your installed packages, generated
    modules, caches and environments are stored. If you do not set it, it
    defaults to `$HOME/spack-prefix`. Because software installations can grow
    large and your home directory has a small quota, we recommend pointing it at
    a project or scratch folder, and setting it in e.g. your `.bash_profile` so
    you do not have to set it every time. The module creates the
    `install/`, `cache/`, `modules/` and `environments/` subdirectories under
    the prefix automatically when it is loaded.

2. Check the information Spack has about the package, especially the
   configuration options:

    ```bash
    $ spack info kokkos
    ```

    From reading the package information, the install command becomes:

    ```bash
    $ spack install kokkos +debug_bounds_check
    ```

    The flag `+debug_bounds_check` adds the array bounds checking. Note that we
    do **not** have to pass `+rocm`, the GPU target, or the CPU microarchitecture:
    the `spack-gpu` module applies `+rocm amdgpu_target=gfx90a` (the LUMI-G MI250X
    GPUs) and `target=zen3` (the LUMI-G compute-node CPU) as defaults. We also
    give no explicit compiler, so Spack uses the default `gcc@14.3.0`. To pick a
    different compiler, append e.g. `%cce@20.0.0` or `%llvm-amdgpu@6.3.4` to the
    spec.

3. Before installing, it is good practice to check the dependencies that Spack
   will install. Sometimes this can be many, many packages! Running this
   command can take some time (up to a few minutes):

    ```console
    $ spack spec -I kokkos +debug_bounds_check
    ...
    Concretized
    --------------------------------
     -   kokkos@4.x.x%gcc@14.3.0 ~aggressive_vectorization ... +debug_bounds_check
             +rocm +serial +shared amdgpu_target=gfx90a ... arch=linux-sles15-zen3
    [e]      ^hip@6.3.4%gcc@14.3.0 ...
    [e]      ^hsa-rocr-dev@6.3.4%gcc@14.3.0 ...
    [e]      ^llvm-amdgpu@6.3.4%gcc@14.3.0 ...
     -       ^cmake@3.xx.x%gcc@14.3.0 ...
    ...
    ```

    Packages already installed in your Spack prefix show a `[+]` in the first
    column. A `-` means Spack did not find the package and will build it.
    Packages that are provided externally by the system are marked with `[e]`
    and are used in place rather than rebuilt: the compilers, Slurm, `libfabric`,
    `xpmem` and, on the GPU partition, the ROCm/HIP stack. MPI is not one of
    them — Spack builds `mpich` or `openmpi` itself, on top of the system
    `libfabric`.

4. When you're satisfied with what Spack plans to do, install it:

    ```console
    $ spack install kokkos +debug_bounds_check
    ...
    ==> Installing kokkos-... [n/n]
    ==> kokkos: Successfully installed kokkos-...
    [+] /project/project_465000XYZ/spack/install/kokkos-4.x.x-xxxxxxx
    ```

    The final line shows where the software is installed on disk, under
    `$SPACK_USER_PREFIX/install`. A module is also generated automatically and
    added to your `$MODULEPATH`. Module names follow the pattern
    `<name>/<version>-<compiler>-<compiler version>-<hash>`, where the short hash
    at the end prevents name collisions between different builds of the same
    package and version:

    ```bash
    $ module load kokkos/4.x.x-gcc-14.3.0-abc
    ```

    Modules are only generated for the packages you install explicitly.
    Dependencies that Spack pulls in on its own do not get a module of their own.

## Spack environments

Instead of installing packages one by one, you can group a set of packages into
a Spack [environment](https://spack.readthedocs.io/en/latest/environments.html).
An environment concretizes all its specs together, so shared dependencies are
guaranteed to match, and installs them as a unit. This is the recommended way to
build a coherent stack of related packages:

```bash
$ spack env create my-env
$ spack env activate my-env
$ spack add kokkos +debug_bounds_check
$ spack add hdf5
$ spack concretize
$ spack install
```

Environments are stored under `$SPACK_USER_PREFIX/environments`. For large
environments you can let Spack build independent packages in parallel by
generating a Makefile with `spack env depfile`:

```bash
$ spack env depfile -o Makefile
$ make -j 16
```

## Customizing the configuration

The LUMI modules occupy both of Spack's file-based configuration scopes with the
central configuration (see [How the LUMI Spack setup
works](#how-the-lumi-spack-setup-works) below), so no personal scope is left for
you to edit. The way to change settings (compilers, variants, external packages)
or to add your own package repository is therefore a **Spack environment**, whose
`spack.yaml` takes precedence over both of them.

For example, to create your own package repository and add it to an environment:

```bash
$ spack repo create /users/username/my-packages myrepo
$ spack env activate my-env
$ spack repo add /users/username/my-packages
$ spack repo list
```

`spack repo list` prints one line per repository, showing its status, namespace,
package API version and location. Your own repository is listed next to the
built-in one, which Spack clones from
[`spack-packages`](https://github.com/spack/spack-packages) into
`~/.spack/package_repos/`.

!!! note "Run `spack repo add` with an environment active"
    `spack repo add` writes to whichever configuration scope is currently
    modifiable. With an environment active, that is the environment's
    `spack.yaml`. Without one, Spack tries to write to the partition
    configuration under `/appl/lumi`, which is read-only, and the command fails.

More information about creating package repositories is available in the
[Spack documentation](https://spack.readthedocs.io/en/latest/repositories.html).

## What to do when a Spack install fails

1. **Check if the error displayed suggests an easy solution.** If there is an
   error, Spack will point you to an installation log for the particular
   package. In the same directory, the full build directory can also be found
   in `/tmp`. Inspecting the output logs from `configure` or `cmake` can sometimes
   be fruitful.

    Some failures can be avoided by:

    - building a different version of the packages
    - building with a different compiler (try `%gcc`, `%cce` or, on the GPU
      partition, `%llvm-amdgpu`)
    - disabling a variant of the package
    - modifying which dependencies are used to build the target package (see
      [Specs and
      Dependencies](https://spack.readthedocs.io/en/latest/basic_usage.html#specs-dependencies)
      in the official Spack documentation)

    In some cases, changes have to be made to the `package.py` file of a package.
    Editing the built-in recipes in place is not an option: as of Spack 1.0 they
    are no longer part of the Spack source tree, but are cloned from the separate
    [`spack-packages`](https://github.com/spack/spack-packages) repository into a
    cache under `~/.spack/package_repos/` that Spack manages and overwrites.
    Instead, set up your own Spack package repository and add it to a Spack
    environment, as described under [Customizing the
    configuration](#customizing-the-configuration).

2. **Seek help:** you can check the
    [official Spack documentation](https://spack.readthedocs.io), open a ticket
    at the [LUMI Helpdesk](https://www.lumi-supercomputer.eu/user-support/need-help/)
    or ask the Spack community via the [Spack Slack](http://spackpm.slack.com),
    the Spack Slack community can be very helpful.

## How the LUMI Spack setup works

The Spack installation maintained by the [User Support Team][helpdesk] lives
under `/appl/lumi`, which is read-only for users:

```text
/appl/lumi/
├── spack-1.1/                # Spack source tree (one directory per Spack version)
└── lumi-spack-settings/      # LUMI configuration and the Lmod modulefiles
    └── configs/
        ├── common/           # shared: compilers, install tree, modules, providers
        ├── partition-c/      # LUMI-C extras (libfabric, mpich/openmpi)
        └── partition-g/      # LUMI-G extras (ROCm/HIP stack, GPU defaults, AMD compiler)
```

When you load a Spack module, it points `$SPACK_ROOT` at the shared Spack source
tree (`/appl/lumi/spack-1.1`) and layers the configuration on top through Spack's
[configuration scopes](https://spack.readthedocs.io/en/latest/configuration.html):

* the `configs/common` directory is used as the *system* scope
  (`$SPACK_SYSTEM_CONFIG_PATH`),
* the partition-specific directory (`configs/partition-c` or
  `configs/partition-g`) is used as the *user* scope
  (`$SPACK_USER_CONFIG_PATH`).

Because the partition configuration takes the user scope, the module does **not**
read a personal `~/.spack/` configuration — the partition config replaces it.
This redirects the configuration scope only: `~/.spack/` remains Spack's user
cache directory, and is where the built-in package repository gets cloned.
The `config.yaml` in the common scope is what redirects the install tree, the
download and build caches, the generated modules and the environments into your
`$SPACK_USER_PREFIX`:

```yaml
config:
  build_jobs: 32
  install_tree:
    root: $SPACK_USER_PREFIX/install
    projections:
      all: '{name}-{version}-{hash:7}'
    padded_length: 128
  source_cache: $SPACK_USER_PREFIX/cache
  misc_cache: $SPACK_USER_PREFIX/cache
  environments_root: $SPACK_USER_PREFIX/environments
```

A similar redirection in `modules.yaml` generates the Lmod modules under
`$SPACK_USER_PREFIX/modules/lmod` and places them in a flat `Core/` layout, so
every generated module can be loaded straight away with `module load`, without
having to load a compiler or MPI module first.

If you want to use Spack directly (without `module load`), you can source the
Spack initialization script from the shared source tree:

```bash
$ source /appl/lumi/spack-1.1/share/spack/setup-env.sh
```

In that case you have to set `$SPACK_USER_PREFIX`, and point
`$SPACK_SYSTEM_CONFIG_PATH` and `$SPACK_USER_CONFIG_PATH` at the appropriate
`configs/common` and `configs/partition-<c|g>` directories yourself, otherwise
Spack will not pick up the LUMI configuration.

### Inspecting the effective configuration

When something is not behaving as expected, these commands show what Spack is
actually using and where each setting comes from:

```bash
$ spack config get packages      # merged effective packages configuration
$ spack config get modules       # merged effective modules configuration
$ spack config blame packages    # which file each setting comes from
$ spack spec -I <spec>           # what the concretizer picks for a spec
$ spack arch                     # the architecture of the current node
```

## Further reading

- [Spack documentation](https://spack.readthedocs.io/en/latest/index.html)
- [Spack tutorial](https://spack.readthedocs.io/en/latest/tutorial.html)
- [Spack Source code](https://github.com/spack/spack) (especially the package definitions)
- [Spack Slack](https://slack.spack.io/)
