# Overview

When you log in to LUMI, you end up on one of the login nodes. These login nodes
are shared by all users and they are not intended for heavy computing.

The login nodes should be used only for:

- compiling (but consider allocating a compute for large build jobs)
- managing batch jobs
- moving data
- light pre- and postprocessing (a few cores / a few GB of memory)

All the other tasks should be done on the compute nodes either as normal batch
jobs or as interactive batch jobs. Programs not adhering to these rules will be
terminated without warning.

Compute intensive jobs must be submitted to the job scheduling system. LUMI uses
Slurm as the job scheduler. In order to run, you need a project allocation. 
You need to specify your project ID in your job script (or via the command line
when submitting your job) in order for your job to be submitted to the queue. 

!!! missing

    Commands to gather information about the project and quota are not
    available yet. However, you can use the `groups` command to retrieve your 
    project ID when connected to LUMI: you should see that you are part of a 
    group named `project_xxxxxxxxx`.

Here is a typical batch script for Slurm. This script runs an application
on 2 compute nodes with 16 MPI ranks on each node (32 total) and 8 OpenMP 
threads per rank.

```
$ cat batch_script.slurm
#!/bin/bash -l
#SBATCH --job-name=test-job
#SBATCH --account=<project_xxxxxxxxx>
#SBATCH --time=01:00:00
#SBATCH --nodes=2
#SBATCH --ntasks=32
#SBATCH --ntasks-per-node=16
#SBATCH --cpus-per-task=8
#SBATCH --partition=standard

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
srun ./application
```




