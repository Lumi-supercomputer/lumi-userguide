# Overview

[developing-overview]: ../development/index.md
[lumi-p]: ../hardware/storage/lumip.md
[easybuild]: ./installing/easybuild.md
[spack]: ./installing/spack.md
[contwrapper]: ../software/installing/container-wrapper.md
[singularity-container]: ../software/containers/singularity.md
[singularity-jobs]: ../runjobs/scheduled-jobs/container-jobs.md
[software-stacks]: ../runjobs/lumi_env/softwarestacks.md
[module-env]: ../runjobs/lumi_env/Lmod_modules.md
[software-library]: https://lumi-supercomputer.github.io/LUMI-EasyBuild-docs

---
On this page you find guidance on ways to install additional software on LUMI. 
A full overview of software installed in the LUMI software
stacks or available as a build recipe for the 
[EasyBuild][easybuild] package manager is available in the
[LUMI software library](https://lumi-supercomputer.github.io/LUMI-EasyBuild-docs/).
If you are looking for ways to
optimize your software for use on LUMI, consult the [developing
section][developing-overview] instead.

---

!!! warning

    The home and project directories reside on the Lustre based parallel
    file system on [LUMI-P][lumi-p] which does not perform well with
    installations of software containing a lot of small files, e.g. Python or
    R environments installed via Conda or pip. For such software a container
    based approach must be used. See below for the [container wrapper approach][contwrapper]
    or [use of singularity][singularity-container].


## Installing software

We offer three options to install software on LUMI, with varying levels of support.

The three options are:

-   Using [EasyBuild][easybuild]:

    EasyBuild is the primary software installation tool on LUMI. It is used to install
    most software in the [central software stack][software-stacks] on LUMI, but it 
    is also extremely easy to install additional software in your personal or project
    space and have it integrate fully with the software stacks.

    An overview of (almost) all software that we provide in the central software stack
    or for which we provide ready-to-use EasyBuild build recipes for a user installation
    can be found in the [LUMI Software Library][software-library].

    Consult the [module environment page][module-env] for instructions on
    identifying the already available software on LUMI through the module system instead. 

-   [Spack][spack]

    Spack is another popular package manager to install software mostly from sources for
    optimal performance on HPC systems. We provide a spack configuration that is
    configured for use of the compilers available on LUMI. However, we do no package
    development in Spack.

-   [Container wrapper][contwrapper]

     The container wrapper is a piece of software developed at CSC to package large
     conda installations or large Python installations built with `pip` on top of the
     Cray Python distribution in a single file to reduce the load on the Lustre filesystem
     that these installations typically cause.

The preferred volume for software installations is your project directory, so that 
a software installation can be shared with all users in your project. Software can be
installed in your home directory also but it is not recommended and you will not get
additional quota for it. Installing permanent software installations in your scratch
or flash directory is not recommended as these will be cleaned automatically in the 
future when the file system starts to fill up.


## Singularity containers

You can bring a [Singularity/Apptainer software container][singularity-container]
and run it using the [Singularity container runtime][singularity-jobs]
provided by LUMI. However, be aware that LUMI has hardware that is different from 
most typical small clusters and that the OS used on LUMI is also different from 
the versions used on those clusters, so you may run into compatibility and
performance problems.

## The LUMI Software Library

The [LUMI software library](https://lumi-supercomputer.github.io/LUMI-EasyBuild-docs/)
contains an overview with all software that is installed in the software stacks available
through the LUMI modules and the CrayEnv module (apart from the documentation of the
HPE Cray Programming Environment). For software installed on the system the first channel
to get help on a specific module is through the `module help` command, but the LUMI
Software Library pages sometimes contain more information on how to run the software,
or more information about specific options that were chosen when installing the software
on LUMI.

Packages with considerable extra information in the LUMI software library:

-   [QuantumESPRESSO](https://lumi-supercomputer.github.io/LUMI-EasyBuild-docs/q/QuantumESPRESSO/)
-   [VASP](https://lumi-supercomputer.github.io/LUMI-EasyBuild-docs/v/VASP/)

