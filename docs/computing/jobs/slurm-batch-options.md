# Slurm Guide

## Batch job: `sbatch` and `srun`

`sbatch` is used to submit a job script for later execution. The script will typically contain the Slurm submission options (preceded by the string `#SBATCH`) and commands to setup the environment, transfer data in and out, and run applications.

| Option (long)       | Description                                                 |
| --------------------|-------------------------------------------------------------|
| `--time`            | Set a limit on the total run time of the job                |
| `--nodes`           | Set the number of nodes                                     |
| `--ntasks`          | Set the maximum number of tasks (MPI ranks)                 |
| `--ntasks-per-node` | Set the number of tasks per node                            |
| `--cpus-per-task`   | Set the number of processors per task                       |
 
## Show jobs, nodes and partitions


