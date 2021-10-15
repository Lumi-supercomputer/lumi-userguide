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

## User registration 

Regarding the user registration and project creation please see [accounts](../accounts/registration.md).

## How to log in

Connect using a ssh client:

```
ssh username@login.lumi-supercomputer.eu  (FIXME)
```

where you need to replace `username` with your own username, which you received via email during the registration. If you cannot get 
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

In order to run, you need a project allocation. Please check that you are member
of project with an active allocation with the `FIXME` command:

```
FIXME
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

To run this job, copy the input files from FIXME into your scratch directory and submit the job with the sbatch command:

    cd /scratch/disk/myprojectname
    cp /FIXME/HPL/smalldemo .
    vim/emacs job.sh
    (copy-paste above and save)
    sbatch job.sh

- [More information about running jobs on LUMI](../computing/index.md)

## Where to store data

On LUMI, there are several disk areas: home, projects, scratch (LUMI-P) and fast 
flash-backed scratch (LUMI-F). Please familiarize yourself with the areas and 
their specific purposes.

* **Home**: /users/username. Use mainly for configuration files and source code. The home directory is not intended for data analysis or computing. There is no cleaning and the files are backed up.
* **Project**: /project/projectname. Use to store analyzed results and to share e.g. software installations with other project members. There is no cleaning but files are not backed up!
* **Scratch** /scratch/disk/projectname and a smaller, but faster /scratch/flash/projectname area. Use these when running jobs. Shared with other project members. The files are not backed up! Old files are cleaned automatically after 90 days. Any data that should be preserved for a longer time should be copied either to /project or to the LUMI-O storage. 

* **Again: only the home directory is backed up!**
* **Again: files in /scratch are deleted after 90 (FIXME) days!**

An overview of your directories in a supercomputer you are currently logged on can be displayed with the lumi-workspaces command. Please verify that you get similar looking output when running the command. If not, please contact support.

    [kkayttaj@puhti ~]$ csc-workspaces 
    Disk area               Capacity(used/max)  Files(used/max)  Project description  
    ----------------------------------------------------------------------------------
    Personal home folder
    ----------------------------------------------------------------------------------
    /users/kkayttaj                2.05G/10G       23.24k/100k

    Project applications 
    ----------------------------------------------------------------------------------
    /projappl/project_2012345     3.056G/50G       23.99k/100k   Ortotopology modeling
    
    Project scratch 
    ----------------------------------------------------------------------------------
    /scratch/project_2012345        56G/1T         150.53k/1000k Ortotopology modeling
    
**The scratch and projects directories are meant to be shared by all the members
of the project**. All new files and directories are also fully accessible for 
other group members (including read, write and execution permissions). If you 
want to have a private area in scratch and projects, you can create your own 
personal folder in there and restrict access from your group members with the 
`chmod` command. For example, setting read-only permissions for your group members for the directory my_directory:

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

* How to contact support
* Links to start of doc pages
* Links to Cray docs (if publically available)
* Links to AMD ROCm docs
