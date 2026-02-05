# AI Software Environment

The LUMI AI Factory Software Environment aims to be a comprehensive, ready-to-use containerised stack for AI
and machine learning workloads on the LUMI supercomputer. The environment is designed to address
the complexity of deploying and maintaining AI/ML software in high-performance computing (HPC)
setting.

## PyTorch

[PyTorch](https://pytorch.org) is an open source Python package that provides tensor computation, like NumPy, with GPU acceleration and deep neural networks built on a tape-based autograd system.

!!! Info "Release of PyTorch containers by LUMI AI Factory"
    The LUMI AI Factory PyTorch container currently undergoes testing and is scheduled to be released in early Spring. 

    In the meantime, we recommend using the AMD-provided containers (see below).

    We will update this page and the [LUMI AI Guide](https://github.com/Lumi-supercomputer/LUMI-AI-Guide) with information about the new LUMI AI Factory containers.

At the moment, we recommend using the AMD-provided containers, which can be found in the `/appl/local/containers/sif-images/` directory in LUMI. The following containers are available:

| PyTorch Version   | Python Version    | Container                                                 |
|:-----------------:|:-----------------:|:---------------------------------------------------------:|
| 2.7.1             | 3.12              | lumi-pytorch-rocm-6.2.4-python-3.12-pytorch-v2.7.1.sif    |
| 2.7.0             | 3.12              | lumi-pytorch-rocm-6.2.4-python-3.12-pytorch-v2.7.0.sif    |
| 2.6.0             | 3.12              | lumi-pytorch-rocm-6.2.4-python-3.12-pytorch-v2.6.0.sif    |
| 2.5.1             | 3.12              | lumi-pytorch-rocm-6.2.3-python-3.12-pytorch-v2.5.1.sif    |

There are containers for older PyTorch versions (2.4.1, 2.3.1, 2.3.0, 2.2.2) that *might* not fully work after the [January 2026 LUMI maintenance break](https://lumi-supercomputer.eu/lumi-service-status/information-lumi-maintenance-break-7-21-january-2026/).

See [instructions in the AI Guide](https://github.com/Lumi-supercomputer/LUMI-AI-Guide/tree/main/2-setting-up-environment#interacting-with-a-containerized-environment) for checking which other Python packages are installed.

### How to use the containers

See the [Environment setup section in the LUMI AI Guide](https://github.com/Lumi-supercomputer/LUMI-AI-Guide/tree/main/2-setting-up-environment) for instructions on how to use these containers. The guide explains the following steps:

- [Containers on LUMI](https://github.com/Lumi-supercomputer/LUMI-AI-Guide/tree/main/2-setting-up-environment#containers-on-lumi): The motivation for using containers on LUMI.
- [Interacting with a containerized environment](https://github.com/Lumi-supercomputer/LUMI-AI-Guide/tree/main/2-setting-up-environment#interacting-with-a-containerized-environment): Instructions for interacting with the container and for checking which Python packages are installed.
- [Singularity and Slurm](https://github.com/Lumi-supercomputer/LUMI-AI-Guide/tree/main/2-setting-up-environment#singularity-and-slurm): How to use singularity containers with Slurm.
- [singularity-AI-bindings module](https://github.com/Lumi-supercomputer/LUMI-AI-Guide/tree/main/2-setting-up-environment#singularity-ai-bindings-module): To give LUMI containers access to the Slingshot network for good RCCL and MPI performance and access to the file system of the working directory, some additional bindings are required.
- [Installing additional Python packages in a container](https://github.com/Lumi-supercomputer/LUMI-AI-Guide/tree/main/2-setting-up-environment#installing-additional-python-packages-in-a-container): Instructions for adding more Python packages.


## More information

- [LUMI AI Guide](https://github.com/Lumi-supercomputer/LUMI-AI-Guide)
- [PyTorch documentation](https://pytorch.org/docs/stable/index.html)
- [CSC's Machine learning guide](https://docs.csc.fi/support/tutorials/ml-guide/)