# Installing software with EasyBuild

[Lmod_modules]: ../../computing/Lmod_modules.md
[softwarestacks]: ../../computing/softwarestacks.md

Most software in the central LUMI software stacks is installed through
[EasyBuild](https://easybuild.io/). The central software stack is kept as
compact as possible to ease maintenance and to avoid user confusion. E.g.,
packages for which users request special customisations will never be
installed in the central software stack. Moreover, due to the technical
implementation of the software stack on a system the size of LUMI, installing
software can be disruptive so new software is mostly made available during
maintenance intervals.

This however does not mean that you may have to wait for weeks before you can get
the software you need for your project in LUMI. We made it very easy to install
additional software in your home or project directories (where the latter is the
better choice as you can then share with the other people in your project) and use
that software. It requires not much more than loading a module that configure
EasyBuild for local installations and running EasyBuild with a few recipes that
can be supplied by the LUMI User Support Team or your national support team or that
you may write yourself.

*Before continuing to read this page, make sure you are familiar with the
[setup of the software stacks on LUMI][softwarestacks] and somewhat familiar with
[the Lmod module environment][Lmod_modules].*


## Beginner's guide to installing software on LUMI

We support installing software with EasyBuild only in the LUMI software stacks,
not in CrayEnv.

By default our EasyBuild setup will install software in `$HOME/EasyBuild`. However,
this location can be changed by pointing the environment variable `EBU_USER_PREFIX`
to the directory where you want to create the software installation. In most cases
a subdirectory in your `/project/project_*` directory is the best location to install
software as that directory is both permanent for the duration of your project and
shared with all users in your project so that everybody can use the software. It is
a very good idea to set this environment variable in your `.profile` or `.bashrc`file.
E.g.,
```bash
export EBU_USER_PREFIX=/project/project_465000000/EasyBuild
```

??? Tip "Tip for users with multiple projects"
    If you participate
    in multiple projects, you'll have to either have only a very personal software
    setup in your home directory which noone else can use, or a setup in each of the
    project directories as sharing of project directories across projects is not possible.
    Our modules can also support only one user software setup at a time. However, you can
    always switch to a different setup by changing the value of the `EBU_USER_PREFIX`
    environment variable, but you should only do so when no modules are loaded,
    not even the `LUMI` module. Hence you should always do a
    ```bash
    module --force purge
    ```
    of at the very least
    ```bash
    module --force unload LUMI
    ```
    immediately before changing the value of `EBU_USER_PREFIX`. If you fail to do so,
    the old user module directories will not be removed from the module search path,
    not even if you reload the `LUMI` module, and you may get very unexpected results
    from module load operations.

From now on you will also see the software that you have installed yourself for the
selected version of the LUMI software stack and partition when you do `module avail`,
and `module spider` will also search those directories.

The second step is to ensure that the right version of the software stack is loaded.
Assume that we want to install software in the `LUMI/21.08` stack, then one needs to
execute
```bash
module load LUMI/21.08
```
This should also automatically load the right `partition` module for the part of LUMI
you are on. See also the [page on the software stacks][softwarestacks].

??? Failure "Issue: Only partition/L and partition/C are currently supported"
    Note that in the initial version of the software stack, only `partition/L`
    and `partition/C` are supported.

Though it is technically possible to cross-compile software for a different partition,
it may not be without problems as not all install scripts that come with software
support cross-compiling and as tests may fail when compiling for a CPU with instructions
that the host CPU does not support.

The next step to install software in the directory you have just indicated, is to load
the `EasyBuild-user` module:
```bash
module load EasyBuild-user
```
This will print a line on the screen indicating were software will be installed as
a confirmation. It will also create the directory structure for the user software
installation if it does not yet exist, including the structure of the user repository
discussed below in the ["Advanced guide"](#advanced-guide-to-easybuild-on-lumi),
section ["Building your own EasyBuild repository"](#building-your-own-easybuild-repository).
If you want more information about the full configuration of
EasyBuild, you can execute
```bash
eb --show-config
```

Now an EasyBuild build recipe is a file with a name that consists of different
components. Consider, e.g., the build recipe
```
GROMACS-2021-cpeGNU-21.08-PLUMED-2.7.2-CPU.eb
```
The first part of the name, `GROMACS`, is the name of the package. The second
part of the name, `2021` is the version of GROMACS, in this case the initial
2021 release. The next part, `cpeGNU-21.08`, denotes the so-called * toolchain*
used for the build. The `cpeGNU` toolchain uses the `PrgEnv-gnu` programming
environment, the `cpeCray` toolchain the `PrgEnv-cray` PE and the `cpeAMD`
toolchain the `PrgEnv-aocc` environment. The version of the toolchain should
match the version of the LUMI software stack or the installation will fail.
(In fact, it is not just the version in the file name that should match but
the version of the toolchain that is used in the recipe file.) The next part
of the name, `-PLUMED-21.7.2-CPU`, is called the version suffix. Version suffixes
are typically used to distinguish different builds of the same version of the
package. In this case, it indicates that it is a build of the 2021 version
purely for CPU and also includes PLUMED as we have also builds without
PLUMED (which is not compatible with every GROMACS version).

EasyBuild is configured so that it searches the current directory, the user
repository and two repositories on the system so if all needed EasyBuild
recipes are in one of those repository or in the current
directory, all you need to do to install the package is to run
```bash
eb -r GROMACS-2021-cpeGNU-21.08-PLUMED-2.7.2-CPU.eb
```
The `-r` tells EasyBuild to also install dependencies that may not yet be installed,
and should be omitted if you want full control and install dependency by dependency
before installint the package (which may be very useful if building right away fails).

If you now type `module avail` you should see the
```
GROMACS/2021-cpeGNU-21.08-PLUMED-2.7.2-CPU
```
module in the list. Note the relation between the name of the EasyBuild recipe and
the module name and version of the module. This is only the case though if the EasyBuild
recipe follows the EasyBuild guidelines for naming. If the guidelines are not followed
and if EasyBuild needs to install this module as a dependency of another package,
EasyBuild will fail to locate the build recipe.


## Advanced guide to EasyBuild on LUMI


### Toolchains on Cray

Toolchains in EasyBuild contains at least a compiler, but can also contains an MPI
library and a number of mathematical libraries (BLAS, LAPACK, ScaLAPACK and a FFT
library). Programs compiled with different toolchains cannot be loaded together
(though the module system will not always prevent this on LUMI).

The toolchains on LUMI are different of what you may be used from non-Cray systems.
On most systems, EasyBuild uses its own toolchains installed from within EasyBuild,
but on LUMI we use toolchains that are based on the Cray Programming Environment.
Three toolchains are currently implemented

  - `cpeGNU` is the equivalent of the Cray `PrgEnv-gnu` programming environment
  - `cpeCray` is the equivalent of the Cray `PrgEnv-cray` programming environment
  - `cpeAMD` is the equivalent of the Cray `PrgEnv-aocc` programming environment

All three toolchains use `cray-mpich` over the Open Fabric Interface library
(`craype-network-ofi`) and Cray LibSci for the mathematical libraries, with the
releases taken from the Cray PE release that corresponds to the version number of the
`cpeGNU`, `cpeCray` or `cpeAMD` module.

??? note "cpeGNU/Cray/AMD and PrgEnv-gnu/cray/aocc"
    Currently the `cpeGNU`, `cpeCray` and `cpeAMD` modules don't load the corresponding
    `PrgEnv-*` modules nor the `cpe/<version>` modules. This is because in the current
    setup of LUMI both modules have their problems and the result of loading those
    modules is not always as intended.

    If you want to compile software that uses modules from the LUMI stack, it is best
    to use one of the `cpeGNU`, `cpeCray` or `cpeAMD` modules to load the compiler
    and libraries rather than the matching `cpe/<version>` and `PrgEnv-*` modules as those may
    not always load all modules in the correct version.

Since the LUMI software stack does not support the EasyBuild common toolchains (such
as the EasyBuild intel and foss toolchains) one cannot use the default EasyBuild build
recipes without modifying them. Hence they are not included in the robot search path
of EasyBuild so that you don't accidentally try to install them, but it is possible
to search for packages in that repository also using `eb -S` and `eb --search`.


### Building your own EasyBuild repository

We advise users to maintain their own repository of EasyConfig files which they installed
in their personal or project space. This may help to rebuild your environment for a
later project on LUMI. It may even be a good idea to keep the repository on a personal
GitHub or other version control service.

The repository is created automatically the first time `EasyBuild-user` is loaded.
The directory is called `UserRepo` and is in `$EBU_USER_PREFIX` (or
the default location `$HOME/EasyBuild` if you don't set the environment variable).
It must be structured similarly to
[the main EasyBuild EasyConfig repository](https://github.com/easybuilders/easybuild-easyconfigs).
The EasyBuild recipes (`.eb` files) should be in a subdirectory `easybuild/easyconfigs`,
leaving room for personal EasyBlocks also (which would then go in the
`easybuild/easyblocks` subdirectory) and even personal configuration files that overwrite
some system options. This setup also guarantees compatibility with some EasyBuild features
for very advanced users that go way beyond this page.

To store this repository on GitHub, you can follow the GitHub documentation, and in
particular the page ["Adding an existing project to GitHub using the command line](https://docs.github.com/en/github/importing-your-projects-to-github/importing-source-code-to-github/adding-an-existing-project-to-github-using-the-command-line).

Technical documentation on the toolchains on LUMI and the directory structure of EasyBuild
can be found in
[the documentation of the LUMI-SoftwareStack GitHub repository](https://github.com/Lumi-supercomputer/LUMI-SoftwareStack/tree/main/docs).


## Further reading

If you want to get more familiar with EasyBuild and develop your own EasyBuild recipes,
we suggest the following sources of information:

  - [EasyBuild manual on ReadtheDocs](https://docs.easybuild.io/)
  - [EasyBuild tutorials](https://easybuilders.github.io/easybuild-tutorial/)
  - The [EasyBuild YouTube channel](https://www.youtube.com/channel/UCqPyXwACj3sjtOho7m4haVA)
    contains recordings of a four-session tutorial
    given for the LUMI User Support Team by Kenneth Hoste (UGent), the lead developer
    of EasyBuild and Luca Marsella (CSCS)
      - [Part 1: Introduction](https://www.youtube.com/watch?v=JTRw8hqi6x0)
      - [Part 2: Using EasyBuild](https://www.youtube.com/watch?v=C3S8aCXrIMQ)
      - [Part 3: Advanced topics](https://www.youtube.com/watch?v=KbcvHa4uO1Y)
      - [Part 4: EasyBuild on Cray systems](https://www.youtube.com/watch?v=uRu7X_fJotA)
  - [Technical documentation on our setup for developers](https://github.com/Lumi-supercomputer/LUMI-SoftwareStack/tree/main/docs)
  - LUMI EasyBuild recipes
      - [Main LUMI software stack GitHub repository](https://github.com/Lumi-supercomputer/LUMI-SoftwareStack)
        contains the full EasyBuild setup for LUMI, including the EasyBuild recipes
        that we use for the central software stack and many others that we fully support
        and consider of good quality. The clone on the system is automatically searched
        by the `EasyBuild-user` module.
      - [LUMI contributed EasyBuild recipes GitHub repository](https://github.com/Lumi-supercomputer/LUMI-EasyBuild-contrib)
        contains contributed EasyBuild recipes and other recipes developed by LUST
        that haven't been as thoroughly checked or are deemed not appropriate for central
        installation at this point. However, they are fully compatible with the setup
        on LUMI, with correct dependency versions etc.
  - Other EasyBuild recipes for the Cray Programming Environment
      - [CSCS GitHub repository](https://github.com/eth-cscs/production).
        Most of the recipes are for Piz Daint which uses slightly different toolchains.
        Moreover dependencies typically need updating as the software installation
        on LUMI is not in sync with the CSCS installation. The repository is particularly
        useful for CPU-only programs as the GPUs in their system are not compatible
        with those in LUMI.
