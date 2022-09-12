# Overview

[developing-overview]: ../development/index.md
[lumi-p]: ../storage/parallel/lumip.md
[easybuild]: ./installing/easybuild.md
[spack]: ./installing/spack.md
[contwrapper]: ./containers/wrapper.md
[singularity-container]: ../computing/containers.md
[singularity-jobs]: ../software/containers/cray_mpich.md

---
Here you find guidance on ways to install software on LUMI as well as guides on
using some specific software packages on LUMI. If you are looking for ways to
optimize your software for use on LUMI, consult the [developing
section][developing-overview] instead.

---

You have two options for bringing your scientific software to LUMI:

1. Install your scientific software in your home or project directory.
   For this we recommend using the [EasyBuild][easybuild] package manager as it
   is used to manage the central software stack on LUMI and makes it easy to
   install additional software that extends it. Alternatively, you may use
   [Spack][spack] or the [container wrapper][contwrapper].
2. Bring a [Singularity/Apptainer software
   container][singularity-container] and run it using the [Singularity container
   runtime][singularity-jobs] provided by LUMI.

!!! warning

    The home and project directories reside on the Lustre based parallel
    file system on [LUMI-P][lumi-p] which does not perform well with
    installations of software containing a lot of small files, e.g. Python or
    R environments installed via Conda or pip. For such software a container
    based approach must be used.
