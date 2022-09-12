# PyTorch on LUMI

[PyTorch](https://pytorch.org) is an open source Python package that provides tensor computation, like NumPy, with GPU acceleration and deep neural networks built on a tape-based autograd system.

Recipes to install PyTorch via EasyBuild can be found in the 
[LUMI-EasyBuild-contrib](https://github.com/Lumi-supercomputer/LUMI-EasyBuild-contrib/tree/main/easybuild/easyconfigs/p) repository,
which must be cloned on LUMI by the user. Please, find [here](https://docs.lumi-supercomputer.eu/software/installing/easybuild/) information on how to build with Easybuild on LUMI.

The recipe can be installed like this:
```bash
module load LUMI/22.08 partition/G
module load EasyBuild-user
eb PyTorch-1.12.1-cpeGNU-22.08.eb -r
```
We also have prepared a recipe for [`aws-ofi-rccl`](https://github.com/ROCmSoftwarePlatform/aws-ofi-rccl), which is a plugin for RCCL to improve the communication over libfabric. If needed, it can be installed with
```bash
eb aws-ofi-rccl-66b3b31-cpeGNU-22.08.eb -r
```
Once installed, when loading the module `aws-ofi-rccl`, RCCL will find the plugin.

!!! Issues with the `aws-ofi-rccl` plugin has been observed when running with mixed precision.

Once installed, a PyTorch script can be run like this
```bash
#!/bin/bash
#SBATCH --job-name=cnn-pytorch
#SBATCH --ntasks=4
#SBATCH --ntasks-per-node=8
#SBATCH --gpus-per-node=8
#SBATCH --time=0:10:0
#SBATCH --partition gpu
#SBATCH --account=<account>

module load LUMI/22.08
module load partition/G
module load PyTorch
export NCCL_SOCKET_IFNAME=hsn0,hsn1,hsn2,hsn3
export NCCL_NET_GDR_LEVEL=3

srun python cnn_distr.py
```
The example [`cnn_distr.py`](https://github.com/Lumi-supercomputer/ml-examples/edit/main/pytorch/ptdist/run-singularity.sh) uses synthetic random data to evaluate the throughput in images/second of convolutional neural networks.
As it is, it uses ResNet50 but other models are available via `torchvision`.
In this example we use [a script](https://github.com/Lumi-supercomputer/ml-examples/blob/main/pytorch/ptdist/pt_distr_env.py) based on [`python-hostlist`](https://www.nsc.liu.se/~kent/python-hostlist/) to setup PyTorch's distributed environment.

In the output, besides other log lines, you should find something like
```bash
 * Rank 0 - Epoch  0: 522.19 images/sec per GPU
 * Rank 0 - Epoch  1: 522.69 images/sec per GPU
 * Rank 0 - Epoch  2: 520.66 images/sec per GPU
 * Rank 0 - Epoch  3: 522.78 images/sec per GPU
 * Rank 0 - Epoch  4: 522.89 images/sec per GPU
 * Total average: 16711.73 images/sec
```

Since the compute nodes are not connected to the internet, it's important to have all the data already available before running the job. In some cases, it will be necessary to disable the automatic fetching of data even when the data is available on disk. For instance, when working with [HuggingFace](https://huggingface.co), `transformers` and `datasets` must be set to offline with:
```bash
export TRANSFORMERS_OFFLINE=1
export HF_DATASETS_OFFLINE=1
```

## Running PyTorch within containers

Pytorch can be run on LUMI using the container images prepared by AMD which have been made available in DockerHub.
We recommend using images from [`rocm/pytorch`](https://hub.docker.com/r/rocm/pytorch) or [`rocm/deepspeed`](https://hub.docker.com/r/rocm/deepspeed/tags).

The images can be fetched with singularity by running for instance,
```bash
SINGULARITY_TMPDIR=$SCRATCH/tmp-singularity singularity pull docker://rocm/deepspeed:rocm5.0.1_ubuntu18.04_py3.7_pytorch_1.10.0.sif
```
This will create an image file named `deepspeed_rocm5.0.1_ubuntu18.04_py3.7_pytorch_1.10.0.sif` on the directory where the command was run. After the image has been pulled, the directory `$SCRATCH/tmp-singularity singularity` can be removed.

Often we may need to install other packages to be used along PyTorch.
That can be done by creating a virtual environment within the container in a host directory.
This can be done by running the container interactively and creating a virtual environment in your LUMI's `$HOME`.
As an example, let's do that to install `python-hostlist`:
```bash
$> singularity exec -B $SCRATCH:$SCRATCH deepspeed_rocm5.0.1_ubuntu18.04_py3.7_pytorch_1.10.0.sif bash
Singularity> python -m venv deepspeed_rocm5.0.1_env --system-site-packages
Singularity> . deepspeed_rocm5.0.1_env/bin/activate
(deepspeed_rocm5.0.1_env) Singularity> pip install python-hostlist
```
Now when running the container, the virtual environment must be activated before calling python.

Let's now run the [example](https://github.com/Lumi-supercomputer/ml-examples/blob/main/pytorch/ptdist/cnn_distr.py) used above. We use the same [script](https://github.com/Lumi-supercomputer/ml-examples/blob/main/pytorch/ptdist/pt_distr_env.py) to setup the distributed environment for PyTorch.

```bash
#!/bin/bash
#SBATCH --job-name=cnn-pytorch-singularity
#SBATCH --ntasks=4
#SBATCH --ntasks-per-node=8
#SBATCH --gpus-per-node=8
#SBATCH --time=0:10:0
#SBATCH --partition gpu
#SBATCH --account=<account>

module load LUMI/22.08
module load partition/G
module load OpenMPI

export NCCL_SOCKET_IFNAME=hsn0
export NCCL_NET_GDR_LEVEL=3

mpirun singularity exec deepspeed_rocm5.0.1_ubuntu18.04_py3.7_pytorch_1.10.0.sif \
                 bash -c '
                 . deepspeed_rocm5.0.1_env/bin/activate;
                 python cnn_distr.py'
```

In the output you can find something like this
```bash
 * Rank 0 - Epoch  0: 517.18 images/sec per GPU
 * Rank 0 - Epoch  1: 518.77 images/sec per GPU
 * Rank 0 - Epoch  2: 518.32 images/sec per GPU
 * Rank 0 - Epoch  3: 513.60 images/sec per GPU
 * Rank 0 - Epoch  4: 517.60 images/sec per GPU
 * Total average: 16546.94 images/sec
 ```

It's possible to use the `aws-ofi-rccl` plugin with this container as well:
```bash
#!/bin/bash
#SBATCH --job-name=cnn-pytorch-singularity
#SBATCH --ntasks=4
#SBATCH --ntasks-per-node=8
#SBATCH --gpus-per-node=8
#SBATCH --time=0:10:0
#SBATCH --partition gpu
#SBATCH --account=<account>

module load LUMI/22.08
module load partition/G
module load singularity-bindings
module load rccl
module load aws-ofi-rccl
module load OpenMPI

export NCCL_SOCKET_IFNAME=hsn0
export NCCL_NET_GDR_LEVEL=3
export SINGULARITYENV_LD_LIBRARY_PATH=/opt/ompi/lib:/opt/rocm-5.0.1/lib:$EBROOTAWSMINOFIMINRCCL/lib:/opt/cray/xpmem/2.4.4-2.3_9.1__gff0e1d9.shasta/lib64:$SINGULARITYENV_LD_LIBRARY_PATH

mpirun singularity exec \
                 -B"/appl:/appl" 
                 -B"$EBROOTRCCL/lib/librccl.so.1.0:/opt/rocm-5.0.1/rccl/lib/librccl.so.1.0.50001" \
                 deepspeed_rocm5.0.1_ubuntu18.04_py3.7_pytorch_1.10.0.sif \
                 bash -c '
                 . deepspeed_rocm5.0.1_env/bin/activate;
                 python cnn_distr.py'
```
