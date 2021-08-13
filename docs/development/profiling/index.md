# Overview

[lite]: ./perftools.md#perftools-lite
[sampling]: ./perftools.md#sampling
[tracing]: ./perftools.md#tracing

Profiling reveals performance issues and informs you about where your 
application spends most of its time. Once you have identified bottlenecks, you 
then focus your efforts on investigating those parts and improve them.

## Quick Profiling

For a quick profiling, you can use the `perftools-lite` tool, a simplified and
easy-to-use version of CrayPat that provides basic performance analysis 
information automatically, with minimum user interaction. 

- [See how to use `perftools-lite`][lite]

## Sampling

Sampling consist in taking regular snapshots of the applications call stack to 
create a statistical profile. That's a good option for low overhead profiling.

- [See how to run a sampling experiment with CrayPat][sampling]

## Tracing

Tracing revolves around specific program events like entering or exiting a 
function. This allows the collection of accurate information about specific 
areas of the code every time the event occurs.

- [See how to run a tracing experiment with CrayPat][tracing]