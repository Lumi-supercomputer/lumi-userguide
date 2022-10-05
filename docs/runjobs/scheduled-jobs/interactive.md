# Interactive Slurm jobs

[sbatch-options]: ../../runjobs/scheduled-jobs/batch-job.md#common-slurm-options

Interactive jobs allow a user to interact with applications on the compute
nodes. With an interactive job, you request time and resources to work on a
compute node directly, which is different to a batch job where you submit your
job to a queue for later execution.

You can use two commands to create an interactive session: `srun` and `salloc`.
Both of these commands take [options similar to `sbatch`][sbatch-options].

## Using `salloc`

Using `salloc`, you allocate resources and spawn a shell that is then used to
execute parallel tasks launched with `srun`. For example, you can allocate 2
nodes for 30 minutes with the command

```bash
$ salloc --nodes=2 --account=<project> --time=00:30:00
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
$ srun --account=<project> --time=00:30:00 --nodes=1 --pty bash
```

## Using `srun` to check running jobs

Currently, ssh'ing to compute nodes is not allowed, but the `srun` command can
be used to check in on a running job in the cluster. In this case, you need to
give the job ID and possibly also the specific name of a compute node to `srun`.

This starts a shell, where you can run any command, on the first allocated node
in a specific job:

```bash
$ srun --overlap --pty --jobid=<jobid> bash
```

To check processor and memory usage quickly, you can run `top` directly:

```bash
$ srun --overlap --pty --jobid=<jobid> top
```

The `-w nid00XXXX` option can be added to select a specific compute node to view:

```bash
$ srun --overlap --pty --jobid=<jobid> -w nid002217 top
```

You can see which compute node(s) your job is allocated to by running the
`squeue` command and looking in the "NODELIST" column.

If you want to do this on the Early Access Platform with GPUs, you need to give
an extra flag: `--gpus-per-task=0`, otherwise your monitoring job will not run.
For example, to run the `rocm-smi` command on an EAP node and check the GPU
usage, do like this:

```bash
$ srun --gpus-per-task=0 --overlap --jobid=<jobid> --pty rocm-smi
```
