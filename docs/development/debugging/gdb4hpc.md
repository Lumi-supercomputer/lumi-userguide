# Parallel debugging

[gdb]: https://www.gnu.org/software/gdb/
[gdb-manual]: https://sourceware.org/gdb/current/onlinedocs/gdb.html/

`gdb4hpc` is a [GDB-based][gdb] parallel debugger used to debug applications.
It allows programmers to either launch an application or attach to an
already-running application.

This page is not a GDB tutorial, but simply an explanation on how to launch
your application with the debugger or attach the debugger to your application.
If you want to know more about GBD, see its [manual][gdb-manual].
See also the page in Cray documentation about [debugging tools in Cray Programming Environment](https://cpe.ext.hpe.com/docs/#debugging-tools).

!!! note
    To efficiently debug your application, it is recommended to compile
    it with the debug flag (`-g`).

To have access to `gdb4hpc`, load the corresponding module in your environment.

```bash
$ module load gdb4hpc
```

Then, run the debugger.

```bash
$ gdb4hpc
```

### Launching your application from gdb4hpc

!!! failure "gdb4hpc application launch fails"
    
    There is an ongoing issue with `gdb4hpc` that causes the launch to fail with
    the following error:

    ```
    Failed to launch CTI app.
    CTI error: cti_launchAppBarrier: mpiexec was not found in PATH. (tried SSH)
    ```

    Please export the following environment variable as temporary workaround:

    ```
    export CTI_WLM_IMPL=slurm
    export CTI_LAUNCHER_NAME=srun

    module load gdb4hpc
    ```

You can launch your application from the debugger command line interface using
the `launch` command.

```bash
$ dbg all> launch --launcher-args="<launch-args>" 
                  --args="<args>" 
                  --env="<name=value>" <handle> <application>
```

where `launch-args` are the arguments for the launcher (i.e. Slurm options).
You can use this argument to specify the project to bill with
`--account=<project>`. The parameters `--args` and `--env` allows you to pass
parameters and define environment variables for your application. The handle is
a debugger variable array specifying the number of ranks in the application.
For example, an application with a handle of `$a{16}` will launch the
application with 16 ranks.

??? example "Example debug session"
    In the example debug session presented here, we launch an MPI hello world
    application with 16 ranks.

    ```bash
    dbg all> launch $a{16} --launcher-args="--account=<project>" ./myapp
    Starting application, please wait...
    Creating MRNet communication network...
    Waiting for debug servers to attach to MRNet communications network...
    Timeout in 400 seconds. Please wait for the attach to complete.
    Number of dbgsrvs connected: [1];  Timeout Counter: [0]
    Number of dbgsrvs connected: [1];  Timeout Counter: [1]
    Number of dbgsrvs connected: [16];  Timeout Counter: [0]
    Finalizing setup...
    Launch complete.
    a{0..15}: Initial breakpoint, main at /home/olouant/mpi_hello.c:5
    dbg all> list
    a{0..15}: 5         MPI_Init(NULL, NULL);
    a{0..15}: 6
    a{0..15}: 7         int world_size;
    a{0..15}: 8         MPI_Comm_size(MPI_COMM_WORLD, &world_size);
    a{0..15}: 9
    a{0..15}: 10        int world_rank;
    a{0..15}: 11        MPI_Comm_rank(MPI_COMM_WORLD, &world_rank);
    a{0..15}: 12
    a{0..15}: 13        printf("Hello world from rank %d out of %d",
    a{0..15}: 14               world_rank, world_size);
    dbg all> break mpi_hello.c:12
    a{0..15}: Breakpoint 1: file /home/olouant/mpi_hello.c, line 12.
    dbg all> continue
    a{0..15}: Breakpoint 1, main at /home/olouant/mpi_hello.c:12
    dbg all> print world_rank
    a{0}: 0
    a{1}: 1
    ...
    a{14}: 14
    a{15}: 15
    dbg all> print world_size
    a{0..15}: 16
    dbg all> quit
    Shutting down debugger and killing application for 'a'.
    ```

### Attach to an already running application

gdb4hpc can also attach to an already running application. This is done using
the `attach` command.

```bash
dbg all> attach <handle> <jobstep>
```

The `<jobstep>` parameter will typically be `<jobid>.0` if only one `srun`
command is present in your job script.
If that is not the case, you can list your job steps with `sstat`.

```bash
$ sstat <jobid>
```

where the `<jobid>` can be determined via `squeue`. As an example, the debugger
command to attach the debugger to job step `123456.0` will be

```bash
dbg all> attach $a 123456.0
Attaching to application, please wait...
```

[THIS SECTION NEEDS TO BE WRITTEN]: <> (## CCDB: Cray Comparative Debugger)
