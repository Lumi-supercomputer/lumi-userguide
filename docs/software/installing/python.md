# Installing and using Python packages

[quota]: ../../storage/index.md
[cray_python]: python/cray_python.md
[container_wrapper]: python/container_wrapper.md
[container_self]: python/container_self.md

!!! note
    When you log onto LUMI, no Python module is loaded by default. Running
    `python` without loading a module or container first will result in you using
    the operating system default Python which is likely not what you intend as it
    is horrible outdated for normal standards.

## Background

Python packages often consists of a lot of files. Especially bigger Conda
environments often contain tens to hundreds of thousands of files.
This puts a lot of strain on our LUSTRE file system which excels
at serving serving bigger files to several nodes at the same time but struggles
with many small files as the distribution of the metadata becomes a bottleneck.
Therefore to ensure good file system performance, we enforce quite tight [quotas
on the number of files](number of file quotas) which makes some common python
installation methods impractical.

## Overview of Python installation approaches

Currently we recommend one of following approaches for installing Python
environments and packages:

  1. [Using Cray Python module](cray_python)
  2. [Creating a Python container using our wrapper script](container_wrapper)
  3. [Creating a Conda based container](container_self)

!!! failure "Do not use Conda directly without a container"
    Installing software through Conda should be the method of last resort on
    LUMI. Conda installations suffer from the same problem as Python and R
    installations when it comes to the number of files. Moreover, they are not
    guaranteed to be compatible with the Linux environment on LUMI. Problems can
    be expected with MPI as Conda will usually install its own MPI that is
    likely incompatible with the Slingshot 11 interconnect of LUMI or doesn't
    recognize its performance features and uses it only in the much slower
    TCP/IP mode. Moreover, many Conda-provided binaries are only compiled for a
    generic 64-bit x86 processor and don't use any of the newer instructions or
    don't contain other processor-specific optimisations.
    
	We do recognize, however, that sometimes there are no other options so we
    are offering a container-based solution to install conda-based software
    distributions, however, without a guarantee that software installed through
    conda will work.
