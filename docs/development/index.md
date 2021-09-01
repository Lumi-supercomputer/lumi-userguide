---
title: Development - Overview
---

# Overview

This section of the documentation aims to help the users that wants to compile, 
develop and optimize their code on LUMI. It contains information on how to 
compile, debug and profile your application. 

## Compiling

Several C, C++ and Fortran compilers are available on LUMI. They are made 
available through programming environments. In addition to compilers, 
a set highly optimized libraries at one's disposal.

- [Discover the programming environments](./compiling/prgenv.md)
- [See which libraries are available](./compiling/libraries.md)
  
## Debugging

If you are looking for this, you are in trouble and we are sorry. We know that
the process of finding and resolving bugs may be tedious. Anyway, we have great
tools to help you find out why your program that was perfectly fine yesterday is
segfaulting today.

- [Debug your application](./debugging/gdb4hpc.md)
- [Memory debugging](./debugging/valgrind4hpc.md)
- [Determine why your application crashed or deadlock](./debugging/stat-atp.md)

## Profiling

The best way to extract the best performance is to know your program. 
It is precisely what profiling is all about: collecting information about the 
performance of your application. These informations will help you to optimize 
your program for faster execution and more efficient computing resource usage.