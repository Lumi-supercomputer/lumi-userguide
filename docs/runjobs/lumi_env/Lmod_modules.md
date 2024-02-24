# Modules Environment

[lmod]: https://lmod.readthedocs.io/
[lmod_collection]: https://lmod.readthedocs.io/en/latest/010_user.html#user-collections
[lmod_doc]: https://lmod.readthedocs.io/en/latest/index.html

[softwarestacks]: ../../runjobs/lumi_env/softwarestacks.md

!!! tip
    If you are already somewhat familiar with modules from your home system,
    you may get more from this page if you first read our
    [page on the available software stacks][softwarestacks].
    However, if you are not very familiar with modules, it may be best to first read this
    page, then the one on [the software stacks][softwarestacks] and then
    re-read this page as you will get more information out of it.

Software on LUMI can be accessed through modules. With the help of the `module`
command, you will be able to load and unload the desired compilers, tools and
libraries.

Software modules allow you to control which software and versions are available
in your environment. Modules contain the necessary information to allow you to
run a particular application or provide you access to a particular library so
that

- different versions of a software package can be provided.
- you can easily switch to different versions without having to explicitly
  specify different paths.
- you don't have to deal with dependent modules, they are loaded at the same
  time as the software.

Almost all compute clusters use software modules. Currently, there are three
competing implementations, so you may not be familiar with Lmod yet. And
even if you are already familiar with Lmod in your home cluster, we still
encourage you to read through this page as not all sites promote the same Lmod
features.

