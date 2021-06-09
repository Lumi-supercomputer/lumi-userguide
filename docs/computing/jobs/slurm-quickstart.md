# Slurm Quickstart

An HPC cluster is made up of a number of compute nodes, which consist of one or
more processors, memory and in the case of the GPU nodes, GPUs. These computing
resources are allocated to the user by the resource manager. This is achieved
through the submission of jobs by the user. A job describes the computing
resources required to run application(s) and how to run it. LUMI uses Slurm
as the batch scheduler and resource manager.

## Slurm commands overview

In the following, you will learn how to submit your job using the
[Slurm Workload Manager][1]. If you're familiar with Slurm, you
probably won't learn much and will be more interested in learning
how to submit jobs to the [LUMI-C][2] and [LUMI-G][3] partitions. If you
aren't acquainted with Slurm, the following will introduce you to
the basics.

The main commands for using Slurm are summarized in the table below.

| Command   | Description                                                 |
| --------- | ----------------------------------------------------------- |
| `sbatch`  | Submit a batch script                                       |
| `srun`    | Run a parallel job(step)                                    |
| `squeue`  | View information about jobs in the scheduling queue         |
| `scancel` | Signal or cancel jobs, job arrays or job steps              |
| `sinfo`   | View information about nodes and partitions                 |

[1]: https://slurm.schedmd.com/
[2]: computing/jobs/lumic.md
[3]: computing/jobs/lumig.md

### Batch script

The most common type of jobs are batch jobs which are submitted to the 
scheduler using a batch job script and the `sbatch` command. 

A batch job script is a text file containing information about the job
to be run: the amount of computing resource and the tasks that must be executed.

A batch script is summarized by the following steps:

- the interpreter to use for the execution of the script: bash, python, ...
- directives that define the job options: resources, run time, ...
- setting up the environment: prepare input, environment variables, ...
- run the application(s)

As an example let's look at this simple batch job script:

```
#!/bin/bash
#SBATCH --job-name=exampleJob
#SBATCH --account=myAmazingProject
#SBATCH --time=02:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=2G
#SBATCH --partition=small

module load MyApp/1.2.3

srun myapp -i input -o output
```

In the previous example, the first line `#!/bin/bash` specifies that the script
should be interpreted as a bash script.

The lines starting with `#SBATCH` are directives for the workload manager.
These have the general syntax

```
#SBATCH option_name=argument
```

Now that we have introduced this syntax, we can go through the directives one
by one. The first directive is

```
#SBATCH --job-name=exampleJob
```

which sets the name of the job. It can be used to identify a job in the queue
and other listings. The second directive sets the billing project for the job

```
#SBATCH --account=myAmazingProject
```

The account argument is mandatory. Failing to set it will cause the job to 
be held with the reason `AssocMaxJobsLimit`. 

The remaining lines specify the resources needed for the job. 
The first one is the **maximum** time your job can run. If your job exceeds
the time limit, it is terminated regardless of whether it has finished or not. 

```
#SBATCH --time=02:00:00
```

The time format is ``hh:mm:ss`` (or `d-hh:mm:ss` where `d` is the number of
days). Therefore, in our example, the time limit is 2 hours. 

The next four lines of the script describe the computing resources that the job
will need to run

```
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=2G
```

In this instance we request one task (process) to be run on one node. A task
corresponds to a process (or an MPI rank). One CPU thread (used, for example, with
OpenMP) is requested for the one task as well as 2 GiB of memory should
be allocated to the whole job.

The next line defines the partition to which the job will be submitted.
Partitions are (possibly overlapping) groups of nodes with similar resources or
associated limits. In our example, the job does not use a lot of resources and
will fit perfectly onto the `small` partition. See [partitions][4] for more
informations about the available partitions.

```
#SBATCH --partition=small
```

Now that the needed resources for the job have been defined, the next step is
to set up the environment. For example, copy input data from your home
directory to the scratch file system or export environment variables.

```
module load MyApp/1.2.3
```

In our example, we load a module so that the `MyApp` application is available
to the batch job. Finally, with everything set up, we can launch our program
using the `srun` command.

```
srun myapp -i input -o output
```

[4]: /computing/jobs/partitions/

### Submit a batch job 

To submit the job script we just created we use the `sbatch` command. The
general syntax can be condensed as

```
sbatch [options] job_script [job_script_arguments ...]
```

The available options are the same as the one you use in the batch script:
`sbatch --nodes=2` in the command line and `#SBATCH --nodes=2` in a batch
script are equivalent. The command line value takes precedence if the same
option is present both on the command line and as a directive in a script. 

For the moment let's limit ourselves to the most common way to use the
`sbatch`: passing the name of the batch script which contains the submission
options.

```bash
$ sbatch myjob.sh
Submitted batch job 123456
```

The `sbatch` command returns immediately and if the job is successfully
submitted, the command prints out the ID number of the job.

### Examine the queue

Once you have submitted your batch script it won't necessarily run immediately.
It may wait in the queue of pending jobs for some time before its required
resources become available. In order to view your jobs in the queue, use the
`squeue`.

