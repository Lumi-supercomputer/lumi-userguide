# Lmod Modules Environment

[softwarestacks]: ./softwarestacks.md

??? info "Not the default during the pilot phase"
    Lmod is not the default module environment on LUMI during the
    early stages of the pilot phase but will be used by the
    [LUMI software stacks](softwarestacks.md).

    It can be enabled by adding the following lines in your .bashrc
    ```bash
    export MODULEPATH=/opt/cray/pe/lmod/modulefiles/core:/opt/cray/pe/lmod/modulefiles/craype-targets/default:/opt/cray/modulefiles:/opt/modulefiles
    source /usr/share/lmod/lmod/init/bash
    eval "module load craype-x86-rome craype-network-ofi craype-accel-host perftools-base xpmem"
    ```

Software modules allow you to control which software and versions are
available in your environment. Modules contain the necessary information to
allow you to run a particular application or provide you access to a
particular library so that

- different versions of a software package can be provided
- you can easily switch to different versions without having to explicitly
  specify different paths
- you don't have to deal with dependent modules, they are loaded at the same time
  as the software

Almost all compute clusters use software modules. Currently there are three
competing implementations, so you may not be familiar with Lmod already.
And even if you are already familiar with Lmod from your home cluster
we still encourage you to read through this page as not all sites promote the
same Lmod features.

