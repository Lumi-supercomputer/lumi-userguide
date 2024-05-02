# EasyBuild

[Lmod_modules]: ../../runjobs/lumi_env/Lmod_modules.md
[softwarestacks]: ../../runjobs/lumi_env/softwarestacks.md
[helpdesk]: ../../helpdesk/index.md
[lumi-g]: ../../hardware/lumig.md
[eap]: ../../hardware/compute/eap.md
[software-library]: https://lumi-supercomputer.github.io/LUMI-EasyBuild-docs

Most software in the central LUMI [software stacks][softwarestacks] is
installed through [EasyBuild](https://easybuild.io/). The central software
stack is kept as compact as possible to ease maintenance and to avoid user
confusion. E.g., packages for which users request special customisations will
never be installed in the central software stack. Moreover, due to the
technical implementation of a software stack on a system the size of LUMI,
some software maintenance operations in the stack can be disruptive and
only be done during system maintenance intervals, making maintenance 
difficult.

This, however, does not mean that you may have to wait for weeks before you can
get the software you need for your project on LUMI. We have made it very easy to
install additional software in your home or project directories (where the
latter is a better choice as you can then share it with the other people in your
project). After installing, using the software requires not much more than loading a module
that configures EasyBuild for local installations and running EasyBuild with a
few recipes that can be supplied by the [User Support Team][helpdesk] or your
national support team or that you may write yourself. And this software is then
built in exactly the same way as it would be in a central installation.

*Before continuing to read this page, make sure you are familiar with the
[setup of the software stacks on LUMI][softwarestacks] and somewhat familiar
with [the Lmod module environment][Lmod_modules].*

## Beginner's guide to installing software on LUMI

*If you are new to EasyBuild and LUMI, it might be a good idea to first read 
through this chapter once, and then start software installations.*

We support installing software with EasyBuild only in the LUMI software stacks,
not in CrayEnv.


### EasyBuild recipes

EasyBuild installs software through recipes that give instructions to create a single
module that most of the time provides a single package.
It will also tell EasyBuild which other modules a package depends on,
so that these can also be installed automatically if needed (through their own EasyBuild recipes).

An EasyBuild build recipe is a file with a name that consists of different
components and ends with '.eb'. Consider, e.g., a build recipe for the software GROMACS:

```text
GROMACS-2022.5-cpeGNU-23.09-PLUMED-2.9.0-noPython-CPU.eb
```

The first part of the name, `GROMACS`, is the name of the package. The second
part of the name, `2022.5` is the version of GROMACS, in this case the
2021.4 release. 

The next part, `cpeGNU-23.09`, denotes the so-called *toolchain*
used for the build. Each toolchain corresponds to a particular HPE Cray Programming
Environment, and the number (`23.09`in this example) denotes the version of this
programming environment. The various EasyBuild toolchains on LUMI are:

| EasyBuild toolchain | HPE Cray PE                                                    |
|---------------------|----------------------------------------------------------------|
| `cpeGNU`            | `PrgEnv-gnu` (GNU compilers)                                   |
| `cpeCray`           | `PrgEnv-cray` (HPE Cray's own compilers)                       |
| `cpeAMD`            | `PrgEnv-amd` (AMD compilers for AMD GPU systems, part of ROCm) |
| `cpeAOCC`           | `PrgEnv-aocc` (AMD compilers for CPU-only systems)             |

The version number of the toolchain should match the version
of the LUMI software stack or the installation will fail. (In fact, it is not
just the version in the file name that should match but the version of the
toolchain that is used in the recipe file.) 

The last part of the name,
`-PLUMED-2.9.0-noPython-CPU`, is called the version suffix. Version suffixes are
typically used to distinguish different builds of the same package version.
In this case, it indicates that it is a build of the 2022.5 version
purely for CPU and also includes PLUMED as we have also builds without PLUMED
(which is not compatible with every GROMACS version).

EasyBuild build recipes are stored in repositories with a fixed directory 
structure. On LUMI we already provide two such repositories,
one containing all the software that is installed in the central software
stack and one that contains EasyBuild recipes that users can install
themselves or use as a basis to make a customised installation of software.
An overview of all recipes in these repositories is provided in the
[LUMI Software Library][software-library].

We encourage advanced users to also build up a user repository with their
own EasyBuild recipes and manage it with a version control system as
that will provide a good description of the software stack that was 
used for a project and is a good step towards reproducibility. 
This is discussed below in the ["Advanced
guide"](#advanced-guide-to-easybuild-on-lumi), section ["Building your own
EasyBuild repository"](#building-your-own-easybuild-repository).


### Preparation: Set the location for your EasyBuild installation

By default, our EasyBuild setup will install software in `$HOME/EasyBuild`.
However, this location can be changed by pointing the environment variable
`EBU_USER_PREFIX` to the directory where you want to create the software
installation. In most cases a subdirectory in your `/project/project_*`
directory is the best location to install software as that directory is both
permanent for the duration of your project and shared with all users in your
project so that everybody can use the software. It is a great idea to set
this environment variable in your `.profile` or `.bashrc`file, e.g.

```bash
export EBU_USER_PREFIX=/project/project_465000000/EasyBuild
```

(replacing 465000000 with the number of your project).

??? Tip "Tip for users with multiple projects"
    If you participate in multiple projects, you'll have to either have only
    a very personal software setup in your home directory which no one else can
    use, or a setup in each of the project directories, as sharing of project
    directories across projects is not possible. Our modules can also support
    only one user software setup at a time. However, you can always switch to
    a different setup by changing the value of the `EBU_USER_PREFIX`
    environment variable, but you should only do so when no modules are loaded,
    not even the `LUMI` module. Hence, you should always do a

    ``` bash
    $ module --force purge
    ```
    
    of at the very least
    
    ``` bash
    $ module --force unload LUMI
    ```
    
    immediately before changing the value of `EBU_USER_PREFIX`. If you fail to
    do so, the old user module directories will not be removed from the module
    search path, not even if you reload the `LUMI` module, and you may get very
    unexpected results from module load operations.

??? Failure "Do not change `EBU_USER_PREFIX` when a `LUMI` module is loaded"
    Changing the value of `EBU_USER_PREFIX` while one of the `LUMI` modules
    is loaded has side effects. When switching to a different version of the
    `LUMI` module or reloading the current module to enable the new installation
    directory, the module system will fail to first properly clean the
    old user installation directories from the module search path, even when
    using `module --force purge`. This is a side effect of how Lmod works when
    unloading modules. There is no easy workaround for this.

    However, doing a `module --force unlod LUMI` first and then changing the
    value of `EBU_USER_PREFIX` and then reloading a `LUMI` module will work.

From now on you will also see the software that you have installed yourself for
the selected version of the LUMI software stack and partition when you do
`module avail`. Also, `module spider` will also search those directories.


### Step 1: Load the LUMI software stack

The next step is to ensure that the right version of the software stack is
loaded. Assume that we want to install software in the `LUMI/23.09` stack, then
one needs to execute

``` bash
$ module load LUMI/23.09
```

This should also automatically load the right `partition module` for the part
of LUMI you are on, as further detailed on the [software
stacks][softwarestacks] page.

Though it is technically possible to cross-compile software for a different
partition, this may not be problem-free. 

Not all install scripts that come with software do support cross-compiling and
as tests may fail when compiling for a CPU with instructions that the host CPU 
does not support.

Cross-compiling for the GPU nodes is particularly troublesome as the configuration
step will not be able to detect the correct GPU type should it try to do so.

### Step 2: Load EasyBuild

The next step to install software in the directory you have just indicated, is
to load the `EasyBuild-user` module:

```bash
$ module load EasyBuild-user
```

This will print a line on the screen indicating where software will be installed
as a confirmation. It will also create the directory structure for the user
software installation if it does not yet exist, including the structure of the
user repository discussed below in the ["Advanced
guide"](#advanced-guide-to-easybuild-on-lumi), section ["Building your own
EasyBuild repository"](#building-your-own-easybuild-repository). If you want
more information about the full configuration of EasyBuild, you can execute

```bash
$ eb --show-config
```

EasyBuild is configured so that it searches in the user repository and two
repositories on the system. The current directory is not part of the default
search path but can be easily added with a command line option. By default,
EasyBuild will not install dependencies of a package and fail instead, if one or
more of the dependencies cannot be found, but that is also easily changed on
the command line. 

### Step 3: Install the package

To show how to actually install a package, we continue with our
`GROMACS-2022.5-cpeGNU-23.09-PLUMED-2.9.0-noPython-CPU.eb` example.

If all needed EasyBuild recipes are in one of the
repositories, all you need to do to install the
package is to run

```bash
$ eb GROMACS-2022.5-cpeGNU-23.09-PLUMED-2.9.0-noPython-CPU.eb -r
```

The `-r` tells EasyBuild to also install dependencies that may not yet be
installed.

If the `GROMACS-2022.5-cpeGNU-23.09-PLUMED-2.9.0-noPython-CPU.eb` would not have been
in a repository, but in the current directory or one of its subdirectories,
you could use 

```bash
$ eb GROMACS-2022.5-cpeGNU-23.09-PLUMED-2.9.0-noPython-CPU.eb -r .
```

The only difference is the dot added to the `-r` flag. This adds the current directory to
the front of the search path. In general, it doesn't hurt to always use the dot with `-r`,
but performance may suffer if the current directory contains a lot of subdirectories they
will all be searched for EasyBuild recipes.

The `-r .` or `-r` flags should be omitted if you
want full control and install dependency by dependency before installing the
package (which may be handy if building right away fails).

If you now type `module avail` you should see the

```text
GROMACS/2022.5-cpeGNU-23.09-PLUMED-2.9.0-noPython-CPU
```

module in the list. Note the relation between the name of the EasyBuild recipe
and the module name and version of the module. This is only the case though if
the EasyBuild recipe follows the EasyBuild guidelines for naming. If the
guidelines are not followed and if EasyBuild needs to install this module as a
dependency of another package, EasyBuild will fail to locate the build recipe.

The `GROMACS/2022.5-cpeGNU-23.09-PLUMED-2.9.0-noPython-CPU` module can now be used just like
any other module on the system. To *use* the GROMACS module, you don't need to load `EasyBuild-user`.
That was only required for *installing* the package. 
All you need to do to use the GROMACS module we just installed is 

```bash
module load LUMI/23.09
module load GROMACS/2022.5-cpeGNU-23.09-PLUMED-2.9.0-noPython-CPU
```

(i.e., loading the software stack in which we installed GROMACS and the GROMACS module that 
we installed).


### A special case: Modules for singularity containers

We provide some EasyConfigs to build modules for singularity containers that we provide 
elsewhere on the system. These are marked in the [LUMI Software Library][software-library]
with a "C" on a purple background in the list and a "singularity container" label on the
page for the specific package. 

These EasyConfigs will copy the container to a safe place in your user installation so that
you can keep it if reproducibility is a concern for you. They will also install modules that
define some standard variables that make it easy to locate the container and set the
appropriate bindings for the `singularity` command. 
Some of the container modules also provide some wrapper scripts that make it easier to
work with the container or can serve as an example for your own scripts to use the
software in the container.

In many cases, the singularity container file in your own directory space can be removed
and the module will automatically pick up the central one. However, check the documentation
for the package in the [LUMI Software Library][software-library], it will tell you if you can do so.

Do keep in mind though that the centrally stored container file will be removed if we find problems
 with it, while the container may still be perfectly fine for you. E.g., some containers
provide the RCCL communication library which is popular in AI applications, but requires a 
specific plugin to work well with the Slingshot 11 interconnect of LUMI. These containers often
need to be rebuilt after a system upgrade, but they may still be perfectly fine for users who use
only a single GPU or a single GPU node. If you want to keep using the older version though, it has 
to be installed in your own file space.

The containers we provide do in general not depend on any specific version of the Cray 
Programming Environment and hence also not on a specific version of the LUMI software stack.
Hence, LUMI provides a mechanism to install the container modules in a place where they will 
be found by all partitions of all LUMI stacks and by the CrayEnv stack. To this end, you can 
install in the dummy partition `partition/container`, e.g.,

```
module load LUMI partition/container EasyBuild-user
eb <container-easyconfig.eb>
```

Note that to subsequently use the container you do not need to load `partition/common` or 
`EasyBuild-user`.

Many containers come with documentation about their use. We encourage you to check
the documentation in the [LUMI Software Library][software-library] for the containers,
and to check the help provided by the module after installation (with `module help`
or `module spider`).


### Some common problems

1.  **`module avail` does not show the module.**

    There are two possible causes for this.

    1.  Lmod builds a cache of all modules on the system. EasyBuild will clear the cache 
        so that it will be rebuilt after installing a software package and hence the 
        newly installed modules should be found. In rare cases, Lmod may be in a corrupt
        state. In those cases the best solution is to clear the cache (unless it happens
        right after running the `eb` command to install a module): 

        ```bash
        rm -rf ~/.lmod.d/.cache
        ```

        and to log out and log in again to start with a clean shell.

    2.  If the problem occurs later on, e.g., while running a job, then a common cause is that
        you have a different version of the `LUMI` and/or `partition` modules loaded than used when
        installing the software package.

        Note that even the LUMI CPU compute nodes have a newer processor than the login nodes and
        may benefit from processor-specific optimizations which is why they use a different `partition`
        module. If you load one of the versions of the `LUMI` module on the login nodes, it will 
        automatically load `partition/L` while if you do the load on a regular LUMI-C compute node,
        it will load `partition/C`.

        In the example above, if the installation commands
        were executed on the login node, the software would have been installed in `partition/L`,
        but if we then do a `module load LUMI/23.09` on the compute nodes, `partition/C` would have been
        selected. To get a GROMACS version in `partition/C` that EasyBuild would build with compiler settings
        that are specific for the processors in the compute nodes, either do the compilation on a compute node
        or use *cross-compiling* by loading `partition/C` after loading `LUMI/23.09` in step 1 above.

2.  **EasyBuild complains that some modules are already loaded.**

    EasyBuild prefers to work in a clean environment with no modules loaded that are installed via EasyBuild
    except for a very select list. It will complain if other modules are loaded (though only fail if a module
    for one of the packages that you try to install is already loaded).
    It is best to take this warning seriously and to install in a relatively clean shell,
    as otherwise the installation process may pick up software libraries that it should not have used.


## Advanced guide to EasyBuild on LUMI

### Toolchains on Cray

Toolchains in EasyBuild contain at least a compiler, but can also contain an
MPI library and a number of mathematical libraries (BLAS, LAPACK, ScaLAPACK and
an FFT library). Programs compiled with different toolchains cannot be loaded
together (though the module system will not always prevent this on LUMI).

The toolchains on LUMI are different from what you may be used to from non-Cray
systems. On most systems, EasyBuild uses its own toolchains installed from
within EasyBuild, but on LUMI we use toolchains that are based on the Cray
Programming Environment. Four toolchains are currently implemented

- `cpeGNU` is the equivalent of the Cray `PrgEnv-gnu` programming environment
- `cpeCray` is the equivalent of the Cray `PrgEnv-cray` programming environment
- `cpeAOCC` is the equivalent of the Cray `PrgEnv-aocc` programming environment
- `cpeAMD` is the equivalent of the Cray `PrgEnv-amd` programming environment

All four toolchains use `cray-mpich` over the Open Fabric Interface library
(`craype-network-ofi`) and Cray LibSci for the mathematical libraries, with the
releases taken from the Cray PE release that corresponds to the version number
of the `cpeGNU`, `cpeCray`, `cpeAOCC`, or `cpeAMD` module.

??? note "cpeGNU/Cray/AOCC/AMD and PrgEnv-gnu/cray/aocc/amd"
    Currently the `cpeGNU`, `cpeCray`, `cpeAOCC`, and `cpeAMD` modules don't
    load the corresponding `PrgEnv-*` modules nor the `cpe/<version>` modules.
    This is because in the current setup of LUMI, both modules have their
    problems and the result of loading those modules is not always as intended.

    If you want to compile software that uses modules from the LUMI stack,
    it is best to use one of the `cpeGNU`, `cpeCray`, `cpeAOCC`, or `cpeAMD`
    modules to load the compiler and libraries rather than the matching
    `cpe/<version>` and `PrgEnv-*` modules as those may not always load
    all modules in the correct version.

Since the LUMI software stack does not support the EasyBuild common toolchains
(such as the EasyBuild intel and foss toolchains), one cannot use the default
EasyBuild build recipes without modifying them. Hence, they are not included in
the robot search path of EasyBuild so that you don't accidentally try to
install them (and also removed from the search path for `eb -S` or `eb
--search` to avoid any confusion that they might work).

### Building your own EasyBuild repository

We advise users to maintain their own repository of EasyConfig files which they
installed in their personal or project space. This may help to rebuild your
environment for a later project on LUMI. It may even be a good idea to keep the
repository on a personal GitHub or other version control service.

The repository is created automatically the first time `EasyBuild-user` is
loaded. The directory is called `UserRepo` and is in `$EBU_USER_PREFIX` (or the
default location `$HOME/EasyBuild` if you don't set the environment variable).
It must be structured similarly to [the main EasyBuild EasyConfig
repository](https://github.com/easybuilders/easybuild-easyconfigs). The
EasyBuild recipes (`.eb` files) should be in a subdirectory
`easybuild/easyconfigs`, leaving room for personal EasyBlocks also (which would
then go in the `easybuild/easyblocks` subdirectory) and even personal
configuration files that overwrite some system options. This setup also
guarantees compatibility with some EasyBuild features for very advanced users
that go way beyond this page.

To store this repository on GitHub, you can follow the GitHub documentation,
and in particular the page ["Adding an existing project to GitHub using the
command
line"](https://docs.github.com/en/github/importing-your-projects-to-github/importing-source-code-to-github/adding-an-existing-project-to-github-using-the-command-line).

Technical documentation on the toolchains on LUMI and the directory structure
of EasyBuild can be found in [the documentation of the LUMI-SoftwareStack
GitHub repository](https://lumi-supercomputer.github.io/LUMI-SoftwareStack/).

## Further reading

If you want to get more familiar with EasyBuild and develop your own EasyBuild
recipes, we suggest the following sources of information:

- [EasyBuild documentation](https://docs.easybuild.io/)
- [EasyBuild tutorials](https://tutorial.easybuild.io)
    - [Tutorial specific for LUMI](https://klust.github.io/easybuild-tutorial/2022-CSC_and_LO/)
- The [EasyBuild YouTube channel](https://www.youtube.com/@easybuilders)
  contains recordings of a four-session tutorial
  given for the LUMI User Support Team by Kenneth Hoste (UGent), the lead developer
  of EasyBuild and Luca Marsella (CSCS)
    - [Part 1: Introduction](https://www.youtube.com/watch?v=JTRw8hqi6x0)
    - [Part 2: Using EasyBuild](https://www.youtube.com/watch?v=C3S8aCXrIMQ)
    - [Part 3: Advanced topics](https://www.youtube.com/watch?v=KbcvHa4uO1Y)
    - [Part 4: EasyBuild on Cray systems](https://www.youtube.com/watch?v=uRu7X_fJotA)
- [Technical documentation on our setup for developers](https://lumi-supercomputer.github.io/LUMI-SoftwareStack/)
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
    - [LUMI EasyBuild container installation recipes GitHub repository](https://github.com/Lumi-supercomputer/LUMI-EasyBuild-containers)
      contains the recipes that are used to ease access to the containers that are in `/appl/local/containers`.
    - But a more user-friendly overview of all those recipes is available in the
      [LUMI Software Library][software-library].
- Other EasyBuild recipes for the Cray Programming Environment
    - [CSCS GitHub repository](https://github.com/eth-cscs/production).
      Most of the recipes are for Piz Daint which uses slightly different toolchains.
      Moreover dependencies typically need updating, as the software installation
      on LUMI is not in sync with the CSCS installation. The repository is particularly
      useful for CPU-only programs as the GPUs in their system are not compatible
      with those in LUMI.
- EasyBuild recipes that are not compatible with the Cray Programming Environment but that
  may sometimes be a good source to start developing compatible ones (if you're an
  EasyBuild expert):
    - [EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs),
      the repository of EasyConfig files that also come with EasyBuild.
    - [ComputeCanada repository](https://github.com/ComputeCanada/easybuild-easyconfigs)
    - [IT4Innovations repository](https://code.it4i.cz/sccs/easyconfigs-it4i)
    - [Fred Hutchinson Cancer Research Center repository](https://github.com/FredHutch/easybuild-life-sciences/tree/main/fh_easyconfigs)
    - [University of Antwerpen repository](https://github.com/hpcuantwerpen/UAntwerpen-easyconfigs)
    - [University of Leuven repository](https://github.com/hpcleuven/easybuild-easyconfigs/tree/master/easybuild/easyconfigs)
