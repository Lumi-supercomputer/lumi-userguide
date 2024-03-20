[containers]: ../containers/singularity.md
[interconnect]: ../../hardware/network.md
[python-install]: ../installing/python.md

# PyTorch on LUMI

[PyTorch](https://pytorch.org) is an open source Python package that provides tensor computation, like NumPy, with GPU acceleration and deep neural networks built on a tape-based autograd system.

PyTorch can be installed by following the [official instructions](https://pytorch.org/get-started/locally/) for installing a ROCm compatible PyTorch via pip. Please consult the [Python packages installation guide][python-install] for an overview of recommended ways to manage pip installations on LUMI. Alternatively, container images made specifically for running PyTorch on LUMI may be used.


## Running PyTorch within containers provided by LUMI


The LUMI software library includes EasyBuild recipes for [PyTorch containers](https://lumi-supercomputer.github.io/LUMI-EasyBuild-docs/p/PyTorch/). The PyTorch containers are developed by AMD specifically for LUMI and contain the necessary parts to run PyTorch on LUMI, including the plugin needed for RCCL when doing distributed AI, and a suitable version of ROCm for the version of PyTorch. The apex, torchvision, torchdata, torchtext and torchaudio packages are also included. The images for the containers are also available on LUMI at `/appl/local/containers/sif-images/` and definition files and more can be found in [this GitHub repository](https://github.com/sfantao/lumi-containers/tree/main).

The container uses a miniconda environment in which Python and its packages are installed. That environment needs to be activated in the container when running, which can be done with the command that is available in the container as the environment variable `$WITH_CONDA` (which for this container it is `source /opt/miniconda3/bin/activate pytorch`).

The information about extending these containers can be found in the [Singularity/Apptainer section](../containers/singularity.md). Below you can find the conda environment that is used in the base container.

```bash
name: py311_rocm542_pytorch
channels:
  - conda-forge
dependencies:
  - certifi=2023.07.22
  - charset-normalizer=3.2.0
  - filelock=3.12.4
  - idna=3.4
  - jinja2=3.1.2
  - lit=16.0.6
  - markupsafe=2.1.3
  - mpmath=1.3.0
  - networkx=3.1
  - numpy=1.25.2
  - pillow=10.0.0
  - pip=23.2.1
  - python=3.11.5
  - requests=2.31.0
  - sympy=1.12
  - typing-extensions=4.7.1
  - urllib3=2.0.4
  - pip:
    - --extra-index-url https://download.pytorch.org/whl/rocm5.4.2/
    - pytorch-triton-rocm==2.0.2
    - torch==2.0.1+rocm5.4.2
    - torchaudio==2.0.2+rocm5.4.2
    - torchvision==0.15.2+rocm5.4.2
```

In short, the enviroment file can be used like this to create a new container with the described conda environment.

```bash
module load LUMI
module load cotainr
cotainr build lumi-sfantao-pytorch-lumi-base.sif --base-image=/appl/local/containers/sif-images/lumi-rocm-rocm-5.5.3.sif --conda-env=py311_rocm542_pytorch.yml
```

## Multi-GPU training

The communication between LUMI's GPUs during training with Pytorch is done via [RCCL](https://github.com/ROCmSoftwarePlatform/rccl), which is a library of  collective communication routines for AMD GPUs. RCCL works out of the box on LUMI, however, a special plugin is required so it can take advantage of the [Slingshot 11 interconnect][interconnect]. That's the [`aws-ofi-rccl`](https://github.com/ROCmSoftwarePlatform/aws-ofi-rccl) plugin, which is a library that can be used as a back-end for RCCL to interact with the interconnect via libfabric. Using the containers provide by LUMI, this plugin is built into the container.

## Example

Having loaded the [container module](https://lumi-supercomputer.github.io/LUMI-EasyBuild-docs/p/PyTorch/) you can also find some runscripts at the path set to the environment variable `$RUNSCRIPTS`. Let's now consider an example to test the steps above. For example, let's use a simple [MNIST training script and a model](https://github.com/Lumi-supercomputer/lumi-reframe-tests/tree/main/checks/containers/ML_containers/src/pytorch/mnist). We will also be using a script `get-master.py` to determine the master node for communication and a `run-pytorch.sh` script to initialize variables.

##### get-master.py
```bash
import argparse
def get_parser():
    parser = argparse.ArgumentParser(description="Extract master node name from Slurm node list",
            formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument("nodelist", help="Slurm nodelist")
    return parser


if __name__ == '__main__':
    parser = get_parser()
    args = parser.parse_args()

    first_nodelist = args.nodelist.split(',')[0]

    if '[' in first_nodelist:
        a = first_nodelist.split('[')
        first_node = a[0] + a[1].split('-')[0]

    else:
        first_node = first_nodelist

    print(first_node)
```

##### run-pytorch.py
```bash
#!/bin/bash -e

# Make sure GPUs are up
if [ $SLURM_LOCALID -eq 0 ] ; then
    rocm-smi
fi
sleep 2

export MIOPEN_USER_DB_PATH="/tmp/$(whoami)-miopen-cache-$SLURM_NODEID"
export MIOPEN_CUSTOM_CACHE_DIR=$MIOPEN_USER_DB_PATH

# Set MIOpen cache to a temporary folder.
if [ $SLURM_LOCALID -eq 0 ] ; then
    rm -rf $MIOPEN_USER_DB_PATH
    mkdir -p $MIOPEN_USER_DB_PATH
fi
sleep 2

# Report affinity
echo "Rank $SLURM_PROCID --> $(taskset -p $$)"

# !Remove this if using an image extended with cotainr! Start conda environment inside the container
$WITH_CONDA

# Optional! Set NCCL debug output to check correct use of aws-ofi-rccl (these are very verbose)
export NCCL_DEBUG=INFO
export NCCL_DEBUG_SUBSYS=INIT,COLL

# Set interfaces to be used by RCCL.
export NCCL_SOCKET_IFNAME=hsn0,hsn1,hsn2,hsn3
export NCCL_NET_GDR_LEVEL=3

# Set environment for the app
export MASTER_ADDR=$(python get-master.py "$SLURM_NODELIST")
export MASTER_PORT=29500
export WORLD_SIZE=$SLURM_NPROCS
export RANK=$SLURM_PROCID
export ROCR_VISIBLE_DEVICES=$SLURM_LOCALID

# Run app
cd mnist
python -u mnist_DDP.py --gpu --modelpath model
```

Given that you have the above scripts at the location `/project/your_project/your_directory` and a mnist folder with the training script and model inside of there too, the batch script might look something like this:

```bash
#!/bin/bash -e
#SBATCH --nodes=4
#SBATCH --gpus-per-node=8
#SBATCH --tasks-per-node=8
#SBATCH --cpus-per-task=7
#SBATCH --output="output_%x_%j.txt"
#SBATCH --partition=standard-g
#SBATCH --mem=480G
#SBATCH --time=00:10:00
#SBATCH --account=project_<your_project_id>

PROJECT_DIR=/project/your_project/your_directory
CONTAINER=$PROJECT_DIR/your-container-image.sif

c=fe
MYMASKS="0x${c}000000000000,0x${c}00000000000000,0x${c}0000,0x${c}000000,0x${c},0x${c}00,0x${c}00000000,0x${c}0000000000"


srun --cpu-bind=mask_cpu:$MYMASKS \
  singularity exec \
    -B /var/spool/slurmd \
    -B /opt/cray \
    -B /usr/lib64/libcxi.so.1 \
    -B /usr/lib64/libjansson.so.4 \
    -B $PROJECT_DIR:/workdir \
    $CONTAINER /workdir/run-pytorch.sh
```


Here we have used a few environment variables. The ones starting with `NCCL_` are used by RCCL for the communication over Slingshot 11 interconnect. The `MIOPEN_` ones are needed to make [MIOpen](https://rocmsoftwareplatform.github.io/MIOpen/doc/html/index.html) create its caches on `/tmp`. In addition, `NCCL_DEBUG=INFO`, can be used to increase RCCL's logging level to make sure that the `aws-ofi-rccl` plugin is being used: The lines

```bash
NCCL INFO NET/OFI Using aws-ofi-rccl 1.4.0
```
and
```bash
NCCL INFO NET/OFI Selected Provider is cxi
```
should appear in the output.