??? Info "Which module system am I using?"
    There are currently three different popular implementations of modules:

     - Environment Modules version 3.X which uses modules written in Tcl but itself
       is written in C. This version is no longer maintained, but is one of the
       systems offered on Cray systems.
     - [Environment Modules version 4.X and 5.X](http://modules.sourceforge.net/)
       which is a continuation of the Tcl modules but now entirely written
       in Tcl itself. It is developed at CEA in France.
     - [Lmod](https://lmod.readthedocs.io/en/latest/) uses module files written
       in Lua and itself is also written in Lua. It is compartible with many
       Tcl module files (from both versions of Environment Modules) through an
       automatic translation layer. Lmod is developed at TACC.

    You can see which version of modules your home cluster is using by executing
    ```bash
    module --version
    ```
    at the command prompt. For the old environment modules,
    the oguptu will start with `VERSION=3.2.11` or something similar, for the
    new Environment Modules it will report as `Modules Release 4.X` or
    `Modules Release 5.x` or something simular, and for Lmod it will explicitly
    say `Modules based on Lua`.

## The `module` command

Modules are managed by the `module` command:

```
module <sub-command> <module-name>
```

where the _sub-command_ indicates the operation you want to perform. The
_sub-command_ is followed by the name of the module on which you want to perform
the operation.

| Sub-command | Description                                          |
| ------------|------------------------------------------------------|
| `spider`    | Search for modules and display help                  |
| `keyword`   | Search for modules based on keywords                 |
| `avail`     | List available modules                               |
| `whatis`    | Display short information about modules              |
| `help`      | Print the help message of a module                   |
| `list`      | List the currently modules loaded                    |
| `load`      | Load a module                                        |
| `remove`    | Remove a module from your environment                |
| `purge`     | Unload all modules from your environment             |
| `show`      | Show the commands in the module's definition file    |



## Finding modules

Lmod is a hierarchical module system. It distinguishes between installed modules
and available modules. Installed modules are all modules that are installed on
the system. Available modules are all modules that can be loaded directly at that
time without first loading other modules. The available modules are often only
a subset of the installed modules. However, Lmod can tell you for each installed
module what steps you have to take to also make it available so that you can load it.
This is why the commands for finding modules are so important.

Some modules may also provide multiple software packages or extensions. Lmod can
also search for these but this feature.

??? failure "Not fully supported on LUMI"
    The LMOD feature to search for, e.g., Python packages inside a module or other
    software in a module is not fully exploited on LUMI as the output
    of some module commands becomes very long and ways to disabling that output do
    not work properly in the current version of Lmod on LUMI. This is due to two
    bugs one of which is present even in newer versions of LUMI as of November 2021.

### module spider

The basic command to search for software on LUMI is `module spider`.
It has three levels, producing different output:

 1. `module spider` without further arguments will produce a list of all installed
    software and show some basic information about those packages.
    Some packages may have an `(E)` behind their name and will appear in
    blue (in the default colour scheme) which means that they are part of a different
    package. The following levels of `module spider` will then tell you how to find
    which module(s) to load.

    Note that `module spider` will also search in packages that are hidden from being
    displayed. These packages can be loaded and used. However we hide them either because
    they are not useful to regular users or because we think that they will rarely
    or never be directly loaded by a user and want to avoid overloading the module
    display.

 2. `module spider <name of package>` will search for the specific package. This can
    be the name of a module, but it will also search some other information that can
    be included in the modules. The search is also case-insensitive. E.g.,
    ```bash
    module spider GNUplot
    ```
    will show something along the lines of
    ```
    ------------------------------------------------------------------
      gnuplot:
    ------------------------------------------------------------------
        Description:
          Gnuplot is a portable command-line driven graphing utility

         Versions:
            gnuplot/5.4.2-cpeCray-21.08
            gnuplot/5.4.2-cpeGNU-21.08
    ```
    so even though the capitalisation of the name was wrong, it can tell us that there
    are two versions of gnuplot. The `cpeGNU-21.08` and `cpeCray-21.08` tell that the
    difference is the compiler that was used to install gnuplot, being the GNU compiler
    (PrgEnv-gnu) and the Cray compiler (PrgEnv-cray) respectively.

    Similarly,
    ```bash
    module spider CMake
    ```
    returns output similar to
    ```
    ---------------------------------------------------------------------
      CMake: CMake/3.21.2 (E)
    ---------------------------------------------------------------------
        This extension is provided by the following modules. To access the
    extension you must load one of the following modules. Note that any
    module names in parentheses show the module location in the software
    hierarchy.

           buildtools/21.08 (LUMI/21.08 partition/L)
           buildtools/21.08 (LUMI/21.08 partition/G)
           buildtools/21.08 (LUMI/21.08 partition/D)
           buildtools/21.08 (LUMI/21.08 partition/C)
           buildtools/21.08 (CrayEnv)

    Names marked by a trailing (E) are extensions provided by another module.
    ```
    This tells that there is no `CMake` module on the system but that CMake (version
    3.21.2) is provided by a module called `buildtools/21.08` which is not readily available
    but requires loading any of the sets of modules between the parentheses, which
    in fact point to the different software stacks and node types on the system.

    !!! info "Information on LUMI software stacks?"
        For more information on the software stacks on LUMI, head to the
        ["Software stacks" page][softwarestacks].

    !!! failure "Known issue"
        We have run into cases where this list is incomplete. It seems that Lmod
        sometimes fails to find all possible combinations to make a particular
        module available.

    In some cases, if there is no ambiguity, `module spider` will actually already
    produce help about the package.

  3. `module spider <module name>/<version>` will show more help information about
     the package, including information on which other modules need to be loaded
     to be able to load the package. E.g.,
     ```bash
     module spider git/2.33.1
     ```
     will return
     ```
    -------------------------------------------------------------------
      git: git/2.33.1
    -------------------------------------------------------------------
        Description:
          Git is a free and open source distributed version control
          system

        You will need to load all module(s) on any one of the lines below
    before the "git/2.33.1" module is available to load.

          CrayEnv
          LUMI/21.08  partition/C
          LUMI/21.08  partition/D
          LUMI/21.08  partition/G
          LUMI/21.08  partition/L

        Help:
     ```
     (abbreviated output). Note that it also tells you which other modules need to
     be loaded. You need to chose the line which is appropriate for you and load
     all modules on that line, not the whole list of in this case 9 modules.

### module keyword

Another search command that is sometimes useful is `module keyword`. It really just
searches for the given word in the short descriptions that are included in most module
files and in the name of the module. The output is not always complete since not all
modules may have a complete enough short description.

Consider we are looking for a library or package that supports MP3 audio encoding.
```bash
module keyword mp3
```
will return something along the lines of
```
----------------------------------------------------------------

The following modules match your search criteria: "mp3"
----------------------------------------------------------------

  LAME: LAME/3.100-cpeCray-21.08, LAME/3.100-cpeGNU-21.08
    LAME is a high quality MPEG Audio Layer III (mp3) encoder
```
though the output will depend on the version of Lmod. This may not be the most useful
example on a supercomputer, but the library is in fact needed to be able to install
some other packages even though the sound function is not immediately useful.

??? failure "Know issue: Irrelevant output"
    At the moment of writing of this documentation page, this command actually returns
    a lot more output, refering to completely irrelevant extensions. This is a bug
    in the HPE-Cray-provided version of Lmod


### module avail

The `module avail` command is used to show only available modules, i.e., modules that
can be loaded directly without first loading other modules. It can be used in two ways:

 1. Without a further argument it will show an often lengthy list of all available
    modules. Some modules will be marked with `(D)` which means that they are the default
    module that would be loaded should you load the module using only its name.

 2. With the name of a module (or a part of the name) it will show all modules that
    match that (part of) a name. E.g.,
    ```bash
    module gnuplot
    ```
    will show something along the lines of
    ```
    ------ EasyBuild managed software for software stack LUMI/21.08 on LUMI-L ------
       gnuplot/5.4.2-cpeCray-21.08    gnuplot/5.4.2-cpeGNU-21.08 (D)

      Where:
       D:  Default Module
        (output abbreviated).
    ```
    but
    ```bash
    module avail gnu
    ```
    will show you an often lengthy list that contains all packages with gnu (case
    insensitive) in their name or version.


## Getting help

One way to get help on a particular module has already been discussed on this page:
`module spider <name>/<version>` will produce help about the package as soon as it
can unambiguously determine the package. It is the only command that can produce
help for all installed packages. The next two commands can only produce help about
available packages.

A second command is `module whatis` with the name or name and version of a module.
It will show the brief description of the module that is included in most modules on
the system. If the full version of the module is not given, it will display the
information for the default version of that module.

The third command is `module help`. Without any further argument it will display some
brief help about the module command. However, when used as `module help <name>` or
`module help <name>/<version>` it will produce help for either the default version
of the package (if the version is not specified) or the indicated version.


## Loading and unloading modules



