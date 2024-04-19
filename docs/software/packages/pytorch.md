[containers]: ../containers/singularity.md
[interconnect]: ../../hardware/network.md
[python-install]: ../installing/python.md

# PyTorch on LUMI

[PyTorch](https://pytorch.org) is an open source Python package that provides tensor computation, like NumPy, with GPU acceleration and deep neural networks built on a tape-based autograd system.

PyTorch can be installed by following the [official instructions](https://pytorch.org/get-started/locally/) for installing a ROCm compatible PyTorch via pip. Please consult the [Python packages installation guide][python-install] for an overview of recommended ways to manage pip installations on LUMI. Alternatively, the container images provided by [AMD on DockerHub](https://hub.docker.com/u/rocm) may be used on LUMI.

## Running PyTorch within containers

We recommend using container images from [`rocm/pytorch`](https://hub.docker.com/r/rocm/pytorch) or [`rocm/deepspeed`](https://hub.docker.com/r/rocm/deepspeed).

The images can be pulled with Singularity:

```bash
$ SINGULARITY_TMPDIR=$SCRATCH/tmp-singularity singularity pull docker://rocm/pytorch:rocm5.4.1_ubuntu20.04_py3.7_pytorch_1.12.1
```

This will create an image file named `pytorch_rocm5.4.1_ubuntu20.04_py3.7_pytorch_1.12.1.sif` in the directory where the command was run. After the image has been pulled, the directory `$SCRATCH/tmp-singularity singularity` can be removed.

Please consult the [Singularity containers page][containers] for more details about using Singularity/Apptainer containers on LUMI.

### Installing other packages along the container's PyTorch installation

Often we may need to install other packages to be used along PyTorch.
That can be done by creating a virtual environment within the container in a host directory.
This can be done by running the container interactively and creating a virtual environment in your `$HOME`.
As an example, let's do that to install the package `python-hostlist`:

```bash
$ singularity exec -B $SCRATCH:$SCRATCH pytorch_rocm5.4.1_ubuntu20.04_py3.7_pytorch_1.12.1.sif bash
Singularity> python -m venv pt_rocm5.4.1_env --system-site-packages
Singularity> . pt_rocm5.4.1_env/bin/activate
(pt_rocm5.4.1_env) Singularity> pip install python-hostlist
```

When running the container, the virtual environment must be activated before calling python.

## Multi-GPU training

The communication between LUMI's GPUs during training with Pytorch is done via [RCCL](https://github.com/ROCmSoftwarePlatform/rccl),
which is a library of collective communication routines for AMD GPUs.
RCCL works out of the box on LUMI, but a special plugin is required to take advantage of the [Slingshot 11 interconnect][interconnect].
That's the [`aws-ofi-rccl`](https://github.com/ROCmSoftwarePlatform/aws-ofi-rccl) plugin,
which is a library that can be used as a back-end for RCCL to interact with the interconnect via `libfabric`.

The `aws-ofi-rccl` plugin can be installed by the user with EasyBuild:
```bash
$ module load LUMI/22.08 partition/G
$ module load EasyBuild-user
$ eb aws-ofi-rccl-66b3b31-cpeGNU-22.08.eb -r
```
Once installed, loading the module `aws-ofi-rccl` will add the path to the library to the `LD_LIBRARY_PATH` so RCCL can detect it.

## Example

Let's now consider an example to test the steps above.
We will use the script [cnn_distr.py](https://github.com/Lumi-supercomputer/lumi-reframe-tests/blob/main/checks/apps/deeplearning/pytorch/src/cnn_distr.py) 
which uses the [pt_distr_env.py](https://github.com/Lumi-supercomputer/lumi-reframe-tests/blob/main/checks/apps/deeplearning/pytorch/src/pt_distr_env.py) module 
to setup PyTorch's distributed environment.

That module is based on `python-hostlist`, which we installed earlier.

The Slurm submission script can be something like this:
```bash
#!/bin/bash
#SBATCH --job-name=pt-cnn
#SBATCH --ntasks=32
#SBATCH --ntasks-per-node=8
#SBATCH --time=0:10:0
#SBATCH --exclusive
#SBATCH --partition=standard-g
#SBATCH --account=<project>
#SBATCH --gpus-per-node=8

module load LUMI/22.08 partition/G
module load singularity-bindings
module load aws-ofi-rccl

. ~/pt_rocm5.4.1_env/bin/activate

export NCCL_SOCKET_IFNAME=hsn
export NCCL_NET_GDR_LEVEL=3
export MIOPEN_USER_DB_PATH=/tmp/${USER}-miopen-cache-${SLURM_JOB_ID}
export MIOPEN_CUSTOM_CACHE_DIR=${MIOPEN_USER_DB_PATH}
export CXI_FORK_SAFE=1
export CXI_FORK_SAFE_HP=1
export FI_CXI_DISABLE_CQ_HUGETLB=1
export SINGULARITYENV_LD_LIBRARY_PATH=/opt/ompi/lib:${EBROOTAWSMINOFIMINRCCL}/lib:/opt/cray/xpmem/2.4.4-2.3_9.1__gff0e1d9.shasta/lib64:${SINGULARITYENV_LD_LIBRARY_PATH}

srun singularity exec -B"/appl:/appl" \
                      -B"$SCRATCH:$SCRATCH" \
                      $SCRATCH/pytorch_rocm5.4.1_ubuntu20.04_py3.7_pytorch_1.12.1.sif python cnn_distr.py
```
Here we have used a few environment variables. The ones starting with `NCCL_` and `CXI_`, as well as `FI_CXI_DISABLE_CQ_HUGETLB` are used by RCCL for the communication over Slingshot 11 interconnect. The `MIOPEN_` ones are needed to make [MIOpen](https://rocmsoftwareplatform.github.io/MIOpen/doc/html/index.html) create its caches on `/tmp`. Finally, with `SINGULARITYENV_LD_LIBRARY_PATH` some directories are included in the container's `LD_LIBRARY_PATH`. This is important for RCCL to find the `aws-ofi-rccl` plugin. In addition, `NCCL_DEBUG=INFO`, can be used to increase RCCL's logging level to make sure that the `aws-ofi-rccl` plugin is being used: The lines
```bash
NCCL INFO NET/OFI Using aws-ofi-rccl 1.4.0
```
and
```bash
NCCL INFO NET/OFI Selected Provider is cxi
```
should appear in the output.

After running the script above, the output should include something like this
```bash
 * Rank 0 - Epoch  1: 212.39 images/sec per GPU
 * Rank 0 - Epoch  2: 212.34 images/sec per GPU
 * Rank 0 - Epoch  3: 212.55 images/sec per GPU
 * Rank 0 - Epoch  4: 212.44 images/sec per GPU
 * Total average: 6792.58 images/sec
```
