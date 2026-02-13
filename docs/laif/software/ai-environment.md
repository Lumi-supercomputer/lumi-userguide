# AI Software Environment

The AI Software Environment by LUMI AI Factory is a comprehensive, ready-to-use containerised stack for AI
and machine learning workloads on the LUMI supercomputer. The environment is designed to address
the complexity of deploying and maintaining AI/ML software in high-performance computing (HPC)
setting.

!!! Info "Release of the AI Software Environment by LUMI AI Factory"
    The AI Software Environment by LUMI AI Factory currently undergoes testing and a full release is planned for end of February 2026.

    You can already start using the AI Software Environment now, but we we will update this page with more information about the AI Software Environment and prepare use examples.

All build artifacts are publicly available. This includes the full recipe,
Containerfiles, build logs, and the resulting final container images. This
transparent approach enables full customization for special use cases, reuse
on other similar systems, as well as adapting the images to run on cloud
environments.

## Available container images


At the moment each release includes the following container images, each building on the previous one by adding
new major functionality in the following order:

1. `lumi-multitorch-rocm-*`: Starts from Ubuntu base image and adds ROCm
2. `lumi-multitorch-libfabric-*`: Adds libfabric to the ROCm image
3. `lumi-multitorch-mpich-*`: Adds MPICH with GPU support to the libfabric image
4. `lumi-multitorch-torch-*`: Adds PyTorch to the MPICH image
5. `lumi-multitorch-full-*`: Adds selection of AI and ML libraries (e.g., Bitsandbytes, DeepSpeed, Flash Attention, Megatron LM, vLLM) to the PyTorch image

The [releases on GitHub](https://github.com/lumi-ai-factory/laifs-container-recipes/releases) also include full details of the included software of each image.

The name of the container includes a timestamp and version identifier. It is explained in the [releases on GitHub](https://github.com/lumi-ai-factory/laifs-container-recipes/releases).

For users running AI applications based on PyTorch the containers starting with `lumi-multitorch-full-*` are most likely the best starting point. Advanced users can build on intermediate containers to customize to their use cases. We aim to release containers for jax or other software in the future.


## Access to container images

The container images are available from the following locations:

- LUMI supercomputer in directory: `/appl/local/laifs/containers/`
- GitHub releases in [public GitHub repository](https://github.com/lumi-ai-factory/laifs-container-recipes/releases)
- Docker Hub in the [LUMI AI Factory organisation](https://hub.docker.com/u/lumiaifactory)

## Examples for using the container images

This list only includes some examples for using the container images. More examples that use older containers supplied by AMD can be found in the [LUMI AI guide](https://github.com/Lumi-supercomputer/LUMI-AI-Guide/). We will update these examples with the AI Software Environment by LUMI AI Factory soon.

!!! Info "singularity-AI-bindings module"
    To give LUMI containers access to the Slingshot network for good RCCL and MPI performance and access to the file system of the working directory, some additional bindings are required. As it can be quite cumbersome to set these bindings manually, we provide a module that does this for you. You can load the module with the following commands:

    ```
    module use /appl/local/containers/ai-modules
    module load singularity-AI-bindings
    ```

    If you prefer to set the bindings manually, we recommend taking a look at the [Running containers on LUMI lecture](https://lumi-supercomputer.github.io/LUMI-training-materials/ai-20240529/extra_05_RunningContainers/) from the [LUMI AI workshop material](https://github.com/Lumi-supercomputer/Getting_Started_with_AI_workshop).

### Run PyTorch using the container

```
module use /appl/local/containers/ai-modules
module load singularity-AI-bindings
export SIF=/appl/local/laifs/containers/lumi-multitorch-u24r64f21m43t29-20260124_092648/lumi-multitorch-full-u24r64f21m43t29-20260124_092648.sif
srun singularity exec $SIF python -c "import torch; print(torch.cuda.device_count())"
```

### List pip packages in container
To inspect which specific packages are included in the images you can use this simple command:

```
export SIF=/appl/local/laifs/containers/lumi-multitorch-u24r64f21m43t29-20260124_092648/lumi-multitorch-full-u24r64f21m43t29-20260124_092648.sif
singularity exec $SIF pip list
```

Alternatively, you can have a look at the software bill of materials (SBOM) `.json` file in the [GitHub releases](https://github.com/lumi-ai-factory/laifs-container-recipes/releases) or in the directory of the container on LUMI.

### Add more pip packages to container

You might find yourself in a situation where none of the provided containers contain all Python packages you need. One possible way of adding custom packages not included in the image is to use a virtual environment on top of the conda environment. For this example, we need to add the HDF5 Python package `h5py` to the environment:

```
module use /appl/local/containers/ai-modules
module load singularity-AI-bindings
export SIF=/appl/local/laifs/containers/lumi-multitorch-u24r64f21m43t29-20260124_092648/lumi-multitorch-full-u24r64f21m43t29-20260124_092648.sif
singularity shell $SIF
Singularity> python -m venv h5-env --system-site-packages
Singularity> source h5-env/bin/activate
(h5-env) Singularity> pip install h5py
```

This will create an h5-env environment in the working directory. The `--system-site-packages` flag gives the virtual environment access to the packages from the container. 

!!! Warning "Strain on Lustre file system"
    Installing Python packages typically creates thousands of small files. This puts a lot of strain on the Lustre file system and might exceed your file quota. This problem can be solved by creating a new container.

Now one can execute a script with and import the h5py package. To execute a script called `my-script.py` within the container using the virtual environment, use the additional activation command:

```
export SIF=/appl/local/laifs/containers/lumi-multitorch-u24r64f21m43t29-20260124_092648/lumi-multitorch-full-u24r64f21m43t29-20260124_092648.sif
singularity exec $SIF bash -c 'source h5-env/bin/activate && python my-script.py'
```



## More information

- [LUMI AI Guide](https://github.com/Lumi-supercomputer/LUMI-AI-Guide)
- [PyTorch documentation](https://pytorch.org/docs/stable/index.html)
- [CSC's Machine learning guide](https://docs.csc.fi/support/tutorials/ml-guide/)