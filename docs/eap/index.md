---
hide:
  - navigation
---

[lmod]: ../computing/Lmod_modules.md
[prgenv]: ../development/compiling/prgenv.md
[batch]: ../computing/jobs/batch-job.md
[slurm]: ../computing/jobs/slurm-quickstart.md
[MI100]: https://www.amd.com/en/products/server-accelerators/instinct-mi100
[MI250X]: https://www.amd.com/en/products/server-accelerators/instinct-mi250x

# LUMI-G Early Access Platform

!!! warning
    
    This page is a preliminary of the guide documenting the use of the LUMI-G
    Early Access Platform (EAP). It contains information specific to the latter, 
    but does not stand on its own. Users of the EAP are also invited to read 
    other sections of the LUMI documentation. In particular, you are invited to
    read the section on the [module system][lmod] and the 
    [programming environment][prgenv].

The LUMI early access platform consists of nodes with MI100 GPUs that are the
predecessors of the MI250X GPUs that will be in LUMI-G, with the intended use
case being to give users access to the software stack so that they can work on
preparing their software for the LUMI-G nodes when they arrive. Specifically the
hardware is 14 nodes (starting with 4 being available) with the hardware
summarized in the table below:


| Nodes | CPUs                                                                | Memory | GPUs            | Local storage   | Network     |
| :---: | :-----------------------------------------------------------------: | -----: | :-------------: | :-------------: | :---------: |
| 14    | 1x 64 cores AMD EPYC 7662<br>2.0 GHz base<br>3.3 GHz boost | 512GB   | 4x AMD MI100    | 2x 3TB NVMe   | 1x 100 Gb/s |

The [MI100 GPU][MI100] is the predecessor the the [MI250X][MI250X] that will be
in LUMI-G. As the MI100 GPUs is the previous generation doing direct comparisons
with the GPUs that LUMI-G will use is not straight forward. While it may seem
like a good first approximation that one MI100 GPU is about on par with one of
the two dies in an MI250X based on the number of compute units, that does not
take into account: the increased FP64 and DGEMM performance, the performance
achievable with packed FP32, the increased bfloat16 performance, or the
increased memory bandwidth.

In the EAP nodes the four MI100 GPUs are connected to each other with direct
infinity fabric links providing direct GPU to GPU link, each link provides 46
GB/s of bandwidth in each direction. Each of the MI250X GPUs in LUMI-G will show
up as 2 devices, and the infinity fabric mesh in those nodes is more complex
with more links, but the basic idea is the same with direct GPU to GPU links.
The one thing the EAP nodes cannot emulate is the fast infinity fabric link
between the two dies on one MI250X board.

The network in the EAP nodes is significantly different to that which the LUMI-G
nodes will have, the EAP nodes have a single 100gbit network adapter, whereas
the LUMI-G nodes will have 4x200gbit adapters. Hence any performance achieved by
multi-node runs is not at all representative of the LUMI-G nodes, and multi-node
runs should really only be done to test functionality.  

## About the programming environment

The programming environment of the EAP is still experimental and do not entirely
reflect the final environment or performance of the progrmming environment that 
when LUMI-G will be available. Here is a list of the characteristics of the 
current platform that will be available once LUMI-G is available:

- OpenMP offload support will be available for C/C++ and Fortran with the Cray
  compilers (PrgEnv-cray). The same is true for the AMD compilers. Currently the
  AMD compilers are available by loading the `rocm` module. On the final 
  system, they will be a `PrgEnv-amd` module.
- HIP code can be compiled with the Cray C++ compiler wrapper (`CC`) or with
  the AMD `hipcc` compiler wrappper.
- A GPU-aware MPI implementation is available (loading the `cray-mpich` 
  module). You can use this MPI library with the Cray and AMD environment. Note
  that during testing the LUMI User Support Team noticed that the 
  inter-node bandwidth is low (~4.5 GB/s). On the final system, it will be 
  possible to initiate communication directly from the GPU (MPI call from HIP 
  kernels). This feature is not available on the Early Access Platform.

## Compiling HIP code

You have two options to compile you HIP code: you can use the ROCm AMD compiler
or the Cray compiler.

=== "Using the Cray compilers"

    To compile HIP code with the Cray C/C++ compiler, load the following modules
    in your environment.

    ```
    module load CrayEnv
    module load PrgEnv-cray
    module load craype-accel-amd-gfx908
    module load rocm
    ```

    The compilation flags to use to compile HIP code with the Cray C++ 
    compiler wrappers (`CC`) are the following

    ```
    -std=c++11 --rocm-path=${ROCM_PATH} --offload-arch=gfx908 -x hip
    ```

    In addition, at the linking step, you need to link your application with
    the HIP library using the flags

    ```
    --rocm-path=${ROCM_PATH} -L${ROCM_PATH}/lib -lamdhip64
    ```

=== "Using the hipcc wrapper"
    
    To compile HIP code with the `hipcc` compiler wrapper, load the following
    modules in your environment.

    ```
    module load CrayEnv
    module load rocm
    ```

    After that you can use the `hipcc` compiler wrapper to compile HIP code.

!!! warning

    Be careful and make sure to compile your code using the 
    `--offload-arch=gfx908` flag in order to compile code optimized for the 
    MI100 GPU architecture. If you omit the flag, the compiler may optimize 
    your code for an older, less suitable architecture.


## Compiling OpenMP offload code

You have to options available OpenMP offload code compilation. The first option
is to use the Cray compilers and the second, to use the AMD compilers provided 
with ROCm.

