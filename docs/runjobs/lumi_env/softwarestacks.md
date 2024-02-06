# Software stacks

[easybuild]: https://easybuild.io/
[eb-in-docs]: ../../software/installing/easybuild.md

[spack-site]: https://spack.readthedocs.io/
[spack-in-docs]: ../../software/installing/spack.md

[module-environment]: ../../runjobs/lumi_env/Lmod_modules.md
[containerwrapper]: ../software/installing/container-wrapper.md
[prgenv]: ../../development/compiling/prgenv.md

[lumi-software-library]: https://lumi-supercomputer.github.io/LUMI-EasyBuild-docs

The LUMI software stacks contain the software already installed on
LUMI. The software stacks are made available through the [LMOD module
environment][module-environment].

## Overview

On LUMI, three types of software stacks are currently offered:

-   `CrayEnv` offers the Cray Programming Environment (PE) and allows one to use
    it completely in the way intended by HPE-Cray. The environment also offers a
    limited selection of additional tools, often in updated versions compared to
    what SUSE Linux, the basis of the Cray Linux environment, offers. If you
    need a richer environment, you should use our other software stacks.

-   `LUMI` is an extensible software stack mostly managed through
    [EasyBuild][easybuild]. You can read more about EasyBuild on LUMI on
    [the "Easybuild" page in the "Software" section][eb-in-docs]. 
    Each version of the LUMI software stack is based on the
    version of the Cray Programming Environment with the same version number.

    A deliberate choice was made to only offer a limited number of software
    packages in the globally installed stack as the setup of redundancy on LUMI
    makes it difficult to update the stack in a way that is guaranteed to not
    affect running jobs and as a large central stack is also hard to manage.
    However, the EasyBuild setup is such that users can easily install
    additional software in their home or project directory using EasyBuild build
    recipes that we provide or they develop, and that software will fully
    integrate in the central stack (even the corresponding modules will be made
    available automatically).

-   `spack` is an extensible software stack based on the 
    [Spack package manager][spack-site]. You can read more about Spack on LUMI
    on [the "Spack" page in the "Software" section][spack-in-docs].
    Spack is offered "as-is" for users experienced in the use of Spack, but
    properly pre-configured to use compilers and some libraries already installed
    on the system. The LUMI User Support Team does not implement new Spack packages or
    debug build recipes for existing ones.

## Selecting the software stack

Running `module avail` on a fresh shell will show a list like:

```bash
$ module avail

... some lines removed here

-------------------------- HPE-Cray PE modules ----------------------------
   PrgEnv-amd/8.3.3
   PrgEnv-amd/8.4.0              (D)
   PrgEnv-aocc/8.3.3

... some lines removed here

----------------------------- Software stacks -----------------------------
   CrayEnv    (S)      LUMI/23.03  (S)    spack/22.08-2
   LUMI/22.08 (S,D)    LUMI/23.09  (S)    spack/23.03
   LUMI/22.12 (S)      spack/22.08        spack/23.03-2 (D)

--------------------- Modify the module display style ---------------------
   ModuleColour/off      (S)        ModuleLabel/PEhierarchy (S)
   ModuleColour/on       (S,D)      ModuleLabel/system      (S)
   ModuleExtensions/hide (S)        ModulePowerUser/LUMI    (S)
   ModuleExtensions/show (S,D)      ModuleStyle/default
   ModuleLabel/label     (S,L,D)    ModuleStyle/reset       (D)

-------------------------- System initialisation --------------------------
   init-lumi/0.2 (S,L)

------------------------- Non-PE HPE-Cray modules -------------------------

... some lines removed here

------------------- This is a list of module extensions -------------------
    rclone (E)     restic (E)     s3cmd (E)

... some lines removed here
```

The first block(s) in the output are the modules available through the default
software stack.

The *Software stacks* block in the output shows the available software stacks:
`CrayEnv`, 4 versions of the `LUMI` stack and 
4 versions of the `spack` stack in this example. The `(S)` besides the
name shows that these are sticky modules that won't be removed by default by
``module purge``. This is done to enable you to quickly clean your environment
without having to re-initialize from scratch. In the future we may mark some
stacks also with `LTS` next to their name which would then denote that this is
a release that we will try to support long-term (ideally two years), but
currently the system is changing too rapidly (as some of the hardware is new
and not an evolution of previous hardware) so we cannot guarantee any level of
longevity for any of the software stacks. In fact, experience has shown
that we may have to remove a stack after a year or so.

The next block, titled *Modify the module display style*, contains several
modules that can be used to change the way the module tree is displayed:

-   `ModuleColour`: these modules can be used to turn the color on or off in
    the module display.
-   `ModuleLabel`: change the way the modules are subdivided in blocks and the
    way those blocks are presented.
-   `ModuleLabel/label` is the default and will collapse related groups
    of modules in single blocks, including the Cray PE modules.
-   `ModuleLabel/PEhierarchy`: will still use the user-friendly style of
    labeling but will show the complete hierarchy in the modules of the Cray
    PE.
-   `ModuleLabel/system`: does not use the user-friendly label texts, but shows
    the path of the module directory instead.
-   `ModulePowerUser`: will also reveal several hidden modules, most of which
    are only important to sysadmins or users who really want to do EasyBuild
    development in a clone of the software stack.
-   `ModuleExtensions/hide` and `ModuleExtensions/show` are used to hide or show
    the module extensions at the end of the overview of `module avail`.

### CrayEnv

