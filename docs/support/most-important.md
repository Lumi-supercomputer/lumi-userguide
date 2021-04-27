# The most important information

Please read through all of this carefully before you start running on LUMI. Here we describe the a few set of basic rules and the important information that you need to get started running jobs.

We start from the assumption that you have received your account information. If not please see this page [Accounts/how to get an account].

## How to log in

Connect using a ssh client:

    ssh username@login.lumi-supercomputer.eu

Where yourcscusername is the username you get from CSC. If you cannot get a connection at all, your IP number range might be blocked from login. Please contact Support.

## Where to run

When you login to LUMI, you end up on one of the login nodes. These login nodes are shared by all users and they are not intended for heavy computing.

The login nodes should be used only for:

* compiling (but consider allocating a compute for large build jobs)
* managing batch jobs
* moving data
* light pre- and postprocessing (a few cores / a few GB of memory)

All the other tasks should be done on the compute nodes either as normal batch jobs or as interactive batch jobs. Programs not adhering to these rules will be terminated without warning.

LUMI uses the SLURM batch queue system and the "srun" command to launch jobs. LUMI consists of several partition with different kinds of compute nodes:

* **LUMI-C**: Jobs that uses CPU only. The nodes have 128 cores and 256, 1024, or 2048 GB memory. `#SBATCH --partition=lumi-c`
* **LUMI-G**: Jobs that uses CPU and GPUs. CPU-only jobs should not be run here unless they are part of the workflow and very short (e.g. a quick post-processing step). The nodes have 8 GPUs, 64 CPU cores, and 512 GB of memory. `#SBATCH --partition=lumi-g`
* **LUMI-D**: Jobs that require very large memory (8 TB) or Nvidia GPUs for visualization. Best use for interactive jobs, but regular batch jobs can be run with an X hour limit. `#SBATCH --partition=lumi-d`

## How to run

In order to run, you need a project allocation. Please check that you are member of project with an active allocation with lumi-projects command

    [username@lumi ~]$ lumi-projects
    -----------------------------------------------------------------
    Project: project_XXXXX    Owner: N. N.
    Title: "Machine Learning"
    Start: 2021-01-17 End: 2022-01-17 Status: open
    Budget:   1000000  Used   950000 Remain:      50000
    Latest resource grant: XXXX-XX-XX
    -----------------------------------------------------------------

The project name listed after "Project:" is what you should give as account name in SLURM when submitting jobs: `#SBATCH --account=<project>`. If you do not have a project, please contact support.

Here is a typical batch script for SLURM. This script runs the LINPACK benchmark on 2 compute nodes with 64 MPI ranks on each node (128 total) and 2 OpenMP threads per rank.

    #!/bin/bash
    #SBATCH --job-name=HPL
    #SBATCH --account=<project>
    #SBATCH --time=00:05:00
    #SBATCH --nodes=2
    #SBATCH --ntasks-per-node=64
    #SBATCH --cpus-per-task=2
    #SBATCH --partition=lumi-c
    ##SBATCH --mail-type=BEGIN #uncomment to enable mail

    module load partition/LUMI-CPU
    module load LUMI-21.02
    module load HPL

    export OMP_NUM_THREADS=1
    srun HPL

To run this job, copy the input files from .. into your scratch directory and submit the job with the sbatch command

    cd /scratch/disk/myprojectname
    cp /software/HPL/smalldemo .
    vim/emacs job.sh
    (copy-paste above and save)
    sbatch job.sh

The job should finish within 10 minutes. Check that it has run correctly...

## Where to store data

On LUMI there are several disk areas: home, projects, scratch (LUMI-P) and fast flash-backed scratch (LUMI-F). Please familiarize yourself with the areas and their specific purposes.

* **Home**: /users/username. Use mainly for configuration files and source code. The home directory is not intended for data analysis or computing. There is no cleaning and the files are backed up.
* **Project**: /project/projectname. Use to store analyzed results and to share e.g. software installations with other project members. There is no cleaning but files are not backed up!
* **Scratch** /scratch/disk/projectname and a smaller, but faster /scratch/flash/projectname area. Use these when running jobs. Shared with other project members. The files are not backed up! Old files are cleaned automatically after 90 days. Any data that should be preserved for a longer time should be copied either to /project or to the LUMI-O storage. 

* **Again: only the home directory is backed up!**
* **Again: files in /scratch are deleted after 90 days!**

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
    
**The scratch and projects directories are meant to be shared by all the members of the project**. All new files and directories are also fully accessible for other group members (including read, write and execution permissions). If you want to have a private area in scratch and projects, you can create your own personal folder there and restrict access from your group members with the chmod command.

Setting read-only permissions for your group members for the directory my_directory:

    mkdir my_directory
    chmod -R g-w my_directory

## More information

* How to contact support
* Links to start of doc pages
* Links to Cray docs (if publically available)
* Links to AMD ROCm docs