=== "Using the Cray compilers"

    To compile an OpenMP offload code with the Cray compilers, you need to load the
    following modules:

    ```
    module load CrayEnv
    module load PrgEnv-cray
    module load craype-accel-amd-gfx908
    module load rocm
    ``` 

    It is critical to load the `craype-accel-amd-gfx908` module in order to make
    the compiler wrappers aware that you target the MI100 GPUs. To compile the code,
    use the Cray compiler wrappers: `cc` (C), `CC` (C++) and `ftn` (Fortran) with 
    the `-fopenmp` flag.

    === "C"

        ```
        cc -fopenmp -o <exec> <source>
        ```

    === "C++"

        ```
        CC -fopenmp -o <exec> <source>
        ```

    === "Fortran"

        ```
        ftn -fopenmp -o <exec> <source>
        ```

=== "Using the AMD compilers"

    The AMD compilers are available by loading the `rocm` module.

    ```
    module load rocm
    ```

    It will give you access to the `amdclang` (C), `amdclang++` (C++) and 
    `amdflang` (Fortran) compilers. In order to compile OpenMP offload code, you 
    need to pass additional target flags to the compiler.

    === "C"

        ```
        amdclang -fopenmp -fopenmp-targets=amdgcn-amd-amdhsa \
                -Xopenmp-target=amdgcn-amd-amdhsa -march=gfx908 \
                -o <exec> <source>
        ```

    === "C++"

        ```
        amdclang++ -fopenmp -fopenmp-targets=amdgcn-amd-amdhsa \
                  -Xopenmp-target=amdgcn-amd-amdhsa -march=gfx908 \
                  -o <exec> <source>
        ```

    === "Fortran"

        ```
        amdflang -fopenmp -fopenmp-targets=amdgcn-amd-amdhsa \
                -Xopenmp-target=amdgcn-amd-amdhsa -march=gfx908 \
                -o <exec> <source>
        ```

## Compiling a HIP+MPI code

The MPI implementation available on LUMI is GPU-aware. It means that you can
pass a pointer to memory allocated on the GPU to the MPI calls. This MPI 
implementation can be used by loading the `cray-mpich` module loaded.

```
module load craype-accel-amd-gfx908
module load cray-mpich
module load rocm

export MPICH_GPU_SUPPORT_ENABLED=1
```

=== "Using the Cray compilers"

    The Cray compiler wrappers will automatically link your application (acting 
    similarly to `mpicc`) to the MPI library and Cray GPU transfer library 
    (`libmpi_gtl`). Still, you need to use the flags presented in the 
    [previous section](#compiling-hip-code) in order to compile HIP code.

=== "Using the hipcc compiler wrapper"
    
    When using the `hipcc` compiler wrapper, you need the explicitly link your
    application with the MPI and GPU transfer libraries using the following 
    flags:

    ```
    -I${MPICH_DIR}/include \
    -L${MPICH_DIR}/lib -lmpi \
    -L${CRAY_MPICH_ROOTDIR}/gtl/lib -lmpi_gtl_hsa
    ```

!!! warning

    When running GPU-aware MPI code, **you need to enable GPU support** using 
    `MPICH_GPU_SUPPORT_ENABLED=1`. Failing to do so will lead to failure if 
    your application use GPU pointers in MPI calls. This usually manifest as
    a bus error. Note also that the Cray MPI do not support GPU-aware MPI for 
    multiple GPUs per rank, i.e. **you should only use one GPU per MPI rank**.

## Submitting jobs

LUMI use Slurm as a job scheduler. If you are not familiar with Slurm, please 
read the [Slurm quick start guide][slurm]

To submit jobs to the Early Access platform you need to select the `eap` 
partition and provide you project number. Below is an example job script to 
launch an application with 2 MPI ranks with 8 threads and 1 GPU per rank.

```bash title="eap.job"
#!/bin/bash

#SBATCH --partition=eap (1)
#SBATCH --account=<project_XXXXXXXXX> (2)
#SBATCH --time=10:00 (3)
#SBATCH --ntasks=2 (4)
#SBATCH --cpus-per-task=8 (5)
#SBATCH --gpus-per-task=1 (6)

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK # (7)
export MPICH_GPU_SUPPORT_ENABLED=1 # (8)

srun <executable> # (9)
```

1. Select the Early Access Partition

2. Change this value to match your project number. If you don't know your 
   project number use the `groups` command. You should see that you are a
   member of a group looking like this: `project_XXXXXXXXX`.

3. The format for time is `dd-hh:mm:ss`. In this case, the requested time is
   10 minutes.

4. Request 2 tasks. A task in Slurm speaks is a process. If your application
   use MPI, it corresponds to the number of MPI ranks.

5. Request 8 threads per task. If your application is multithreaded (for 
   example, using OpenMP) this is how you control the number of threads.

6. Request 2 GPUs for this job, one for each task. Most of the time the number 
   of GPUs is the same as the number of tasks (MPI ranks).

7. If your application is multithreaded with OpenMP, set the value of 
   `OMP_NUM_THREADS` to the value set with `--cpus-per-task`

8. If your code needs a GPU-aware MPI

9. Launch your application with `srun`. They are no `mpirun`/`mpiexec` on LUMI. 
   You should always use `srun` to launch your application. If your application 
   doesn't use MPI you can omit it. 

Once your job script is ready, you can submit your job using the `sbatch` 
command.

```
sbatch eap.job
```

More information about available batch script parameters is available 
[here][batch]. The table below summarizes the GPU-specific options.


| Option             | Description                                        |
|--------------------|----------------------------------------------------|
| `--gpus`           | Specify the total number of GPUs across all nodes  |
| `--gpus-per-task`  | Specify the number of GPUs required for each task |
| `--gpus-per-node`  | Specify the number of GPUs per node                |
| `--ntasks-per-gpu` | Specify the number of tasks for every GPU          |
