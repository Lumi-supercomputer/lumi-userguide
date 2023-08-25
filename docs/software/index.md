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

---
On this page you find guidance on ways to install additional software on LUMI.
A full overview of software that is either installed in the LUMI software
stacks, or available as a LUMI-specific build recipe for the
[EasyBuild][easybuild] package manager, can be found in the [LUMI software
library](https://lumi-supercomputer.github.io/LUMI-EasyBuild-docs/). If you are
looking for information on how to develop your own software on LUMI, consult
the [developing section][developing-overview] instead. Please note that the
LUMI User Support Team can only offer limited help with installing scientific
software. This is further explained on the [Install policy](/software/policy/)
page.

---

!!! warning "Avoid installing a lot of small files"

    The home and project directories reside on the [Lustre][lustre] based parallel
    file system on [LUMI-P][lumi-p] which does not perform well with
    installations of software containing a lot of small files, e.g. Python or
    R environments installed via Conda or pip. For such software a container
    based approach must be used. See the [Python packages installation guide
    ][python-install] for en overview of options for installing Conda/pip
    environments.

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
    optimal performance on HPC systems. We provide a Spack configuration that is
    configured to use of the compilers available on LUMI and which can install packages in the upstream Spack repository. However, we do no package development ourselves in Spack.

-   [Tykky installation wrapper][contwrapper]

     The Tykky installation wrapper is a piece of software developed at CSC
     which wraps software installations inside an Apptainer/Singularity container
     to improve startup times, reduce I/O load, and lessen the number of files on
     large parallel file systems.

The preferred location for software installations is your project directory, so
that a software installation can be shared with all users in your project.
Software can be installed in your home directory also but it is not recommended
and you will not get additional quota for it. Installing permanent software
installations in your scratch or flash directory is not recommended as these
will be cleaned automatically in the future when the file system starts to fill
up.

## Alternatives to installing software yourself

As an alternative to installing software yourself using one of the methods
mentioned above, you may:

- **Use an Apptainer/Singularity container**: You can bring a
[Singularity/Apptainer software container][singularity-container] and run it
using the [Singularity container runtime][singularity-jobs] provided by LUMI.
- **Use software already installed in the LUMI Software Library**: The [LUMI
software library](https://lumi-supercomputer.github.io/LUMI-EasyBuild-docs/)
contains an overview with all software that is installed in the software stacks
available through the LUMI modules and the CrayEnv module (apart from the
documentation of the HPE Cray Programming Environment). For software installed
on the system the first channel to get help on a specific module is through the
`module help` command, but the LUMI Software Library pages sometimes contain
more information on how to run the software, or more information about specific
options that were chosen when installing the software on LUMI.
- **Use local software collections**: There are also software available on LUMI installed by local LUMI organizations. These are available for all LUMI users and are updated and supported by the local LUMI organizations themselves, not by LUST.

    * [CSC installed software collection](https://docs.lumi-supercomputer.eu/software/local/csc/)