```
$ squeue
  JOBID PARTITION     NAME     USER  ST       TIME  NODES NODELIST(REASON)
 123456     small exampleJ lumi_usr  PD       0:00      1 (Priority)
```

The output shows the state of your job in the `ST` column. In our case, the
job is pending (`PD`). The last column indicates the reason why the job isn't
running: `Priority`. This indicates that your job is queued behind a higher
priority job. One other possible reason can be that your job is waiting for
resources to become available. In such a case, the value in the `REASON` column
will be `Resources`.

Let's look at the information that will be shown if your job is running:

```
$ squeue
  JOBID PARTITION     NAME     USER  ST       TIME  NODES NODELIST(REASON)
 123456     small exampleJ lumi_usr   R      35:00      1 node-0123
```

The `ST` column will now display a `R` value (for `RUNNING`). The `TIME` column
will represent the time your job is running and the list of nodes on which your
job is executing will be given in the last column of the output.

In practice the list of jobs printed by this command will be much longer,
since all jobs, including those belonging to other users, will be visible.
In order to see only the jobs that belong to you use the `squeue` command with
the `--me` flag.

```
squeue --me
```

The `squeue` command can also be used to determine when your pending job will
start.

```
squeue --me --start
 JOBID PARTITION     NAME     USER ST          START_TIME  NODES SCHEDNODES           NODELIST(REASON)
123456     batch Computat   vananh PD 2021-06-01T16:10:28      1 node0012             (Priority)
123457     batch Computat   vananh PD 2021-06-01T18:21:28      1 (null)               (Priority)
```

In our example, both jobs listed will start June 1 at different time. You will
also notice that for the first the scheduler plan to run the job on `node0012`
while for the second no node has been choosen yet.

### Cancelling a job

Sometimes things just don't go as planned. If your job
doesn't run as expected, you may need to cancel your job. This can be achieved
using the `scancel` command which takes the job ID of the job to cancel. 

```
scancel <jobid>
```

The job ID can be obtained from the output of the `sbatch` command when
submitting your job or by using `squeue`. The `scancel` command applies to
either a pending job waiting in the queue or to an already running job. In the
first case, the job will simply be removed from the queue while in the latter,
the execution will be stopped.

## Serial and shared memory jobs

In serial or in shared-memory parallelism, applications achieve parallelism by
executing one or multiple threads within one compute node. This means that with
shared memory parallelism, jobs are limited to the total amount of memory and
cores on one node.

In the introductory example we discuss a serial job.

```
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
```

In case, you want to run a threaded application that will use 32 threads, then
specify that you will have 32 threads with the `--cpus-per-task=32` directive.

```
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
```

In the example above, we consider the case of an OpenMP application. OpenMP is
not Slurm-aware, so we also export the `OMP_NUM_THREADS` environment variable.
This is accomplished by setting `OMP_NUM_THREADS` to `$SLURM_CPUS_PER_TASK`
which is an environment variable created by Slurm and whose value is set by
`--cpus-per-task`. 

!!! warning
    If the application has a command-line option to set the number of threads, 
    it should always be used to make sure the software behaves as expected.


The required memory per node is specified using `--mem`. For example, if the job
requires 16 GiB to be allocated you can use the directive:

```
#SBATCH --mem=16G
```
Different units for the memory allocation can be specified using the suffix
`K`, `M`, `G` and `T` for Kilo, Mega, Giga and Tera bytes respectively. Another
option is to specify the memory per allocated CPU with `--mem-per-cpu`.

```
#SBATCH --cpus-per-task=32
#SBATCH --mem-per-cpu=512M
```

Where a total of `32 CPU * 512 M/CPU = 16 GiB` of memory will be allocated to the job
which is an equivalent memory allocation that the previous example where memory
is allocated on a per node basis.

!!! note
    The `default` partition is set up in exclusive mode, meaning that jobs can
    not share nodes with other running jobs. Thus, you will have access to all 
    the memory of the node.


## MPI-based jobs

MPI parallelization is based upon processes communicating by passing messages.
The number of MPI ranks to be allocated is specified by

```
#SBATCH --ntasks=256
```

As MPI processes all have their separate memory space. These processes can be
distributed among several compute nodes. For example, you can spread the 256
tasks of the previous example among 4 nodes using the `--nodes` directive and
then specify the number of tasks per node with the `--ntasks-per-node`
directive. 

```
#SBATCH --nodes=4
#SBATCH --ntasks-per-node=64
```

## Hybrid MPI+OpenMP jobs

For hybrid MPI+OpenMP jobs, you have to use a combination of the directives 
discussed previously:

```
#SBATCH --nodes=4
#SBATCH --ntasks-per-node=16
#SBATCH --cpus-per-task=8
```

In this example, the job requires 4 nodes (`--nodes`). On each of these nodes, 
16 tasks (MPI ranks, `--ntasks-per-node`) will be spawned. Each task uses 8
threads which is specified by the `--cpus-per-task` directive.
