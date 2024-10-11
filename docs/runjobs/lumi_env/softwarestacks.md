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

On LUMI, four types of software stacks are currently offered:

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

-   The `Local-*` stacks are software stacks provided by partner organisations,
    but not managed by the LUMI User Support Team. Some of those build on top of
    software in the `LUMI` stacks. The example further down this page shows two
    such modules:

    -   `Local-CSC`: Enables software installed and maintained by CSC. Most of that
        software is available to all users, though some packages are restricted or
        only useful to users of other CSC services (e.g., the `allas` module).

        Some of that software builds on software in the LUMI stacks, some is based
        on containers with wrapper scripts, and some is compiled outside of any 
        software management environment on LUMI.

    -   `Local-quantum` contains some packages of general use, but also some packages
        that are only relevant to Finnish researchers with an account on the Helmi
        quantum computer. Helmi is not a EuroHPC-JU computer so being eligible for an
        account on LUMI does not mean that you are also eligible for an account on
        Helmi.

    Other stacks may be introduced over time.


## Selecting the software stack

Running `module avail` on a fresh shell will show a list like:

```bash
$ module avail

... some lines removed here

-------------------------- HPE-Cray PE modules ----------------------------
   PrgEnv-amd/8.3.3
   PrgEnv-amd/8.4.0   
   PrgEnv-amd/8.5.0              (D)
   PrgEnv-aocc/8.3.3

... some lines removed here

----------------------------- Software stacks -----------------------------
   CrayEnv    (S)    LUMI/23.12            (S)      spack/22.08-2
   LUMI/22.08 (S)    LUMI/24.03            (S,D)    spack/23.03
   LUMI/22.12 (S)    Local-CSC/default     (S)      spack/23.03-2
   LUMI/23.03 (S)    Local-quantum/default (S)      spack/23.09   (D)
   LUMI/23.09 (S)    spack/22.08

--------------------- Modify the module display style ---------------------
   ModuleColour/off      (S)      ModuleLabel/label       (S,L,D)
   ModuleColour/on       (S,D)    ModuleLabel/PEhierarchy (S)
   ModuleExtensions/hide (S)      ModuleLabel/system      (S)
   ModuleExtensions/show (S,D)    ModulePowerUser/LUMI    (S)
   ModuleFullSpider/off  (S)      ModuleStyle/default
   ModuleFullSpider/on   (S,D)    ModuleStyle/reset       (D)

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
`CrayEnv`, 6 versions of the `LUMI` stack, 
5 versions of the `spack` stack,
and two stack modules whose name starts with `Local-` 
in this example. The `(S)` besides the
name shows that these are sticky modules that won't be removed by default by
``module purge``. This is done to enable you to quickly clean your environment
without having to re-initialize from scratch.

The next block, titled *Modify the module display style*, contains several
modules that can be used to change the way the module tree is displayed:

-   `ModuleColour`: these modules can be used to turn the color on or off in
    the module display.
-  `ModuleExtensions`: Show modulefile extensions in the output of `module avail`
    (`ModuleExtensions/show`) or hide them (`ModuleExtensions/hide`) to reduce
    the amount of output of `module avail`.
-   `ModuleLabel`: change the way the modules are subdivided in blocks and the
    way those blocks are presented.
    -   `ModuleLabel/label` is the default and will collapse related groups
        of modules in single blocks, including the Cray PE modules.
    -   `ModuleLabel/PEhierarchy`: will still use the user-friendly style of
        labeling but will show the complete hierarchy in the modules of the Cray
        PE.
    -   `ModuleLabel/system`: does not use the user-friendly label texts, but shows
        the path of the module directory instead.
-   `ModuleFullSpider`: By default, the software in some stacks will not be indexed
    by `module spider` unless the corresponding stack module is loaded when the
    cache used by `module spider` is regenerated. This is done to reduce the time
    of some module commands and reduce the pressure on the filesystems caused by
    those commands. However, with `ModuleFullSpider/on` you can get the "regular"
    `module spider` behaviour (or simply set `export LUMI_FULL_SPIDER=1` in your
    `.profile` file).
-   `ModulePowerUser`: will also reveal several hidden modules, most of which
    are only important to sysadmins or users who really want to do EasyBuild
    development in a clone of the software stack.
    (Or you could of course use the `--show_hidden` command line flag of `module avail`
    to show hidden modules also.)


### CrayEnv

Loading `CrayEnv` will essentially give you the default 
[Cray environment](https://cpe.ext.hpe.com/docs/#hpe-cray-user-environment)
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
module load LUMI/24.03
```

The `LUMI` module will try to detect the node type it is running on and will
automatically select the software stack for the node type by automatically
loading a `partition` module. However, that choice can always be overwritten by
loading another `partition` module, and this can even be done in a single
command, e.g.,

```bash
module load LUMI/24.03 partition/L
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

!!! warning "Versions of the LUMI module"
    It is advised to always load a specific version of the LUMI module to have
    access to the versions of the software that you want. 
    
    Newer versions of the
    `LUMI` module typically contain newer versions of a package.
    Older versions of packages are rarely re-installed in newer versions of a
    `LUMI` stack if a newer version is already available in that stack, and
    newer versions of software are not backported to older LUMI stacks. So if 
    you want to keep using a specific and older version of a package, you'll
    have to stay with that older version of the stack.

    After a system update, users should move to newer software stacks 
    and updated software as soon
    as possible. Older versions of the LUMI stacks may not be fully functional
    anymore because some of the programming environment libraries they use do
    not function well on the updated system, or simply because the older versions
    of software in those stacks may no longer be compatible with the new 
    environment.

    Failing to specify a specific version of the LUMI module may cause problems
    when the default is changed on the system, and jobs already in the queue may
    fail for that reason. 

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
type (`partition` module), but it is not needed for running that software.

See the [Easybuild][eb-in-docs] page for more information about installing
software using Easybuild.
