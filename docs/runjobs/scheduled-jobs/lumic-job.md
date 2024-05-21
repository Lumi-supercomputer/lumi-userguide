# LUMI-C example batch scripts

[billing]: ../../runjobs/lumi_env/billing.md#cpu-small-slurm-partition

Here we give examples of batch scripts for typical CPU jobs on LUMI-C. You may
use these as templates for your own project batch scripts.

!!! info "About memory specification"

    - The LUMI-C compute nodes have 256GB of memory installed but 224GB is really 
      available to the job. The exception is the 512 GB and 1TB nodes located in
      the `small` partition.
    - If you submit to the `standard` partition, were the node are in exclusive
      mode we recommend to use the `--mem=0` option, i.e., all  the memory on 
      the node.
    - If you use the small partition, we recommend you to use `--mem-per-cpu=1750`
      or a lower value. If you request more than 2GB/core then you will be 
      billed for the memory according to the [billing policy][billing].


## Shared memory jobs

Below is an example job script for a single node run of an OpenMP application 
requesting 128 cores on a compute node of the LUMI-C `small` partition.

```bash
#!/bin/bash -l
#SBATCH --job-name=examplejob   # Job name
#SBATCH --output=examplejob.o%j # Name of stdout output file
#SBATCH --error=examplejob.e%j  # Name of stderr error file
#SBATCH --partition=small       # Partition (queue) name
#SBATCH --ntasks=1              # One task (process)
#SBATCH --cpus-per-task=128     # Number of cores (threads)
#SBATCH --time=12:00:00         # Run time (hh:mm:ss)
#SBATCH --account=project_<id>  # Project for billing

# Any other commands must follow the #SBATCH directives

# Set the number of threads based on --cpus-per-task
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
 
./your_application
```

### MPI-based jobs

!!! Failure "Fortran MPI program fails to start"
    If a Fortran-based program with MPI fails to start when utilizing a large
    number of nodes (512 nodes for instance), add
    `export PMI_NO_PREINITIALIZE=y` to your batch script before running `srun`.  

Below is an example job script for a 2 nodes run of an MPI application running 
128 ranks per node, i.e., 256 ranks in total. This job will be submitted to the 
LUMI-C `standard` partition.

```bash
#!/bin/bash -l
#SBATCH --job-name=examplejob   # Job name
#SBATCH --output=examplejob.o%j # Name of stdout output file
#SBATCH --error=examplejob.e%j  # Name of stderr error file
#SBATCH --partition=standard    # partition name
#SBATCH --nodes=2               # Total number of nodes 
#SBATCH --ntasks=256            # Total number of mpi tasks
#SBATCH --mem=0                 # Allocate all the memory on each node
#SBATCH --time=1-12:00:00       # Run time (d-hh:mm:ss)
#SBATCH --account=project_<id>  # Project for billing

# All commands must follow the #SBATCH directives

# Launch MPI code 
srun ./your_application # Use srun instead of mpirun or mpiexec
```

## Hybrid MPI+OpenMP jobs

Below is an example job script for a 2 nodes run of an MPI application running 
16 ranks per node, i.e., 32 ranks in total. Each rank uses 8 threads, i.e., the
job will run 256 threads in total. This job will be submitted to the 
LUMI-C `standard` partition.

```bash
#!/bin/bash -l
#SBATCH --job-name=examplejob   # Job name
#SBATCH --output=examplejob.o%j # Name of stdout output file
#SBATCH --error=examplejob.e%j  # Name of stderr error file
#SBATCH --partition=standard    # partition name
#SBATCH --nodes=2               # Total number of nodes 
#SBATCH --ntasks-per-node=16    # Number of mpi tasks per node
#SBATCH --cpus-per-task=8       # Number of cores (threads) per task
#SBATCH --time=1-12:00:00       # Run time (d-hh:mm:ss)
#SBATCH --account=project_<id>  # Project for billing

# All commands must follow the #SBATCH directives

# Set the number of threads based on --cpus-per-task
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

# Launch MPI code 
srun ./your_application # Use srun instead of mpirun or mpiexec
```

## Serial Job

Below is an example job script for a serial application. It requests 1 task in
the LUMI-C `small` partition and thus will be allocated 1 core.

```bash
#!/bin/bash -l
#SBATCH --job-name=examplejob   # Job name
#SBATCH --output=examplejob.o%j # Name of stdout output file
#SBATCH --error=examplejob.e%j  # Name of stderr error file
#SBATCH --partition=small       # Partition name
#SBATCH --ntasks=1              # One task (process)
#SBATCH --time=00:15:00         # Run time (hh:mm:ss)
#SBATCH --account=project_<id>  # Project for billing
 
./your_application
```
