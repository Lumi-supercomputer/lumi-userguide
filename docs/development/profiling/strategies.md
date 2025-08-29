[lite]: ./perftools.md#perftools-lite
[sampling]: ./perftools.md#sampling
[tracing]: ./perftools.md#tracing

# Performance analysis strategies

Profiling reveals performance issues and informs you about where your
application spends most of its time. Once you have identified bottlenecks, you
then focus your efforts on investigating those parts and improve them.

## Quick profiling

For a quick profiling, you can use the `perftools-lite` tool, a simplified and
easy-to-use version of CrayPat that provides basic performance analysis
information automatically, with minimum user interaction.

- [See how to use `perftools-lite`][lite]

## Sampling

Sampling consists of taking regular snapshots of the application's call stack to
create a statistical profile. This is a good option for low overhead profiling.

- [See how to run a sampling experiment with CrayPat][sampling]

## Tracing

Tracing is a profiling technique that captures specific program events,
such as entering or exiting a function, every time they occur. This allows
the collection of accurate profiling information about specific areas of the code.

- [See how to run a tracing experiment with CrayPat][tracing]
