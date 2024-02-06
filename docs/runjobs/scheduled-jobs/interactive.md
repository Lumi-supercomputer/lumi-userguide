# Interactive Slurm jobs

[sbatch-options]: ../../runjobs/scheduled-jobs/batch-job.md#common-slurm-options

Interactive jobs allow a user to interact with applications on the compute
nodes. With an interactive job, you request time and resources to work on a
compute node directly, which is different to a batch job where you submit your
job to a queue for later execution.

You can use two commands to create an interactive session: `srun` and `salloc`.
Both of these commands take [options similar to `sbatch`][sbatch-options].

## Using `salloc`

Using `salloc`, you allocate resources and spawn a shell used to
execute parallel tasks launched with `srun`. For example, you can allocate 2
nodes for 30 minutes with the command

```bash
$ salloc --nodes=2 --account=<project> --partition=<partition> --time=00:30:00
salloc: Granted job allocation 123456
salloc: Waiting for resource configuration
```

Once the allocation is made, this command will start a shell **on the login
node**. You can start parallel execution on the allocated nodes with `srun`.

```bash
$ srun --ntasks=32 --cpus-per-task=8 ./mpi_openmp_application
```

After the execution of your application ended, the allocation can be terminated
by exiting the shell (`exit`).

When using `salloc`, a shell is spawned on the login node. If you want to
obtain a shell on the first allocated compute node you can use `srun --pty`.

```bash
$ srun --cpu_bind=none --nodes=2 --pty bash -i
```

If you want to use an application with a GUI, you can use the `--x11` flag with
`srun` to enable X11 forwarding.

## Using `srun`

For simple interactive session, you can use `srun` with no prior allocation. In
this scenario, `srun` will first create a resource allocation in which to run
the job. For example, to allocate 1 node for 30 minutes and spawn a shell

```bash
$ srun --account=<project> --partition=<partition> --time=00:30:00 --nodes=1 --pty bash
```

## Using `srun` to check running jobs

Currently, `ssh`'ing to compute nodes is not allowed, but the `srun` command can
be used to check in on a running job in the cluster. In this case, you need to
give the job ID and possibly also the specific name of a compute node to `srun`.

This starts a shell where you can run any command on the first allocated node
in a specific job:

```bash
$ srun --overlap --pty --jobid=<jobid> $SHELL
```

By default, you will be connected to the master node of your job which is the 
first node in your allocation and the one on which your batch script is executed. 

If your job spans multiple nodes and you need to connect to a specific compute node,
you can achieve this by adding the `-w nid00XXXX` option.

```bash
$ srun --overlap --pty --jobid=<jobid> -w nid00XXXX $SHELL
```

where `nid00XXXX` is the hostname of the node you wish to access. To obtain the
list of allocated nodes for a specific job with ID `<jobid>`, you can utilize 
the following command:

```bash
$ sacct --noheader -X -P -oNodeList --jobs=<jobid>
```

!!! note "GPUs resource specification"

    Depending on how you have specified the GPU resources allocated to your job, 
    you may encounter the following error when attempting to attach to a running
    job:

    ```bash
    srun: error: Unable to create step for job 4203072: Invalid generic 
                  resource (gres) specification
    ```

    This error arises when you specify the number of GPUs using the
    `--gpus=<numgpus>` option, i.e., the total number of GPUs to allocate to
    your job. This value is inherited from the job and when creating the 
    interactive job step and lead to an error if there are fewer available GPUs
    on the node you try to access than what you specified with `--gpus`.

    If you encounter the aforementioned error message, you have to specify a
    number  of GPUs corresponding to the actual number of GPUs allocated on the
    node you try to access:
    
    ```bash
    srun --overlap --pty --jobid=<jobid> --gpus=<numgpus> $SHELL
    ```

