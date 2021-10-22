# Modules Environment

Software modules allow you to control which software and versions are 
available in your environment. Modules contain the necessary information to
allow you to run a particular application or provide you access to a
particular library so that

- different versions of a software package can be provided
- you can easily switch to different versions without having to explicitly
  specify different paths
- you don't have to deal with dependent modules, they are loaded at the same time
  as the software

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
| `list`      | List the currently modules loaded                    |
| `avail`     | List available modules                               |
| `load`      | Load a module                                        |
| `remove`    | Remove a module from your environment                |
| `purge`     | Unload all modules from your environment             |
| `help`      | Print the help message of a module                   |
| `show`      | Show the commands in the module's definition file    |

### Listing available modules

To list the modules currently active in your environment, use the command:

```
$ module list
Currently Loaded Modulefiles:
  1) cce/11.0.4                                  5) craype-network-ofi
  2) craype/2.7.7                                6) perftools-base/21.05.0
  3) craype-x86-rome                             7) xpmem/2.2.40-7.0.1.0_2.4__g1d7a24d.shasta
  4) libfabric/1.11.0.4.79                       8) PrgEnv-cray/8.0.0
```

In order to list the available modules, you can use the command

```
$ module avail

------------------------------------ /opt/cray/pe/perftools/21.05.0/modulefiles ------------------------------------
perftools             perftools-lite-events perftools-lite-hbm    perftools-preload
perftools-lite        perftools-lite-gpu    perftools-lite-loops

--------------------------------------------- /opt/cray/pe/modulefiles ---------------------------------------------
PrgEnv-aocc/8.0.0(default)                cray-netcdf/4.7.4.4(default)
PrgEnv-aocc/8.1.0                         cray-netcdf/4.7.4.6
PrgEnv-cray/8.0.0(default)                cray-netcdf-hdf5parallel/4.7.4.4(default)
PrgEnv-cray/8.1.0                         cray-netcdf-hdf5parallel/4.7.4.6
PrgEnv-gnu/8.0.0(default)                 cray-openshmemx/11.2.1(default)
PrgEnv-gnu/8.1.0                          cray-openshmemx/11.3.2
... (+ many more modules)
```

This will list all the names and versions of the modules available. Modules
are identified by name and version as follows: `name/version`. You may observe
that for some modules we have more than one version, each of which is 
identified by a version number. All the modules of a particular
name can be listed by adding a _name_ as argument of the `module avail` command. 

```
$ module avail PrgEnv-gnu

--------------------------------------------- /opt/cray/pe/modulefiles ---------------------------------------------
PrgEnv-gnu/8.0.0(default) PrgEnv-gnu/8.1.0

```

One of these modules is identified with a `(D)` or `(default)`. This is the default module,
which will be loaded (with `module load <full-name>`) if no version is specified.

### Loading and removing modules

To load a module use the module load command. For example, to load the Cray 
FFTW library, use:

```
$ module load cray-fftw
```

This command will load the default version of the module. If the software you
loaded has dependencies, they will be loaded in your environment at the same
time.

To load a specific version of the module you need to specify it after the name of
the module.

```
$ module load cray-fftw/3.3.8.11
```

In order to unload a module from your environment, use the `unload` sub-command
followed by the name of the module you want to remove.

```
$ module remove cray-fftw
```

You can also remove all loaded modules from your environment by using the 
`purge` sub-command.

```
$ module purge
```

### Get information about the module

Information about a module such as its description, usage and links to the
documentation of the software package can be obtained using the `help`
sub-command.

```
$ module help cray-fftw
----------- Module Specific Help for 'cray-fftw/3.3.8.10' ---------


===================================================================
FFTW 3.3.8.10
============
  Release Date:
  -------------
    May 2021


  Purpose:
  --------
    This Cray FFTW 3.3.8.10 release is supported on Cray EX (formerly
    Shasta) systems. FFTW is supported on the host CPU but not on the
    accelerator of Cray systems.

    The Cray FFTW 3.3.8.10 release provides the following:
      - Optimizations for AMD Milan CPUs
    See the Product and OS Dependencies section for details.
...

```

On the other hand, if you are more interested in what is actually defined by
the module, you can inspect the content of the module file using the `show`
sub-command.

```
$ module show cray-fftw
-------------------------------------------------------------------
/opt/cray/pe/modulefiles/cray-fftw/3.3.8.10:

conflict	 cray-fftw 
conflict	 fftw 
setenv		 FFTW_VERSION 3.3.8.10 
setenv		 CRAY_FFTW_VERSION 3.3.8.10 
setenv		 CRAY_FFTW_PREFIX /opt/cray/pe/fftw/3.3.8.10/x86_rome 
setenv		 FFTW_ROOT /opt/cray/pe/fftw/3.3.8.10/x86_rome 
setenv		 FFTW_DIR /opt/cray/pe/fftw/3.3.8.10/x86_rome/lib 
setenv		 FFTW_INC /opt/cray/pe/fftw/3.3.8.10/x86_rome/include 
prepend-path	 PATH /opt/cray/pe/fftw/3.3.8.10/x86_rome/bin 
...
```

The environment variables defines are sometimes useful when building software. For example, you could pass `-I$(FFTW_INC)` to the compiler to add the header files for the FFTW library.

## Saving your environment

Sometimes, if you frequently use multiple modules together, it might be useful
to save your environment as a module collection. A collection can be 
created using `save` sub-command.

```
module save <collection-name>
```

Your saved collections can be listed using the `savelist` sub-command.

```
module savelist
CHANGEME
```

But, of course, the main interest of a collection is that you can load all the
modules it contains in one command. This is done using the `restore` 
sub-command.

```
module restore <collection-name>
CHANGEME
```

## Create and use your own modules

TBD
