# Singularity

[software_installing]: ../software/installing/easybuild.md
[cray_mpich]: ../software/containers/cray_mpich.md
[julia]: ../software/containers/julia.md
[docker-wiki]: https://en.wikipedia.org/wiki/Docker_(software)
[apptainer]: https://apptainer.org/
[apptainer-guide]: https://apptainer.org/docs/user/main/index.html

This section of the documentation describes briefly how to use singularity on
LUMI 

Singularity is available on LUMI-C as the executable `singularity`. No modules
need to be loaded.

## Background

If you are familiar with [Docker containers][docker-wiki], 
[Singularity containers][apptainer] are essentially the same thing, but are
better suited for multi-user systems such as the LUMI supercomputer. Containers
provide an isolated software environment for each application, which makes it
easier to install complex applications. On shared file systems, launch times can
also be much shorter for containers compared to alternatives such as conda.

You can read more about Singularity in the 
[official user guide][apptainer-guide].

!!! info
    The singularity project is in the process of being renamed to apptainer, so
    you might se both terms being used depending on the material you are reading

To use singularity containers on LUMI you can:

- [Download and existing container](#pulling-container-images-from-a-registry)
- Use a container provided by the computing environment
- Build your own container


## Pulling container images from a registry

Singularity allows pulling images from container registries such as DockerHub or
AMD Infinity Hub. For instance, the Ubuntu image `ubuntu:21.04` can be pulled
from DockerHub with the following command:

```bash
singularity pull docker://ubuntu:latest
```
This will create the Singularity image file `ubuntu_21.04.sif` in the directory
where the command was run. **Please take care to only use images uploaded from
reputable sources** as these images can easily be a source of security
vulnerabilities or even contain malicious code.

!!! note
    The compute nodes of LUMI-C are not connected to the internet. As a
    consequence, the images need to be pulled in on the login nodes (or
    transferred to LUMI with other means such as `scp`). 


!!! hint
    When pulling docker containers using singularity, the conversion can be
    quite heavy. Speed up the conversion and avoid leaving behind temporary
    files by moving the temporary to `/tmp`
    
    ```
    mkdir -p /tmp/$USER
    export SINGULARITY_TMPDIR=/tmp/$USER
    export SINGULARITY_CACHEDIR=/tmp/$USER
    ```

## Running a container

Once the image has been pulled, the container can be run. For instance, here we
check the version of Ubuntu running in the container

```bash
srun --partition=<partition> --account=<account> singularity exec \
     ubuntu_21.04.sif cat /etc/os-release
```

This prints

```
NAME="Ubuntu"
VERSION="21.04 (Hirsute Hippo)"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 21.04"
VERSION_ID="21.04"
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
VERSION_CODENAME=hirsute
UBUNTU_CODENAME=hirsute
```

By default, some file system partitions, such as `/scratch`,`/projappl` are not
accessible from the container. To make them available, they need to be
explicitly bound by passing the `-B/--bind` command line option to 
`singularity exec/run`. For instance

```bash
srun --partition=<partition> --account=<account> singularity exec \
     -B /scratch/<account> ubuntu_21.04.sif ls /scratch/<account>
```

## Application-specific container

 * [Running MPI applications within the container][cray_mpich]
 * [Running Julia within a container][julia]
