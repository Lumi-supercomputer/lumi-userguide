[helpdesk]: ../../helpdesk/index.md

# Spack

[Spack](https://spack.readthedocs.io/en/latest/) is a package manager that
automates the download-build-install process for HPC software. It is especially
useful for building and maintaining installations of many different versions of
the same software. It also comes with a virtual environment feature that is
useful when developing software.

LUMI provides a module to load a pre-configured Spack instance: `module load spack`. When you load this module, you will use a Spack instance configured to compile software with the Cray programming environment. The software will be installed in a location determined by you in the environmental variable `$SPACK_USER_PREFIX`. This Spack instance is "chained" to the upstream instance in `/appl/lumi/spack`, which means that you can build new packages on top of the already installed ones by the LUMI User Support Team (similar to how the LUMI EasyBuild setup works).

!!! important "The software installed with Spack in /appl/lumi/spack/ is provided as is."
    It may not have received any testing after installation! We also build the
    software there in a more fool-proof way with slightly less optimization:
    Zen2 architecture instead of Zen3, OpenBLAS instead of Cray LibSci, and
    Netlib Scalapack. This may have a small impact on performance, but is
    usually fine.

## Using Spack on LUMI

**To install software with Spack**, perform the following steps. In this
example, we will install [kokkos](https://kokkos.org/about/), a C++ parallel
programming framework, into a hypothetical project storage folder
`/project/project_465000XYZ/spack`. We want to configure this package with AMD
GPU support and activate extra array bounds checking for debugging.

1. Initialize Spack.

    ```bash
    $ export SPACK_USER_PREFIX=/project/project_465000XYZ/spack 
    $ module load spack/23.09
    ```

    We recommend that you set `$SPACK_USER_PREFIX` in e.g. your `.bash_profile`
    file to avoid having to set it every time you want to use Spack.

2. Check the information Spack has about the package and especially the
   configuration options:

    ```bash
    $ spack info kokkos
    ```

    From reading the package information, it becomes clear that the install command should be:

    ```bash
    $ spack install kokkos+rocm+debug_bounds_check amdgpu_target==gfx90a %gcc@12.2.0
    ```

    The flag `+rocm` activates GPU support, and `+debug_bounds_check` adds the
    array bounds checking. We also need to specify the type of GPU:
    `amdgpu_target==gfx90a` (note the double equal signs which has the special meaning of propagating the GPU target to all dependencies). In this case, we give no explicit specification of a compiler, which means that Spack will choose gcc 11.2.0 for us when compiling.
    
3. Before installing, it is good practice to check the dependencies that Spack
   will install. Sometimes this can be many, many, packages! Running this
   command can take some time (up to a few minutes):

    ```console
    $ spack spec -I kokkos+rocm+debug_bounds_check amdgpu_target==gfx90a %gcc@12.2.0
    Input spec
    --------------------------------
    -   kokkos%gcc@12.2.0+debug_bounds_check+rocm amdgpu_target==gfx90a

    Concretized
    --------------------------------
    -   kokkos@4.1.00%gcc@12.2.0~aggressive_vectorization~compiler_warnings~cuda~debug+debug_bounds_check~debug_dualview_modify_check~deprecated_code~examples~hpx~hpx_async_dispatch~hwloc~ipo~memkind~numactl~openmp~openmptarget~pic+rocm+serial+shared~sycl~tests~threads~tuning~wrapper amdgpu_target=gfx90a build_system=cmake build_type=Release cxxstd=17 generator=make intel_gpu_arch=none arch=linux-sles15-zen2
    [^]      ^cmake@3.27.7%gcc@12.2.0~doc+ncurses+ownlibs build_system=generic build_type=Release arch=linux-sles15-zen2
    [^]          ^curl@8.4.0%gcc@12.2.0~gssapi~ldap~libidn2~librtmp~libssh~libssh2+nghttp2 build_system=autotools libs=shared,static tls=openssl arch=linux-sles15-zen2
    [^]              ^nghttp2@1.57.0%gcc@12.2.0 build_system=autotools arch=linux-sles15-zen2
    [^]              ^openssl@3.1.3%gcc@12.2.0~docs+shared build_system=generic certs=mozilla arch=linux-sles15-zen2
    [^]                  ^ca-certificates-mozilla@2023-05-30%gcc@12.2.0 build_system=generic arch=linux-sles15-zen2
    [^]                  ^perl@5.38.0%gcc@12.2.0+cpanm+opcode+open+shared+threads build_system=generic patches=714e4d1 arch=linux-sles15-zen2
    [^]                      ^berkeley-db@18.1.40%gcc@12.2.0+cxx~docs+stl build_system=autotools patches=26090f4,b231fcc arch=linux-sles15-zen2
    [^]                      ^bzip2@1.0.8%gcc@12.2.0~debug~pic+shared build_system=generic arch=linux-sles15-zen2
    [^]                          ^diffutils@3.9%gcc@12.2.0 build_system=autotools arch=linux-sles15-zen2
    [^]                              ^libiconv@1.17%gcc@12.2.0 build_system=autotools libs=shared,static arch=linux-sles15-zen2
    [^]                      ^gdbm@1.23%gcc@12.2.0 build_system=autotools arch=linux-sles15-zen2
    [^]                          ^readline@8.2%gcc@12.2.0 build_system=autotools patches=bbf97f1 arch=linux-sles15-zen2
    [^]              ^pkgconf@1.9.5%gcc@12.2.0 build_system=autotools arch=linux-sles15-zen2
    [^]          ^ncurses@6.4%gcc@12.2.0~symlinks+termlib abi=none build_system=autotools arch=linux-sles15-zen2
    [^]          ^zlib-ng@2.1.4%gcc@12.2.0+compat+opt build_system=autotools arch=linux-sles15-zen2
    [^]      ^gmake@4.4.1%gcc@12.2.0~guile build_system=generic arch=linux-sles15-zen2
    [e]      ^hip@5.6.1%gcc@12.2.0~cuda+rocm build_system=cmake build_type=Release generator=make patches=aee7249,c2ee21c,e73e91b arch=linux-sles15-zen2
    [e]      ^hsa-rocr-dev@5.6.1%gcc@12.2.0+image+shared build_system=cmake build_type=Release generator=make patches=9267179 arch=linux-sles15-zen2
    [e]      ^llvm-amdgpu@5.6.1%gcc@12.2.0~link_llvm_dylib~llvm_dylib~openmp+rocm-device-libs build_system=cmake build_type=Release generator=ninja patches=a08bbe1,b66529f,d35aec9 arch=linux-sles15-zen2

    ...

    ```

    The packages that are already installed in your own Spack instance will
    have a `[+]` in the first column, and the packages that Spack found
    installed upstream will have `[^]`. A `-` means Spack did not find the
    package and will build it. External packages already installed in the operating system are marked with `[e]`.
    In this case, all dependencies are already installed so building a new `kokkos` package will be fast.

4. When you're satisfied with what Spack plans to do, install it:

    ```console
    $ spack install kokkos+rocm+debug_bounds_check amdgpu_target==gfx90a %gcc@12.2.0
    [+] /appl/lumi/spack/23.09/0.21.0/opt/spack/nghttp2-1.57.0-eeoiirs
    [+] /appl/lumi/spack/23.09/0.21.0/opt/spack/zlib-ng-2.1.4-lky5mdq
    [+] /appl/lumi/spack/23.09/0.21.0/opt/spack/ncurses-6.4-bd4kmia
    [+] /appl/lumi/spack/23.09/0.21.0/opt/spack/gmake-4.4.1-upexb7o
    [+] /appl/lumi/SW/CrayEnv/EB/rocm/5.6.1/hip (external hip-5.6.1-6dfpgvow3wgluedg7dkolvju5tqikf4a)
    [+] /appl/lumi/SW/CrayEnv/EB/rocm/5.6.1 (external hsa-rocr-dev-5.6.1-kdk4dmdpcit6od7zd4c4anpe67tjazvv)
    [+] /appl/lumi/SW/CrayEnv/EB/rocm/5.6.1/llvm (external llvm-amdgpu-5.6.1-lox2s3th5j6gtobnulhreq2xfyflres7)
    [+] /appl/lumi/spack/23.09/0.21.0/opt/spack/openssl-3.1.3-g2j3rdw
    [+] /appl/lumi/spack/23.09/0.21.0/opt/spack/curl-8.4.0-utgotfg
    [+] /appl/lumi/spack/23.09/0.21.0/opt/spack/cmake-3.27.7-4amcecb
    ==> Installing kokkos-4.1.00-gnre4vg6quv7syzovboykanhz5k5fyd5 [11/11]
    ==> No binary for kokkos-4.1.00-gnre4vg6quv7syzovboykanhz5k5fyd5 found: installing from source
    ==> Fetching https://mirror.spack.io/_source-cache/archive/cf/cf725ea34ba766fdaf29c884cfe2daacfdc6dc2d6af84042d1c78d0f16866275.tar.gz
    ==> No patches needed for kokkos
    ==> kokkos: Executing phase: 'cmake'
    ==> kokkos: Executing phase: 'build'
    ==> kokkos: Executing phase: 'install'
    ==> kokkos: Successfully installed kokkos-4.1.00-gnre4vg6quv7syzovboykanhz5k5fyd5
      Stage: 0.73s.  Cmake: 22.42s.  Build: 17.69s.  Install: 6.34s.  Post-install: 2.22s.  Total: 51.52s
    [+] /projappl/project_465000XYZ/spack/23.09/0.21.0/kokkos-4.1.00-gnre4vg
    ```

    The final line shows where the software is installed on disk. A module will
    also be generated automatically and added to your `$MODULEPATH`. The
    modules are generated with a short hash code (3 characters `hcn` here) to
    prevent name collisions.

    ```bash
    $ module load kokkos/4.1.00-gcc-gnr
    ```

## What to do when a Spack install fails

1. **Check if the error displayed suggests an easy solution.** If there is an
   error, Spack will point you to an installation log for the particular
   package. In the same directory, the full build directory can also be found
   in `/tmp`. Inspecting the output logs from `configure` or `cmake` can sometimes
   be fruitful.

    Some failures can be avoided by:

    - building a different version of the packages
    - building with a different compiler (try `%gcc` or `%cce`)
    - disabling a variant of the package
    - modifying which dependencies are used to build the target package (see
      [Specs and
      Dependencies](https://spack.readthedocs.io/en/latest/basic_usage.html#specs-dependencies)
      in the official Spack documentation)

    In some cases, changes have to be made to the `package.py` file of a package.
    Unfortunately, this is not straightforward as the package repository is
    located in `/appl/lumi`, which is read-only. In such cases, you have to either
    make your own Spack instance and configure it using our configuration
    files, or set up a custom Spack package repository and override the default Spack settings (see more below).

2. **Seek help:** you can check the 
    [official Spack documentation](https://spack.readthedocs.io), open a ticket 
    at the [LUMI Helpdesk](https://www.lumi-supercomputer.eu/user-support/need-help/) 
    or ask the Spack community via the [Spack Slack](http://spackpm.slack.com), 
    the Spack Slack community can be very helpful.

## Description of the different Spack modules

* Module `spack/23.09`: This is Spack release version 0.21.0 (with some critical bug fixes for concretization backported from the 0.21.1 development branch) based on the Cray Programming Environment 23.09.
  The ROCM packages are ROCM release version 5.6.1 adapted by the LUMI User Support Team for CPE 23.09.
  Testing has indicated that it should be possible to run ROCM 5.6.1-based software using the older drivers from ROCM 5.2.3, which is installed on the LUMI-G compute nodes.
  There are only minor incompatibilities, e.g. the amount of GPU memory might be reported incorrectly.
* Module `spack/23.03-2`: This is Spack release version 0.20.0 based on the Cray Programming Environment 23.03.
  The ROCM packages are built from source by Spack and corresponds to ROCM release version 5.4.3.
  Testing has indicated that it should be possible to run ROCM 5.4.3-based software using the older drivers from ROCM 5.2.3, which is installed on the LUMI-G compute nodes.
* Module `spack/23.03`: This is Spack release version 0.19.2 based on the Cray Programming Environment 23.03.
  The ROCM packages are external and comes from the HPE provided ROCM 5.2.3 in `/opt/rocm`.
* Module `spack/22.08-2`: This is Spack release version 0.19.0 based on the Cray Programming Environment 22.08.
  The ROCM packages are built from source by Spack and corresponds to ROCM release version 5.2.3.
  **This Spack module is deprecated and should not be used!**
  Testing has indicated that it should be possible to run ROCM 5.2.3-based software using the older drivers from ROCM 5.1.3, which is installed on the LUMI-G compute nodes.
* Module `spack/22.08`: This is Spack release version 0.18.1 based on the Cray Programming Environment 22.08.
  The ROCM packages are external and comes from the HPE provided ROCM 5.0.2 in `/opt/rocm` (which is rather old).
  **This Spack module is deprecated and should not be used!**
  MPI programs may not work, and the linked ROCm is ancient and does not exist on the system anymore.

## Spack on LUMI (advanced)

This section further explains the Spack setup on LUMI.

The upstream Spack instances maintained by the [User Support Team][helpdesk]
are located in subdirectories of `/appl/lumi/spack`, numbered according to the
Cray Programming Environment release version, and Spack release version. For
example:

```text
/appl/lumi/spack/22.08/0.18.1/
```

This is a Spack instance based on Spack release 0.18.1 configured to use the
compilers and MPI libraries from the Cray Programming Environment release
22.08. In general, we will only install one or two versions of Spack per programming
environment. **These instances are not meant to be used directly by users** as
they are configured to install packages centrally, i.e. `spack install` will
fail with permission errors, but you can copy the configuration files from
there if you want to make your own Spack instance.

Instead, for users, there are "fake" chained Spack instances installed
alongside these which are configured with install packages in a user-specified
location. These instances have names which end in `-user`, e.g.:

```text
/appl/lumi/spack/22.08/0.18.1-user/
```

This is what the `spack` modules use, and what you should use as user on the
system if you do not want set up your own Spack instance. If you check the `etc/spack/config.yaml` inside, you will see that they set the `install_tree` property to a value provided by `$SPACK_USER_PREFIX`.

```text
config:
    build_jobs: 32
    install_path_scheme: '{name}-{version}-{hash:7}'
    install_tree: $SPACK_USER_PREFIX/22.08/0.18.1
    source_cache: $SPACK_USER_PREFIX/22.08/0.18.1/cache
    misc_cache:   $SPACK_USER_PREFIX/22.08/0.18.1/cache
    install_missing_compilers: false
    suppress_gpg_warnings: true
```

A similar trick is used in the `modules.yaml` file to install modules in
`$SPACK_USER_PREFIX/22.08/0.18.1/modules/tcl`.

```text
modules:
  default:
    roots:
      tcl: $SPACK_USER_PREFIX/22.08/0.18.1/modules/tcl
    enable:
      - tcl
    tcl:
      hash_length: 5
      projections:
        all: '{name}/{version}-{compiler.name}'
```

If you want to use Spack directly (without `module load spack`), you can source
the Spack initialization scripts as usual. They can be found on disk in e.g.:

```bash
$ source /appl/lumi/spack/22.08/0.18.1-user/share/spack/setup-env.sh
```

You need to make sure that `$SPACK_USER_PREFIX` is set and that the
`cache` and `modules/tcl` subdirectories exist within that directory.

### Overriding the default settings in the Spack module

The `spack` modules read the configuration files from the `/appl/lumi/spack/.../etc/` directory, which is read-only for users.
To change the configuration files, you need to override the default settings by placing new configuration files (like `compilers.yaml` and `packages.yaml`) in the `$HOME/.spack/` directory and then unset the environment variable `$SPACK_DISABLE_LOCAL_CONFIG`.
It will not work otherwise, because the Spack module on LUMI sets this variable to prevent accidental interference between any user-local Spack configuration and the system configuration.

### Making a custom package repository

Adding your own package repository can be done in a similar way to changing the configuration files. You can add your own `repos.yaml` file in the `~/.spack/` directory and then configure the path to your custom package directory inside that file:

```
$ cat ~/.spack/repos.yaml
repos:
- /users/username/spack-packages
```

When `$SPACK_DISABLE_LOCAL_CONFIG` is unset, Spack will read this configuration file and pick up your private Spack repository. You can verify that Spack is seeing the new package repository by running the `spack repo list` command:

```
 $ spack repo list
==> 2 package repositories.
custom     /users/username/spack-packages
builtin    /pfs/lustrep3/appl/lumi/spack/23.03/0.20.0-user/var/spack/repos/builtin
```

More information about creating package repositories is available in the [Spack documentation](https://spack.readthedocs.io/en/latest/repositories.html).

## Further reading

- [Spack documentation](https://spack.readthedocs.io/en/latest/index.html)
- [Spack tutorial](https://spack.readthedocs.io/en/latest/tutorial.html)
- [Spack Source code](https://github.com/spack/spack) (especially the package definitions)
- [Spack Slack](https://slack.spack.io/)