Loading `CrayEnv` will essentially give you the default [Cray environment](https://cpe.ext.hpe.com/docs/#hpe-cray-user-environment)
enriched with several additional tools. The `CrayEnv` module will try to detect
the node type of LUMI it is running on and load an appropriate set of target
architecture modules to configure the Cray PE (see the documentation page on
[the programming environment][prgenv] in the Development section). Executing a
`module purge` while working in the `CrayEnv` environment will automatically
reload that module and restore the target architecture modules to a set
suitable for the node type you are working on.

### LUMI

`LUMI` is our main software stack, managed mostly with [EasyBuild][easybuild].
It contains software build with the system compiler and the `PrgEnv-gnu`,
`PrgEnv-cray`, `PrgEnv-aocc` and `PrgEnv-amd` programming environments, which
includes Cray MPI and the Cray scientific libraries. As mixing compiler
versions and library versions is dangerous, the stack is organized in versions
that correspond to the version of the Cray PE used to compile the software.
Some versions may have the extension `.dev` which denotes that they are highly
experimental and under development, and may completely change or disappear at
some point.

The LUMI software stack is activated by loading the desired version of the LUMI
module, e.g.,

```bash
module load LUMI/23.09
```

The `LUMI` module will try to detect the node type it is running on and will
automatically select the software stack for the node type by automatically
loading a `partition` module. However, that choice can always be overwritten by
loading another `partition` module, and this can even be done in a single
command, e.g.,

```bash
module load LUMI/23.09 partition/L
```

will load the software stack for the login nodes (which in fact will also work
on the compute nodes and data analysis and visualization nodes).

??? note "`partition/L` and LUMI-C compute nodes"
    Software in `partition/L` can be used on
    the compute nodes also and there is even some MPI-based software already
    installed in that partition. However, 
    software compiled in `partition/C` may offer better performance on the
    compute nodes of LUMI-C as software in that partition is specifically
    optimized for the zen3 "Milan" CPUs in those nodes.

    Running MPI programs is not supported on the login nodes, but those modules
    may still contain useful pre- or postprocessing software that can be used
    on the login nodes.

Once loaded, you will be presented with a lot of modules in a flat naming scheme.
This means that all software available in that version of the LUMI software
stack will be shown by `module avail` (except for hidden modules for software that
we deem most users may not directly load). However, not any combination of
modules can be loaded together. In particular, software compiled with different
programming environments cannot be used together. There are five types of
modules:

-   The module version contains `cpeGNU-yy.mm` (with `yy.mm` the version of the
    LUMI stack): The package is compiled with the `PrgEnv-gnu` programming
    environment.

-   The module version contains `cpeCray-yy.mm`: The package is compiled with
    the `PrgEnv-cray` programming environment.

-   The module version contains `cpeAOCC-yy.mm`: The package is compiled with
    the `PrgEnv-aocc` programming environment, the AMD compilers for CPU-only
    work (hence available only on LUMI-C, LUMI-D and the login nodes)

-   The module version contains `cpeAMD-yy.mm`: The package is compiled with
    the `PrgEnv-AMD` programming environment, the Cray wrapper around the
    AMD ROCm compilers. This environment will only be offered on LUMI-G.

-   The name contains neither of those: The package is compiled with the system
    gcc compiler, something that is only done for software that is
    not performance-critical like some build tools and workflow tools.

In EasyBuild, `cpeGNU`, `cpeCray`, `cpeAOCC` and `cpeAMD` are called toolchains, a set of
compatible compilers, MPI and mathematical libraries. Software compiled with the
system compiler is also called software compiled with the system toolchain,
which is a restricted toolchain that only contains the compiler that comes with
the operating system. Software
compiled with different `cpe*` toolchains cannot be loaded at the same time but
can be loaded together with software compiled with the SYSTEM toolchain. The
module system currently does not protect you against making such mistakes!
However, software may fail to work properly.

??? failure "Issue: Missing programming environments"
    When we retire a programming environment from the system, the
    corresponding `LUMI` module may remain available for a while with
    some tricks under the hood so that software already compiled for that
    version of the `LUMI` module would mostly still run. However,
    no new compilations should be done with such a toolchain, and
    we cannot guarantee that all software will still run (and know
    for sure that some software will not run anymore due to the way
    it is linked against libraries).

## Adding additional software to the LUMI software stack

The `LUMI` software stack itself cannot offer all software to all users as that
would be both confusing (certainly as sometimes customizations are expected) and
impossible to maintain (as it would not be clear when software can be removed
and no longer needs to be updated). Therefore, the `LUMI` software stack can be
extended with software installed in the user's space through EasyBuild in a way
that is 100% compatible with the system stack. That software will be
automatically visible when loading the `LUMI` module.

The [LUMI Software Library][lumi-software-library] provides an overview of all
software that is either available pre-installed on the system or can be 
user-installed via EasyBuild using recipes developed by LUST and partners in the
LUMI project (and instructions for some software that is unsuitable for installation
through EasyBuild).

The default location for user-installed software in `$HOME/EasyBuild`. However,
we advise installing software in the `/project` directory of the project
instead so that a single software installation can be used by all members of the
project. This is done by pointing the environment variable `EBU_USER_PREFIX` to
the software installation directory, e.g.,

```bash
export EBU_USER_PREFIX=/project/project_465000000
```

It is a good idea to do this in your `.profile` or `.bashrc` file. This will
enable the `LUMI` modules to also find the software installed in that directory.

Loading the `EasyBuild-user` module will enable installing software with
EasyBuild for the current version of the `LUMI` software stack and current node
type (`partition` module).

See the [Easybuild][eb-in-docs] page for more information about installing
software using Easybuild.
