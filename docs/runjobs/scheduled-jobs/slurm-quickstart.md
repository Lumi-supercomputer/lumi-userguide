[slurm]: https://slurm.schedmd.com/
[slurmlearning]: http://slurmlearning.deic.dk/
[partitions]: ../../runjobs/scheduled-jobs/partitions.md
[batch-jobs]: ../../runjobs/scheduled-jobs/batch-job.md
[accesslumi]: ../../firststeps/accessLUMI.md
[billing]: ../../runjobs/lumi_env/billing.md

# Slurm quickstart

An HPC cluster is made up of a number of compute nodes, which consist of one or
more processors, memory and in the case of the GPU nodes, GPUs.
The resource manager allocates these computing resources to the user. This is achieved
through the submission of jobs by the user. A job describes the computing
resources required to run application(s) and how to run it. LUMI uses
[Slurm][slurm] as job scheduler and resource manager.

To run jobs, you need a [project allocation][accesslumi]. You need to
specify your project ID in your job script (or via the command line when
submitting your job) in order for your job to be accepted by the job scheduler.

!!! info

    You can use the `lumi-allocations` command to list the projects of which you
    are a member. This command will also list your allocated and used compute 
    and storage [billing units][billing].
    
    Alternative is to use the `groups` command: you should see that you are
    part of a group named `project_xxxxxxxxx`.

## Slurm commands overview

In the following, you will learn how to submit your job using the [Slurm
Workload Manager][slurm]. If you're familiar with Slurm, you probably won't
learn much. However, If you aren't acquainted with Slurm, the following will
introduce you to the basics. If you would like to play around with Slurm in a
sandboxed environment before submitting real jobs on LUMI, we highly recommend
that you try the interactive [SlurmLearning tutorial][slurmlearning].

The main commands for using Slurm are summarized in the table below.

| Command   | Description                                                 |
| --------- | ----------------------------------------------------------- |
| `sbatch`  | Submit a batch script                                       |
| `srun`    | Run a parallel job(step)                                    |
| `squeue`  | View information about jobs in the scheduling queue         |
| `scancel` | Signal or cancel jobs, job arrays or job steps              |
| `sinfo`   | View information about nodes and partitions                 |

### Creating a batch script

The most common type of job is a batch job. They are submitted to the
scheduler using a batch job script and the `sbatch` command.

A batch job script is a text file containing information about the job
to be run: the amount of computing resource and the tasks that must be executed.

A batch script is summarized by the following steps:

- the interpreter to use for the execution of the script: bash, python, ...
- directives that define the job options: resources, run time, ...
- setting up the environment: prepare input, environment variables, ...
- run the application(s)

As an example, let's look at this batch job script:

