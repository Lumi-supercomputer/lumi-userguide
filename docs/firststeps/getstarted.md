---
hide:
  - navigation
---

!!! warning
    This page is a placeholder, it does not reflect the actual first steps with
    LUMI.

# Get Started with LUMI

Please read through all of this carefully before you start running on LUMI. Here
we describe the a few set of basic rules and the important information that you
need to get started running jobs.

We start from the assumption that you have received your account information.
If not please see this page [Accounts/how to get an account].

## How to log in

Connect using a ssh client:

ssh username@login.lumi-supercomputer.eu

where you need to replace `username` with your own username. If you cannot get 
a connection at all, your IP number range might be blocked from login. 
Please contact Support.

## Where to run

When you login to LUMI, you end up on one of the login nodes. These login nodes
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
Slurm as the job scheduler.

## How to run

In order to run, you need a project allocation. Please check that you are a member
of a project with an active allocation with `TODO` command

```
TODO
```

**TODO:** describe how to get your project ID

Here is a typical batch script for Slurm. This script runs an application
on 2 compute nodes with 16 MPI ranks on each node (32 total) and 8 OpenMP 
threads per rank.

```
$ cat batch_script.slurm
#!/bin/bash -l
#SBATCH --job-name=test-job
#SBATCH --account=<project>
#SBATCH --time=01:00:00
#SBATCH --nodes=2
#SBATCH --ntasks=32
#SBATCH --ntasks-per-node=16
#SBATCH --cpus-per-task=8
#SBATCH --partition=standard

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
srun ./application
```

This script is submitted to the resource manager using the `sbatch` command.

```
sbatch batch_script.slurm
```

- [More information about running jobs on LUMI](../computing/index.md)

## Where to store data

On LUMI there are several disk areas: home, projects, scratch (LUMI-P) and fast 
flash-backed scratch (LUMI-F):

- **User home**: the home directory (`$HOME`) can be used to store your 
  configuration files and personal data
- **Project persistent storage**: the project persistent storage is intended to 
  share data amongst the members of a project. Typically, this space can be used
  to share applications and libraries compiled for the project
- **Parallel Filesystems (Scratch)**: the scratch spaces are Lustre file systems
  intended as **temporary** storage for input, output or checkpoint data of 
  your application. LUMI offers 2 types of scratch storage solution: LUMI-P 
  with spinning disks and LUMI-F based on flash storage.

An overview of your directories in a supercomputer you are currently logged on
can be displayed with the `TODO` command. Please verify that you get
similar looking output when running the command. If not, please contact support.

```
TODO demonstrate the storage managment commands
```
    
**The scratch and projects directories are meant to be shared by all the members
of the project**. All new files and directories are also fully accessible for 
other group members (including read, write and execution permissions). If you 
want to have a private area in scratch and projects, you can create your own 
personal folder there and restrict access from your group members with the 
chmod command.

Setting read-only permissions for your group members for the directory my_directory:

    mkdir my_directory
    chmod -R g-w my_directory

- [Learn more about the LUMI storage](../storage/index.md)

## Compiling and Developing your Code

LUMI comes with the multiple programming environments: Cray, GNU and AOCC. 
In addition, the most common libraries used in an HPC environment tuned for LUMI
are also available. Parallel debugger and profiling tools are also at one's 
disposal.

- [Learn more about the programming environments](../development/compiling/prgenv.md)
- [Learn more about debugging](../development/debugging/gdb4hpc.md)
- [Learn more about profiling](../development/profiling/index.md)

## Getting Help

The LUMI User Support Team is here to help if you have any question or problem
regarding your usage of LUMI.

- [How to contact LUMI User Support Team](../generic/helpdesk.md)