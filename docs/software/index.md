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

---
Here you find guidance on ways to install software on LUMI. 
A full overview of software installed in the LUMI software
stacks or available as a build recipe for the 
[EasyBuild][easybuild] package manager is available in the
[LUMI software library](https://lumi-supercomputer.github.io/LUMI-EasyBuild-docs/).
If you are looking for ways to
optimize your software for use on LUMI, consult the [developing
section][developing-overview] instead.

---

You have two options for bringing your scientific software to LUMI:

1. Install your scientific software in your home or project directory. For this
   we recommend using the [EasyBuild][easybuild] package manager as it is used
   to manage the [central software stack][software-stacks] on LUMI and makes it
   easy to install additional software that extends it. Alternatively, you may
   use [Spack][spack] or the [container wrapper][contwrapper].
2. Bring a [Singularity/Apptainer software container][singularity-container]
   and run it using the [Singularity container runtime][singularity-jobs]
   provided by LUMI.

Consult the [module environment page][module-env] for instructions on
identifying the already available software on LUMI. Furthermore, you may want to
consult the [EasyBuild][easybuild] and [Spack][spack] pages for information
about applications for which we already provide recipes that make them very
easy to install yourself.

!!! warning

    The home and project directories reside on the Lustre based parallel
    file system on [LUMI-P][lumi-p] which does not perform well with
    installations of software containing a lot of small files, e.g. Python or
    R environments installed via Conda or pip. For such software a container
    based approach must be used.

---

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

