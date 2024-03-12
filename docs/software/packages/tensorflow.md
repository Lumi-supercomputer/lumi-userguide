# TensorFlow on LUMI

[TensorFlow](https://www.tensorflow.org/) is an end-to-end open source platform for machine learning. It has a comprehensive, flexible ecosystem of tools, libraries, and community resources that lets researchers push the state-of-the-art in ML and developers easily build and deploy ML-powered applications.

TensorFlow can be installed by following the [official instructions](https://rocm.docs.amd.com/projects/install-on-linux/en/latest/how-to/3rd-party/tensorflow-install.html) for installing a ROCm compatible TensorFlow via pip. Please consult the [Python packages installation guide][python-install] for an overview of recommended ways to manage pip installations on LUMI. Alternatively, container images made specifically for running TensorFlow on LUMI may be used.


## Running TensorFlow within containers provided by LUMI


The LUMI software library includes EasyBuild recipes for [TensorFlow containers](https://lumi-supercomputer.github.io/LUMI-EasyBuild-docs/t/TensorFlow/). The TensorFlow containers are developed by AMD specifically for LUMI and contain the necessary parts to run TensorFlow and Horovod on LUMI, including the plugin needed for RCCL when doing distributed AI, and a suitable version of ROCm for the version of TensorFlow. The images for the containers are also available on LUMI at `/appl/local/containers/sif-images/` and definition files and more can be found in [this GitHub repository](https://github.com/sfantao/lumi-containers/tree/main).

The container uses a miniconda environment in which Python and its packages are installed. That environment needs to be activated in the container when running, which can be done with the command that is available in the container as the environment variable `$WITH_CONDA` (which for this container is `source /opt/miniconda3/bin/activate tensorflow`).

The information about extending these containers can be found in the [Singularity/Apptainer section](../containers/singularity.md). Below you can find the conda environment that is used in the base container.

```bash
name: tensorflow
channels:
  - defaults
dependencies:
  - _libgcc_mutex=0.1=main
  - _openmp_mutex=5.1=1_gnu
  - bzip2=1.0.8=h7b6447c_0
  - ca-certificates=2023.12.12=h06a4308_0
  - ld_impl_linux-64=2.38=h1181459_1
  - libffi=3.4.4=h6a678d5_0
  - libgcc-ng=11.2.0=h1234567_1
  - libgomp=11.2.0=h1234567_1
  - libstdcxx-ng=11.2.0=h1234567_1
  - libuuid=1.41.5=h5eee18b_0
  - ncurses=6.4=h6a678d5_0
  - openssl=3.0.12=h7f8727e_0
  - pip=23.3.1=py310h06a4308_0
  - python=3.10.13=h955ad1f_0
  - readline=8.2=h5eee18b_0
  - setuptools=68.2.2=py310h06a4308_0
  - sqlite=3.41.2=h5eee18b_0
  - tk=8.6.12=h1ccaba5_0
  - tzdata=2023d=h04d1e81_0
  - wheel=0.41.2=py310h06a4308_0
  - xz=5.4.5=h5eee18b_0
  - zlib=1.2.13=h5eee18b_0
  - pip:
      - absl-py==2.1.0
      - astunparse==1.6.3
      - cachetools==5.3.2
      - certifi==2023.11.17
      - charset-normalizer==3.3.2
      - cloudpickle==3.0.0
      - flatbuffers==23.5.26
      - gast==0.4.0
      - google-auth==2.27.0
      - google-auth-oauthlib==0.4.6
      - google-pasta==0.2.0
      - grpcio==1.60.0
      - h5py==3.10.0
      - horovod==0.28.1
      - idna==3.6
      - keras==2.11.0
      - libclang==16.0.6
      - markdown==3.5.2
      - markupsafe==2.1.4
      - numpy==1.22.4
      - oauthlib==3.2.2
      - opt-einsum==3.3.0
      - packaging==23.2
      - protobuf==3.19.6
      - psutil==5.9.8
      - pyasn1==0.5.1
      - pyasn1-modules==0.3.0
      - pyyaml==6.0.1
      - requests==2.31.0
      - requests-oauthlib==1.3.1
      - rsa==4.9
      - six==1.16.0
      - tensorboard==2.11.2
      - tensorboard-data-server==0.6.1
      - tensorboard-plugin-wit==1.8.1
      - tensorflow-estimator==2.11.0
      - tensorflow-io-gcs-filesystem==0.35.0
      - tensorflow-rocm==2.11.1.550
      - termcolor==2.4.0
      - typing-extensions==4.9.0
      - urllib3==2.1.0
      - werkzeug==3.0.1
      - wrapt==1.16.0

```

## Multi-GPU training

There are a few ways to do Multi-GPU training with TensorFlow. One of the most common distribution methods for TensorFlow is [Horovod](https://horovod.ai/), which is included in the LUMI containers mentioned above. TensorFlow also provides [native distribution methods](https://www.tensorflow.org/guide/distributed_training) through tf.distribute.MultiWorkerMirroredStrategy. It implements synchronous distributed training across multiple workers, each with potentially multiple GPUs.

The communication between LUMI's GPUs during training with Pytorch is done via [RCCL](https://github.com/ROCmSoftwarePlatform/rccl), which is a library of  collective communication routines for AMD GPUs. RCCL works out of the box on LUMI, however, a special plugin is required so it can take advantage of the [Slingshot 11 interconnect][interconnect]. That's the [`aws-ofi-rccl`](https://github.com/ROCmSoftwarePlatform/aws-ofi-rccl) plugin, which is a library that can be used as a back-end for RCCL to interact with the interconnect via libfabric. Using the containers provide by LUMI, this plugin is built into the container.

## Examples

You can execute the test case by downloading the [MultiWorkerMirroredStrategy](https://github.com/mihkeltiks/LUMI-docs-files/blob/main/TensorFlow/tf2_distr.py) or [Horovod test script](https://github.com/mihkeltiks/LUMI-docs-files/blob/main/TensorFlow/tf2_horovod.py)

We will be using a bash script to set environment variables and eventually call the TensorFlow code saved as `tf2_distr.py`. 

##### run.sh
```bash
#!/bin/bash -e
cd /workdir
$WITH_CONDA
set -x
echo $SLURM_LOCALID

# export NCCL_DEBUG=INFO
export NCCL_SOCKET_IFNAME=hsn0,hsn1,hsn2,hsn3
export NCCL_NET_GDR_LEVEL=3
export MIOPEN_USER_DB_PATH="/tmp/${whoami}-miopen-cache-$SLURM_NODEID"
export MIOPEN_CUSTOM_CACHE_DIR=$MIOPEN_USER_DB_PATH
export CUDA_VISIBLE_DEVICES=0,1,2,3,4,5,6,7

export CXI_FORK_SAFE=1
export CXI_FORK_SAFE_HP=1
export FI_CXI_DISABLE_CQ_HUGETLB=1
export TF_CPP_MAX_VLOG_LEVEL=-1

rocm-smi
# Set MIOpen cache out of the home folder.
if [ $SLURM_LOCALID -eq 0 ] ; then
  rm -rf $MIOPEN_USER_DB_PATH
  mkdir -p $MIOPEN_USER_DB_PATH
fi
sleep 3

# Report affinity
echo "Rank $SLURM_PROCID --> $(taskset -p $$)"

python tf2_distr.py --batch-size=256
```

We have used a few environment variables in the run.sh script. The ones starting with `NCCL_` and `CXI_`, as well as `FI_CXI_DISABLE_CQ_HUGETLB` are used by RCCL for the communication over Slingshot.  The `MIOPEN_` ones are needed to make [MIOpen](https://rocmsoftwareplatform.github.io/MIOpen/doc/html/index.html) create its caches on `/tmp`. The `NCCL_NET_GDR_LEVEL` variable allows the user to finely control when to use GPU Direct RDMA between a NIC and a GPU. We have found 3 to be a good value for this, but it is value to experiment with. Setting `CUDA_VISIBLE_DEVICES` is not necessary if using the Horovod code.


Additional TensorFlow debug messages can be seen if you remove `TF_CPP_MAX_VLOG_LEVEL=-1`. In addition, `NCCL_DEBUG=INFO`, can be used to increase RCCL's logging level to make sure that the `aws-ofi-rccl` plugin is being used. To verify, you should be able to see the following lines somewhere in the output
```bash
NCCL INFO NET/OFI Using aws-ofi-rccl 1.4.0
NCCL INFO NET/OFI Selected Provider is cxi
```

Below we bind some necessary components for the container and set proper NUMA node to GPU affinity.

If the job hangs with MultiWorkerMirroredStrategy, you might need to bind mount a newer version of [TensorFlow Slurm cluster resolver](https://raw.githubusercontent.com/tensorflow/tensorflow/66e587c780c59f6bad2ddae5c45460440002dc68/tensorflow/python/distribute/cluster_resolver/slurm_cluster_resolver.py) as is done in the batch script below.

```bash
#!/bin/bash
#SBATCH -p standard-g
#SBATCH -N 2
#SBATCH -n 16
#SBATCH --ntasks-per-node 8
#SBATCH --gpus-per-task 1
#SBATCH --threads-per-core 1
#SBATCH --exclusive
#SBATCH --gpus 16
#SBATCH --mem 0 
#SBATCH -t 0:15:00
#SBATCH --account=project_<your_project_id>

wd=$(pwd)
SIF=/appl/local/containers/sif-images/lumi-tensorflow-rocm-5.5.1-python-3.10-tensorflow-2.11.1-horovod-0.28.1.sif


c=fe
MYMASKS="0x${c}000000000000,0x${c}00000000000000,0x${c}0000,0x${c}000000,0x${c},0x${c}00,0x${c}00000000,0x${c}0000000000"
srun --cpu-bind=mask_cpu:$MYMASKS \
  singularity exec \
    -B /var/spool/slurmd:/var/spool/slurmd \
    -B /opt/cray:/opt/cray \
    -B /usr/lib64/libcxi.so.1:/usr/lib64/libcxi.so.1 \
    -B /usr/lib64/libjansson.so.4 \
    -B slurm_cluster_resolver.py:/opt/miniconda3/envs/tensorflow/lib/python3.10/site-packages/tensorflow/python/distribute/cluster_resolver/slurm_cluster_resolver.py \
    -B $wd:/workdir \
    $SIF /workdir/run.sh
```


