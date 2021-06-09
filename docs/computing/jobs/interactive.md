# Interactive Usage

[sbatch-options]: ./batch-job.md#common-slurm-options

Login nodes are not intendent for heavy computing if you want to do heavy
computing interactively, you can request a Slurm interactive session.

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

```
$ salloc --nodes=2 --account=<project> --time=00:30:00
salloc: Granted job allocation 123456
salloc: Waiting for resource configuration
```

Once the allocation is made, this command will start a shell **on the login
node**. You can start parallel execution on the allocated nodes with `srun`.

```
srun --ntasks=32 --cpus-per-task=8 ./mpi_openmp_application
```

After the execution of your application ended, the allocation can be terminated
by exiting the shell (`exit`). 

When using `salloc`, a shell is spawn on the login node. If you want to obtain 
a shell on the first allocated compute node you can use  `srun --pty`. 

```
srun --cpu_bind=none --nodes=2 --pty bash -i
```

If you want to use an application with a GUI, you can use the `--x11` flag with
`srun` to enable X11 forwarding.

## Using `srun`

For simple interactive session, you can use `srun` with no prior allocation. In 
this scenario, `srun` will first create a resource allocation in which to run 
the job. For example, to allocate 1 node for 30 minutes and spawn a shell

```
srun --account=<project> --time=00:30:00 --nodes=1 --pty bash
```