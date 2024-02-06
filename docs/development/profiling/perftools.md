# Cray Performance Analysis Tool

[sampling]: #sampling
[lite]: #perftools-lite

[Cray Performance Analysis Tool (CrayPat)](https://cpe.ext.hpe.com/docs/#profiling-and-performance-optimization-tools) is a performance analysis tool used to
evaluate program behaviour on HPE Cray supercomputer systems like LUMI.

## Perftools-lite

The `perftools-lite` is a simplified and easy-to-use version of CrayPat that
provides basic performance analysis information automatically, with minimum
user interaction.
To use `perftools-lite` you must first load the `perftools-base` module followed by `perftools-lite`.

```bash
$ module load perftools-base
$ module load perftools-lite
```

After these modules have been loaded, subsequent compiler invocations (`cc`,
`CC`, `ftn`) will automatically insert all necessary hooks for profiling.

```bash
$ cc -o app.x source.c 
WARNING: PerfTools is saving object files from a temporary directory into
directory '/home/olouant/.craypat/app.x/846040'
INFO: creating the PerfTools-instrumented executable 'app.x' 
(lite-samples) ...OK
```

You can then run your application as you would normally. The profiling
information will be written to the standard output.

Other `perftools-lite` modules are available for users seeking information
other than that provided by the default `perftools-lite` module:

- `perftools-lite-events`: event profile (tracing)
- `perftools-lite-gpu`: GPU kernel and data movement events profiling
- `perftools-lite-loops`: loop work estimates
- `perftools-lite-hbm`: memory profiling

Once you have them loaded, these modules can be used in the same way as
`perftools-lite`.

## CrayPat

CrayPat is the full-featured program analysis tool set. The typical workflow is

- use `pat_build` to instrument a program
- run the instrumented executable
- use either `pat_report` or Cray Apprentice2 to view the resulting report.

### Sampling

Sampling is a statistical profiling. By taking regular snapshots of the
applications call stack, we can create a statistical profile of where the
application spends most of its time.

<figure>
  <img 
    src="../../../assets/images/sampling.svg"
    width="450"
    alt="Sampling of an application"
  >
  <figcaption>
    Sampling of an application. Snapshots of the application's call stack are
    captured at regular intervals to create a statistical profile.
  </figcaption>
</figure>

One of the main advantages of a sampling experiment is the low overhead
fixed by the choice of sampling rate.
On the other hand, sampling is non-deterministic and can only provide a
statistical picture of the application behavior.

The `pat_build` tool is used to instrument your application. The first step to
use this tool is to load the `perftools-base` and `perftools` modules and build
your application as normal.

```bash
$ module load perftools-base
$ module load perftools

$ cc -o app.x source.c
```

The second step is to use `pat_build`.

```bash
$ pat_build app.x
```

This command will create a new executable with name `<exec>+pat`. In our
example, we will produce `app.x+pat`. The name can be chosen by the user using
the `-o <output_exe>` option. The default experiment is a sampling experiment.

The next step is to run the application. A directory with a name beginning with
the name of your application will be created as a result. This directory
contains the profiling information gathered during the run. You can change the
name of this output directory with the `PAT_RT_EXPDIR_NAME` environment
variable. For example

```bash
$ export PAT_RT_EXPDIR_NAME=apa_sample_exp.${SLURM_JOBID}
$ srun ./app.x+pat
```

You can use this directory to generate a more detailed report with the
`pat_report` command.

```bash
$ pat_report <perftool-output-dir>
```

### Tracing

Tracing revolves around specific program events like entering or exiting a
function. This allows the collection of accurate information about specific
areas of the code every time the event occurs. This allows for more accurate
and detailed information as data is collected from every traced function
call, not a statistical average. Tracing may require the program to be
instrumented.

<figure>
  <img 
    src="../../../assets/images/tracing.svg"
    width="450"
    alt="Tracing of an application"
  >
  <figcaption>
    Instrumentation of an application for tracing. The instrumentation code is
    inserted so that all events of interest are captured allowing for much more
    detailed information.
  </figcaption>
</figure>

The main downside is that the instrumentation code inserted will be run every
time an instrumented function is called to record the information.
This may introduce significant profiling overhead.

#### Automatic program analysis (APA)

You can do a focused tracing experiment based on the results from the [sampling
experiment][sampling]. This is achieved by providing `pat_build` with a
`build-options.apa` file generated with `pat_report` from a previous sampling
run.

```bash
$ pat_build -O <pertools-out-dir>/build-options.apa
```

This will build a new executable whose name ends with `+apa`. You can then run
this executable to get tracing data and generate a report with `pat_report`.

#### Manual analysis

If the automatic program analysis is not sufficient, you have to manually
choose your profiling setup. The tracing of the entire program is made possible
by using the `-w` option when building your application with `pat_build`

```bash
$ pat_build -w app.x
```

Another possibility is to select the function belonging to a particular trace
function group. For example, for the MPI group functions

```bash
$ pat_build -g mpi app.x
```

where the `-g` option is used to select a trace group. There is support for a
wide variety of predefined function groups. A full list can be obtained from
the `pat_build` manpage.

User-defined function can be traced with the `-T` option and provide a list of
function names, or use the `-t` option and provide a file listing the functions
to trace.

```bash
$ pat_build -w -T func1,func2 app.x
$ pat_build -w -t tracefile app.x
```

Be careful when you specify the name of the function as the compiler may have
altered the name. For example, an underscore character may have been added to
the Fortran routine. You can use `nm <app>` or `readelf -s <app>` to read the
symbol table of your application. In addition, you can choose to trace all the
user-defined function, with the `-u` option.

```bash
$ pat_build -u app.x
```

Of course, you can combine the option presented above to match your needs. For
example, you can choose to trace the MPI and OpenMP group and all the
user-defined functions.

```bash
$ pat_build -g mpi,omp -u app.x
```
