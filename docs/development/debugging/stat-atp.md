# Crash and deadlock

[1]: #stat-the-stack-trace-analysis-tool
[2]: #cray-atp-abnormal-termination-processing

This page is meant to help a user determine the cause of a program failure and
diagnose a program that hangs. In the following, two tools are presented: the
[Stack Trace Analysis Tool][1] (STAT) and the [Abnormal Termination
Processing][2] (ATP). Both tools rely on the analysis of the stack backtrace to
determine where the application is stalled or view where the application was at
the time of the crash.
See also the Cray documentation page about [debugging tools in Cray Programming Environment](https://cpe.ext.hpe.com/docs/#debugging-tools).

## STAT: The Stack Trace Analysis Tool

The Stack Trace Analysis Tool (STAT) is a highly scalable, lightweight tool
that gathers and merges stack traces[^1] from all the processes of a
parallel application. STAT is most effective for diagnosing parallel
applications that are hung, i.e. suffers from a deadlock[^2] or livelock[^3].

## Cray ATP: Abnormal Termination Processing

The Abnormal Termination Processing (ATP) is a tool that monitors a running
program. In the event of a fatal signal encountered by the program, ATP will
handle the signal and perform analysis on the dying application.

### Usage

Using ATP requires that the target application is built with debug symbols
(`-g` compiler flag).

The next step is to set the `ATP_ENABLED` environment variable in you batch
script. It's also recommended to set the maximum size of core files to
`unlimited`.

```bash
module load atp

export ATP_ENABLED=1
ulimit –c unlimited

srun <srun_options> ./application
```

[THIS SECTION NEEDS TO BE WRITTEN]: <> (### Viewing the Results)

[^1]: A stack trace represents a call stack at a certain point in time, listing
      the function calls that lead up to the call that caused a problem.
[^2]: Deadlock is a situation when two threads (or processes) are waiting for
      each other and the waiting is never ending.
[^3]: Livelock occurs when two or more processes continually repeat the same
      interaction in response to changes in the other processes without doing
      any useful work.
