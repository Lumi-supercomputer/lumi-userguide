# Software Modules

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
module list

Currently Loaded Modules:
CHANGEME
```

In order to list the available modules, you can use the command

```
module avail
CHANGEME
```

This will list all the names and versions of the modules available. Modules
are identified by name and version as follows: `name/version`. You may observe
that for some modules we have more than one version, each of which is 
identified by a version number. All the modules of a particular
name can be listed by adding a _name_ as argument of the `module avail` command. 

```
module avail <name>
CHANGEME
```

One of these modules is identified with a `(D)`. This is the default module,
which will be loaded (with `module load <full-name>`) if no version is specified.

### Loading and removing modules

To load a module use the `module load` command. For example, to load the Cray
Compiling Environment, use:

```
module load cce
```

This command will load the default version of the module. If the software you
loaded has dependencies, they will be loaded in your environment at the same
time.

To load a specific version of the module you need to specify it after the name of
the module.

```
module load cce/11.0.0
```

In order to unload a module from your environment, use the `unload` sub-command
followed by the name of the module you want to remove.

```
module remove cce
```

You can also remove all loaded modules from your environment by using the 
`purge` sub-command.

```
module purge
```

### Get infomation about the module

Information about a module such as its description, usage and links to the
documentation of the software package can be obtained using the `help`
sub-command.

```
module help cce
CHANGEME
```

On the other hand, if you are more interested in what is actually defined by
the module, you can inspect the content of the module file using the `show`
sub-command.

```
module show cce
CHANGEME
```

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