```bash
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

```bash
#SBATCH option_name=argument
```

Now that we have introduced this syntax, we can go through the directives one
by one. The first directive is

```bash
#SBATCH --job-name=exampleJob
```

which sets the name of the job. It can be used to identify a job in the queue
and other listings. The second directive sets the billing project for the job

```bash
#SBATCH --account=myAmazingProject
```

!!! error "Specify the account"

    The account option is mandatory. Failing to set it will cause the following
    error:

    ```
    Unable to allocate resources: Job violates accounting/QOS policy 
    (job submit limit, user's size and/or time limits)
    ```

The remaining lines specify the resources needed for the job. The first one is
the **maximum** time your job can run. If your job exceeds the time limit, it
is terminated regardless of whether it has finished or not.

```bash
#SBATCH --time=02:00:00
```

The time format is ``hh:mm:ss`` (or `d-hh:mm:ss` where `d` is the number of
days). Therefore, in our example, the time limit is 2 hours.

The next four lines of the script describe the computing resources that the job
will need to run

```bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=2G
```

In this instance, we request one task (process) to be run on one node. A task
corresponds to a process (or an MPI rank). One CPU thread (used, for example,
with OpenMP) is requested for the one task as well as 2 GiB of memory should be
allocated to the whole job.

The next line defines the [Slurm partition][partitions] to which the job will
be submitted. Slurm partitions are (possibly overlapping) groups of nodes with
similar resources or associated limits. In our example, the job doesn't use a
lot of resources and will fit perfectly onto the `small` partition.

```bash
#SBATCH --partition=small
```

Now that the needed resources for the job have been defined, the next step is
to set up the environment. For example, copy input data from your home
directory to the scratch file system or export environment variables.

```bash
module load MyApp/1.2.3
```

In our example, we load a module so that the `MyApp` application is available
to the batch job. Finally, with everything set up, we can launch our program
using the `srun` command.

```bash
srun myapp -i input -o output
```

More details may be found on the dedicated [batch jobs][batch-jobs] page.

### Submit a batch job

To submit the job script we just created, we use the `sbatch` command.
The general syntax can be condensed as

```bash
$ sbatch [options] job_script [job_script_arguments ...]
```

The available options are the same as the one you use in the batch script:
`sbatch --nodes=2` in the command line and `#SBATCH --nodes=2` in a batch
script are equivalent. The command line value takes precedence if the same
option is present both on the command line and as a directive in a script.

For the moment, let's limit ourselves to the most common way to use the
`sbatch`: passing the name of the batch script which contains the submission
options.

```bash
$ sbatch myjob.sh
Submitted batch job 123456
```

The `sbatch` command returns immediately. If the job is successfully
submitted, the command prints out the ID number of the job.

More details may be found on the dedicated [batch jobs][batch-jobs] page.

### Examine the queue

Once you have submitted your batch script, it won't necessarily run immediately.
It may wait in the queue of pending jobs for some time before its required
resources become available. To view your jobs in the queue, use the `squeue` command.

```bash
$ squeue
  JOBID PARTITION     NAME     USER  ST       TIME  NODES NODELIST(REASON)
 123456     small exampleJ lumi_usr  PD       0:00      1 (Priority)
```

The output shows the state of your job in the `ST` column. In our case, the job
is pending (`PD`). The last column indicates the reason why the job isn't
running: `Priority`. This indicates that your job is queued behind a higher
priority job. One other possible reason can be that your job is waiting for
resources to become available. In such a case, the value in the `REASON` column
will be `Resources`.

Let's look at the information that will be shown if your job is running:

```bash
$ squeue
  JOBID PARTITION     NAME     USER  ST       TIME  NODES NODELIST(REASON)
 123456     small exampleJ lumi_usr   R      35:00      1 node-0123
```

The `ST` column will now display a `R` value (for `RUNNING`). The `TIME` column
will represent the time your job has been running. The list of nodes on which
your job is executing is given in the last column of the output.

In practice, the list of jobs printed by this command will be much longer since
all jobs, including those belonging to other users, will be visible. To see only
the jobs that belong to you, use the `squeue` command with the `--me` flag.

```bash
$ squeue --me
```

The `squeue` command can also be used to determine when your pending job will
start.

```bash
$ squeue --me --start
 JOBID PARTITION     NAME     USER ST          START_TIME  NODES SCHEDNODES           NODELIST(REASON)
123456     batch Computat   vananh PD 2021-06-01T16:10:28      1 node0012             (Priority)
123457     batch Computat   vananh PD 2021-06-01T18:21:28      1 (null)               (Priority)
```

In our example, both jobs listed will start June 1 at different times. You will
also notice that for the first job, the scheduler plan to run the job on
`node0012` while for the second job, no node has been chosen yet.

### Cancelling a job

Sometimes things just don't go as planned. If your job doesn't run as expected,
you may need to cancel your job. This can be achieved using the `scancel`
command which takes the job ID of the job to cancel.

```bash
$ scancel <jobid>
```

The job ID can be obtained from the output of the `sbatch` command when
submitting your job or by using `squeue`. The `scancel` command applies to
either a pending job waiting in the queue or to an already running job. In the
first case, the job will simply be removed from the queue while in the latter,
the execution will be stopped.
