# Overview

[developing-overview]: ../development/index.md
[lumi-p]: ../storage/parallel-filesystems/lumip.md
[lustre]: ../storage/parallel-filesystems/lustre.md
[python-install]: ./installing/python.md
[easybuild]: ./installing/easybuild.md
[spack]: ./installing/spack.md
[contwrapper]: ../software/installing/container-wrapper.md
[singularity-container]: ../software/containers/singularity.md
[singularity-jobs]: ../runjobs/scheduled-jobs/container-jobs.md
[software-stacks]: ../runjobs/lumi_env/softwarestacks.md
[module-env]: ../runjobs/lumi_env/Lmod_modules.md
[software-library]: https://lumi-supercomputer.github.io/LUMI-EasyBuild-docs
[install-policy]: ./policy.md

---
On this page, you will find information about pre-installed software on LUMI as well
as guidance on ways to install additional software yourself.

If you are looking for information on how to develop your own software on LUMI,
consult the [developing section][developing-overview] instead.

Please note that LUMI User Support Team can only offer limited help with
installing scientific software as is further explained in the [Install policy][install-policy].

!!! warning "Avoid installing a lot of small files"

    The home and project directories reside on the [Lustre][lustre] based parallel
    file system on [LUMI-P][lumi-p] which does not perform well with
    installations of software containing a lot of small files, e.g. Python or
    R environments installed via Conda or pip. For such software a container
    based approach must be used. See the [Python packages installation guide
    ][python-install] for an overview of options for installing Conda/pip
    environments.

---

## Pre-installed software

On LUMI, we provide some pre-installed software in both central software stacks (managed by the LUMI User Support Team) and local software collections (managed by local organizations in the LUMI consortium):

- Central LUMI software stacks

    A full overview of software, that is either pre-installed in the [LUMI software stacks][software-stacks],
    or available as a user-installable LUMI-specific build recipe for the [EasyBuild][easybuild] package manager can be found in the [LUMI software library][software-library].
    
    Whether software is pre-installed or user-installable can be found when you open the page of the specific software.
    For software installed in the [central LUMI software stacks][software-stacks],
    the first channel to get help on a specific module is through the `module help` command,
    but the LUMI [Software Library pages][software-library] sometimes contain more information
    on how to run the software, or more information about specific options that
    were chosen when installing the software on LUMI.
    
    Consult the [module environment page][module-env] for instructions on identifying the pre-installed software on LUMI through the module system instead.
    Read more about the user-installable software with EasyBuild in the [next section](#installing-additional-software).

- Software collections by local organizations

    There is also pre-installed software available provided by local LUMI
    consortium organizations. These software collections are available for all LUMI
    users, but are updated and supported by the local LUMI consortium organizations
    themselves, not by the LUMI User Support Team.

       - [CSC installed software collection](https://docs.lumi-supercomputer.eu/software/local/csc/)

## Installing additional software

We offer two package management systems to install software on LUMI, with varying levels of support:

- [EasyBuild][easybuild]:

    EasyBuild is the primary software installation tool on LUMI. It is used to install
    most software in the [central software stack][software-stacks] on LUMI, but it
    is also extremely easy to install additional software in your personal or project
    space and have it integrate fully with the software stacks.

    An overview of (almost) all software that we provide pre-installed in the
    central software stack or for which we provide ready-to-use EasyBuild build
    recipes for a user installation can be found in the [LUMI Software
    Library][software-library].

- [Spack][spack]

    Spack is another popular package manager to install software mostly from sources for
    optimal performance on HPC systems. We provide a Spack configuration that is
    configured to use of the compilers available on LUMI and which can install packages
    in the upstream Spack repository. However, we do no package development ourselves in Spack.

The preferred location for software installations is your `/project` directory,
so that a software installation can be shared with all users in your project.
Software can also be installed in your home directory, but it is not recommended
and you will not get additional quota for it. Creating permanent software
installations in your `/scratch` or `/flash` directories is not recommended as
these will be cleaned automatically in the future when the file system starts
to fill up.

If you intend to install Python packages, please consult the [Python packages
installation guide][python-install] for an overview of your options.

## Alternatives to installing software yourself

As alternatives to installing software, you may:

- Use an Apptainer/Singularity container

    You can bring a [Singularity/Apptainer software container][singularity-container]
    and run it using the [Singularity container runtime][singularity-jobs] provided by LUMI.

- Use the [LUMI container wrapper][contwrapper]

    The LUMI container wrapper is a piece of software developed at CSC
    which wraps software installations inside an Apptainer/Singularity container
    to improve startup times, reduce I/O load, and lessen the number of files on
    large parallel file systems.