??? Info "Which module system am I using?"
    There are currently three different popular implementations of modules:

     - Environment Modules version 3.X which uses modules written in Tcl but itself
       is written in C. This version is no longer maintained, but is one of the
       systems offered on Cray systems.
     - [Environment Modules version 4.X and 5.X](http://modules.sourceforge.net/)
       which is a continuation of the Tcl modules but now entirely written
       in Tcl itself. It is developed at CEA in France.
     - [Lmod][lmod] uses module files written in Lua and itself is also written
       in Lua. It is compatible with many Tcl module files (from both versions
       of Environment Modules) through an automatic translation layer. Lmod is
       developed at TACC.

    You can see which version of modules your home cluster is using by executing
    ```bash
    module --version
    ```
    at the command prompt. For the old environment modules,
    the output will start with `VERSION=3.2.11` or something similar, for the
    new Environment Modules it will report as `Modules Release 4.X` or
    `Modules Release 5.x` or something similar, and for Lmod it will explicitly
    say `Modules based on Lua`.

## The `module` command

Modules are managed by the `module` command:

```bash
$ module <sub-command> <module-name>
```

where the _sub-command_ indicates the operation you want to perform. The
_sub-command_ is followed by the name of the module on which you want to perform
the operation.

| Sub-command      | Description                                          |
| -----------------|------------------------------------------------------|
| `spider`         | Search for modules and display help                  |
| `keyword`, `key` | Search for modules based on keywords                 |
| `avail`, `av`    | List available modules                               |
| `whatis`         | Display short information about modules              |
| `help`           | Print the help message of a module                   |
| `list`           | List the currently modules loaded                    |
| `load`, `add`    | Load a module                                        |
| `unload`         | Remove a module from your environment                |
| `purge`          | Unload all modules from your environment             |
| `show`           | Show the commands in the module's definition file    |

## Finding modules

Lmod is a hierarchical module system. It distinguishes between installed modules
and available modules. Installed modules are all modules that are installed on
the system. Available modules are all modules that can be loaded directly at
that time without first loading other modules. The available modules are often
only a subset of the installed modules. However, Lmod can tell you for each
installed module what steps you must take to also make it available so that
you can load it. Therefore, the commands for finding modules are so important.

Some modules may also provide multiple software packages or extensions. Lmod can
also search for these.


### module spider

The basic command to search for software on LUMI is `module spider`.
It has three levels, producing different outputs:

 1. `module spider` without further arguments will produce a list of all
    installed software and show some basic information about those packages.
    Some packages may have an `(E)` behind their name and will appear in blue
    (in the default color scheme) which means that they are part of a different
    package. The following levels of `module spider` will then tell you how to
    find which module(s) to load.

    Note that `module spider` will also search in packages that are hidden from
    being displayed. These packages can be loaded and used. However, we hide them
    either because they are not useful to regular users or because we think that
    they will rarely or never be directly loaded by a user and want to avoid
    overloading the module display.

 2. `module spider <name of package>` will search for the specific package. This
    can be the name of a module, but it will also search some other information
    that can be included in the modules. The search is case-insensitive, e.g.

    ```bash
    $ module spider GNUplot
    ```

    will show something along the lines of

    ```text
    ----------------------------------------------------------------
      gnuplot:
    ----------------------------------------------------------------
        Description:
          Gnuplot is a portable command-line driven graphing
          utility

         Versions:
            gnuplot/5.4.3-cpeAMD-22.08
            gnuplot/5.4.3-cpeAOCC-21.12
            gnuplot/5.4.3-cpeAOCC-22.08
            gnuplot/5.4.3-cpeCray-21.12
            gnuplot/5.4.3-cpeCray-22.06
            gnuplot/5.4.3-cpeCray-22.08
            ...
    ```

    (abbreviated output) so even though the capitalization of the name was wrong, it can tell us that
    there are multiple versions of gnuplot. The `cpeAOCC-22.08` and `cpeCray-22.06`
    tell that the difference is the compiler that was used to install gnuplot,
    being the AMD AOCC compiler (PrgEnv-aocc) and the Cray compiler (PrgEnv-cray),
    respectively. This is somewhat important as it is risky to combine modules
    compiled with different compilers.

    Similarly,

    ```bash
    $ module spider CMake
    ```

    returns an output along the lines of

    ```text
    ----------------------------------------------------------------
      CMake:
    ----------------------------------------------------------------
         Versions:
            CMake/3.22.2 (E)
            CMake/3.23.2 (E)
            CMake/3.24.0 (E)
            CMake/3.25.2 (E)
            CMake/3.27.7 (E)

    Names marked by a trailing (E) are extensions provided by 
    another module.
    ```

    This tells that there is no `CMake` module on the system but that five
    versions of `CMake` (3.22.2, 3.23.2, 3.24.0, 3.25.2 and 3.27.7) 
    are available on the system as
    extensions of another module.

    !!! info "Information on LUMI software stacks?"
        For more information on the software stacks on LUMI, head to the
        [Software stacks ][softwarestacks] page.

    !!! failure "Known issue"
        We have run into cases where the output of the `module spider` 
        command is incomplete. This is caused
        by the non-standard way in which the Cray programming environment uses
        Lmod and also by the way the software stack needs to be installed
        next to the programming environment rather than integrated with it
        due to the way the Cray programming environment has to be installed
        on the system.

    In some cases, if there is no ambiguity, `module spider` will
    already produce help about the package.

 3. `module spider <module name>/<version>` will show more help information
    about the package, including information on which other modules need to be
    loaded to be able to load the package, e.g.

    ```bash
    $ module spider git/2.42.1
    ```

    will return

    ```text
    ----------------------------------------------------------------
      git: git/2.42.1
    ----------------------------------------------------------------
        Description:
          Git is a free and open source distributed version control
          system

        You will need to load all module(s) on any one of the lines 
        below before the "git/2.42.1" module is available to load.

          CrayEnv
          LUMI/23.09  partition/C
          LUMI/23.09  partition/G
          LUMI/23.09  partition/L
    ```

    (abbreviated output). Note that it also tells you which other modules need
    to be loaded. You need to choose the line which is appropriate for you and
    load all modules on that line, not the whole list of e.g., 7 modules.

    This form of `module spider` can also be used to find out how a tool provided
    as an extension by another module can be made available. E.g., in a previous 
    example we've seen that `CMake/3.27.7` is available via another module.
    Now

    ```bash
    $ module spider CMake/3.27.7
    ```

    will return output similar to

    ```text
    ----------------------------------------------------------------
      CMake: CMake/3.27.7 (E)
    ----------------------------------------------------------------
        This extension is provided by the following modules. To 
        access the extension you must load one of the following 
        modules. Note that any module names in parentheses show the 
        module location in the software hierarchy.

           buildtools/23.09 (LUMI/23.09 partition/L)
           buildtools/23.09 (LUMI/23.09 partition/G)
           buildtools/23.09 (LUMI/23.09 partition/C)
           buildtools/23.09 (CrayEnv)
    ```
    This tells that `CMake` is provided by the `buildtools/23.09` module and also 
    indicates four possible combinations of software stack modules that can provide
    that module.


### module keyword

Another search command that is sometimes useful is `module keyword`. It 
just searches for the given word in the short descriptions that are included in
most module files and in the name of the module. The output is not always
complete since not all modules may have a complete enough short description.

Consider we are looking for a library or package that supports MP3 audio
encoding.

```bash
$ module keyword mp3
```

will return something along the lines of

```text
----------------------------------------------------------------

The following modules match your search criteria: "mp3"
----------------------------------------------------------------

  LAME: LAME/3.100-cpeAMD-22.08, LAME/3.100-cpeAMD-22.12, ...
    LAME is a high quality MPEG Audio Layer III (mp3) encoder
```

though the output will depend on the version of Lmod. This may not be the most
useful example on a supercomputer, but the library is in fact needed to be able
to install some other packages even though the sound function is not immediately
useful.

### module avail

The `module avail` command is used to show only available modules, i.e., modules
that can be loaded directly without first loading other modules. It can be used
in two ways:

 1. Without a further argument, it will show an often lengthy list of all
    available modules. Some modules will be marked with `(D)` which means that
    they are the default module that would be loaded should you load the module
    using only its name.

 2. With the name of a module (or a part of the name), it will show all modules
    that match that (part of) a name. E.g., when `LUMI/22.12` is loaded,

    ```bash
    $ module avail gnuplot
    ```

    will show something along the lines of

    ```text
    ----- EasyBuild managed software for software stack LUMI/22.12 on LUMI-L -----
       gnuplot/5.4.6-cpeAOCC-22.12    gnuplot/5.4.6-cpeGNU-22.12 (D)
       gnuplot/5.4.6-cpeCray-22.12

      Where:
       D:  Default Module
    ```

    but

    ```bash
    $ module avail gnu
    ```

    will show you an often lengthy list that contains all packages with gnu
    (case-insensitive) in their name or version.

## Getting help

One way to get help on a particular module has already been discussed on this
page: `module spider <name>/<version>` will produce help about the package as
soon as it can unambiguously determine the package. It is the only command that
can produce help for all installed packages. The next two commands can only
produce help about available packages.

A second command is `module whatis` with the name or name and version of a
module. It will show the brief description of the module that is included in
most modules on the system. If the full version of the module is not given, it
will display the information for the default version of that module.

The third command is `module help`. Without any further argument, it will display
brief help about the module command.
However, when used as `module help <name>` or `module help <name>/<version>`,
it will produce help for either the default version of the package
(if the version is not specified) or the indicated version.

## Loading and unloading modules

Loading and unloading modules in Lmod is very similar to other module systems.
Also, note that only *available* modules can be loaded with the commands below.
Some *installed* modules may only become *available* after first loading other
modules as discussed above.

To load a module, use the `module load` command. For example, to load the Cray
FFTW library, use:

```bash
$ module load cray-fftw
```

This command will load the default version of the module. If the software you
loaded has dependencies, they will be loaded in your environment at the same
time.

To load a specific version of the module, you need to specify it after the name
of the module:

```bash
$ module load cray-fftw/3.3.10.5
```

To unload a module from your environment, use the `unload` sub-command
followed by the name of the module you want to remove.

```
$ module unload cray-fftw
```

In most cases multiple `module load` or `module unload` commands can be combined
in a single `module load` or `module unload` command. One exception to this is
any sequence of loads or unloads involving the `cpe` module from the Cray
Programming Environment as loading or unloading of this module only takes full
effect at the next `module` command.

You can also remove all loaded modules from your environment by using the
`purge` sub-command.

```bash
$ module purge
```

In Lmod, some modules can be declared as sticky modules by the sysadmins. These
modules will not be removed by `module purge` and will produce an error message
when you try to unload them with `module unload`. On LUMI, this is the case for
the modules that activate a software stack so that it is possible to unload all
modules that are loaded in the stack without deactivating the stack. Sticky
modules can still be unloaded or purged by adding the `--force` option, e.g.,

```bash
$ module --force unload LUMI
$ module --force purge
```

Note the position of the `--force` argument.

It is also possible to see the Lmod commands that are executed when loading a
module using `module show`. E.g.,

```bash
$ module load CrayEnv
$ module show cray-fftw
```

will show

```text
-----------------------------------------------------------------------------------------------------
   /opt/cray/pe/lmod/modulefiles/cpu/x86-rome/1.0/cray-fftw/3.3.10.5.lua:
-----------------------------------------------------------------------------------------------------
help([[Release info:  /opt/cray/pe/fftw/3.3.10.5/release_info]])
help([[Documentation: `man intro_fftw3`]])
whatis("FFTW 3.3.10.5 - Fastest Fourier Transform in the West")
setenv("FFTW_VERSION","3.3.10.5")
setenv("CRAY_FFTW_VERSION","3.3.10.5")
setenv("CRAY_FFTW_PREFIX","/opt/cray/pe/fftw/3.3.10.5")
setenv("FFTW_ROOT","/opt/cray/pe/fftw/3.3.10.5/x86_rome")
setenv("FFTW_DIR","/opt/cray/pe/fftw/3.3.10.5/x86_rome/lib")
setenv("FFTW_INC","/opt/cray/pe/fftw/3.3.10.5/x86_rome/include")
setenv("PE_FFTW_PKGCONFIG_VARIABLES","PE_FFTW_OMP_REQUIRES_@openmp@")
setenv("PE_FFTW_OMP_REQUIRES"," ")
setenv("PE_FFTW_OMP_REQUIRES_openmp","_mp")
setenv("PE_FFTW_PKGCONFIG_LIBS","fftw3f_mpi:libfftw3f_threads:fftw3f:fftw3_mpi:libfftw3_threads:fftw3")
prepend_path("PKG_CONFIG_PATH","/opt/cray/pe/fftw/3.3.10.5/x86_rome/lib/pkgconfig")
prepend_path("PATH","/opt/cray/pe/fftw/3.3.10.5/x86_rome/bin")
prepend_path("MANPATH","/opt/cray/pe/fftw/3.3.10.5/share/man")
prepend_path("CRAY_LD_LIBRARY_PATH","/opt/cray/pe/fftw/3.3.10.5/x86_rome/lib")
prepend_path("PE_PKGCONFIG_PRODUCTS","PE_FFTW")
```

The interesting lines are the `setenv` lines which tell which environment
variables will be set and the `prepend_path` lines which tell which directories
will be added to certain PATH-style variables.

## Saving your environment

Sometimes, if you frequently use multiple modules together, it might be useful
to save your environment as a module collection. However, you should do so only
if you fully understand how Lmod works and what is saved as saving environments
is rather fragile in Lmod. E.g., in the LUMI software stack, saving a
collection on the login nodes may not give you the right binaries when working
on one of the types of compute nodes, even though the application modules have
the same name and version. Also, when saving a collection of modules, the full
pathname to each of the module files is saved so *the stored collection will
break if modules have to be moved*. Following a system maintenance interval, 
the stored module configuration is often also broken.

A collection can be created using `save` sub-command.

```bash
$ module save <collection-name>
```

Your saved collections can be listed using the `savelist` sub-command.

```bash
$ module savelist
```

Of course, the main interest of a collection is that you can load all the
modules it contains in one command. This is done using the `restore`
sub-command.

```bash
$ module restore <collection-name>
```

More options to manage collections of modules can be found by running `module
help` or in the [Lmod User Manual][lmod_collection]. Note, however, that the
latter may contain options or commands that do not yet work on the version of
Lmod supported on LUMI.

## Creating and using your own modules

When you install software yourself, it may make life easier if you make it
available through a module. Some software for HPC systems will also produce
modules during the installation process, e.g., the Intel oneAPI compilers
(which are not supported on LUMI).

Lmod supports most Tcl-based module files written for the various versions of
Environment Modules. It also has its own format for module files, which are Lua
programs though with a restricted set of Lua functions available. More
information on developing module files is available in the [Lmod
documentation][lmod_doc]. Even though that documentation is for the latest
version of Lmod, it is likely very relevant for LUMI as the Lmod version 
on LUMI is fairly close to the latest version at the moment.

??? Tip "Tip: Study an existing module file"
    If you want to study an existing module file then `module show <modulename>`
    will also show you where to find the module file.

Adding directories to the search path for modules is done with

```bash
$ module use <directory>
```

Conversely, removing a directory is done with

```bash
$ module unuse <directory>
```

Removing a directory from the module search path will also unload the modules
that are loaded from that directory.

??? Tip "For advanced users: Resetting the MODULEPATH"
    The search path for modules is stored in the environment variable
    `MODULEPATH`. Adding directories to the search path by manipulating
    `MODULEPATH` is possible. However, overwriting the variable and removing
    directories can have nasty side effects and bring the internal data
    structures of Lmod into an inconsistent state, e.g., because there may now be
    modules loaded from directories that are not in the `MODULEPATH`.

    If you want to overwrite `MODULEPATH`, e.g., to build your own private environment
    fully independent from those that LUMI offers, you also need to re-initialise Lmod
    by running

    ```bash
    $ source /usr/share/lmod/lmod/init/bash
    ```

## Further reading

On LUMI, we use the Lmod implementation as provided by HPE Cray as part of the
programming environment. The version of Lmod is way behind the most recent
version. This implies that not all information that can be found on the internet
is also correct for LUMI.

- [Official Lmod documentation on readthedocs][lmod], but this is always for
  the latest version.
