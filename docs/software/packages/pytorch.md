# PyTorch on LUMI

[PyTorch](https://pytorch.org) is an open source Python package that provides tensor computation, like NumPy, with GPU acceleration and deep neural networks built on a tape-based autograd system.

## Running Pytoch within containers

Pytorch can be run on LUMI using the container images prepared by AMD which have been made available on DockerHub.
We recommend using images from [`rocm/pytorch`](https://hub.docker.com/r/rocm/pytorch) or [`rocm/deepspeed`](https://hub.docker.com/r/rocm/deepspeed/tags).

The images can be fetched with singularity by running for instance,
```bash
singularity pull docker://rocm/pytorch:rocm5.2_ubuntu20.04_py3.7_pytorch_1.11.0
```
This will create an image file named `pytorch_rocm5.2_ubuntu20.04_py3.7_pytorch_1.11.0.sif` on the directory where the command was run.

Often we may need to install other packages to be used along PyTorch.
That can be done by creating a virtual environment within the container in a host directory.
For instance, let's run the container interactively and create a virtual environment in `$HOME` to install `python-hostlist`:
```bash
$> singularity exec pytorch_rocm5.2_ubuntu20.04_py3.7_pytorch_1.11.0.sif bash
Singularity> python -m venv pytorch_rocm5.2_env --system-site-packages
Singularity> . pytorch_rocm5.2_env/bin/activate
(pytorch_rocm5.2_env) Singularity> pip install python-hostlist
```
Now when running the container, the virtual environment must be activated before calling python.

Let's now run [this example](https://github.com/Lumi-supercomputer/ml-examples/blob/main/pytorch/ptdist/cnn_distr.py).
It uses synthetic random data to evaluate the throughput of convolutional neural networks in images per second.
As it is, tt uses ResNet50 but other models are available via `torchvision`.
We use [this script](https://github.com/Lumi-supercomputer/ml-examples/blob/main/pytorch/ptdist/pt_distr_env.py) based on `python-hostlist` to setup the distributed environment for PyTorch.

```bash
#!/bin/bash -l

#SBATCH --job-name=test-pt
#SBATCH --time=00:10:00
#SBATCH --nodes=2
#SBATCH --ntasks-per-core=1
#SBATCH --ntasks-per-node=1
#SBATCH --gpus-per-node=8
#SBATCH --partition=gpu
#SBATCH --account=<account>

srun singularity exec deepspeed_rocm5.0.1_ubuntu18.04_py3.7_pytorch_1.10.0.sif \
                 bash -c '
                 cd $HOME/git_/ml-examples/pytorch/ptdist;
                 . ~/pytorch_rocm5.2_env/bin/activate;
                 python cnn_distr.py'
```
In the output we can find something like this
```bash
 * Rank 0 - Epoch  0: 527.34 images/sec per GPU
 * Rank 0 - Epoch  1: 527.56 images/sec per GPU
 * Rank 0 - Epoch  2: 526.09 images/sec per GPU
 * Rank 0 - Epoch  3: 524.90 images/sec per GPU
 * Rank 0 - Epoch  4: 526.63 images/sec per GPU
 * Total average: 8424.06 images/sec
```
