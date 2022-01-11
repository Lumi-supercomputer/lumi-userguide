# Distribution and Binding

[distribution]: #distribution

[srun]: https://slurm.schedmd.com/srun.html
[numa]: https://en.wikipedia.org/wiki/Non-uniform_memory_access

A compute nodes consist of a hierarchy of building blocks: one or more sockets
(processors), consisting of multiple physical cores each with one or more 
logical threads, enabling simultaneous multithreading.

<figure>
  <img 
    src="../../../assets/images/socket-core-threads.svg" 
    width="700"
    alt="Concept of socket, core and threads">
  <figcaption>Concept of socket, core and threads</figcaption>
</figure>

For example, LUMI-C compute node contains 2 sockets. Each socket has 64 physical
cores and each core has 2 logical threads. This means that you can launch up to
2 x 2 x 64 = 256 tasks (or threads) per node.

A processor can also be partitioned in [Non-Uniform Memory Access (NUMA)][numa] 
domains. These domains divide the memory into multiple domains local to a group
of cores. The memory in the local NUMA node can be accessed faster than the 
other NUMA nodes leading to better performance when a process/thread access 
memory on the local NUMA node. LUMI-C use 4 NUMA domains per socket (8 NUMA 
domains per node). Thread migration from one core to another poses a problem for
a NUMA architecture by disconnecting a thread from its local memory allocations.

For the purpose of load balancing, the Linux scheduler will periodically migrate
the running processes. As a result, processes are moved between thread, core, or
socket within the compute node. However, the memory of a process doesn't
necessarily move at the same time leading to slower memory accesses.

Pinning, the binding of a process or thread to a specific core, can improve the
performance of your code by increasing the percentage of local memory accesses.
Once a process is pinned, it is bound to a specific set of cores and will only
run on the cores in this set therefore preventing migration by the operating
system.

## Slurm Options

This section describes options to control the way the process are pinned and 
distributed both between the node and within the nodes when launching your
application with `srun`.

### Tasks binding

Task (process) binding can be done via the `--cpu-bind=<bind>` option when 
launching your application with `srun` with `<bind>` the type of resource:

- `threads` : tasks are pinned to the logical threads
- `cores` : tasks are pinned to the cores
- `sockets` : tasks are pinned to the sockets
- `map_cpu:<list>` : custom bindings of tasks with `<list>` a comma-separated 
  list of CPUIDs

=== "Threads"

    In this example, we have pinned the tasks to the threads. Task 0 and 2 share
    the same physical core on the first socket but are bound to different 
    logical threads (0 and 128). The same is true for the tasks 1 and 3 that 
    share the core on the second CPU sockets but bound to thread 64 and 192 
    respectively. As we use the [default distribution][distribution], threads 
    are distributed in a round robin fashion between the 2 sockets of the nodes.

    ```
    srun --nodes=2 --ntasks=8 --cpu-bind=threads ./application
    ```

    <figure>
      <img src="../../../assets/images/cpu-bind-threads.svg" width="650" alt="CPU bind threads">
    </figure>

=== "Cores"

    In this example, we have pinned the tasks to the cores. Tasks are assigned
    the 2 logical threads of the CPU cores. As we use the 
    [default distribution][distribution], cores are distributed in a round robin
    fashion between the 2 sockets of 
    the nodes.

    ```
    srun --nodes=2 --ntasks=8 --cpu-bind=cores ./application
    ```

    <figure>
      <img src="../../../assets/images/cpu-bind-cores.svg" width="650" alt="CPU bind cores">
    </figure>

=== "Sockets"

    In this example, we have pinned the tasks to the sockets. Each task is 
    assigned the 128 logical threads available on the sockets. As there is only
    two sockets per node and 4 tasks, some tasks are bound to the same socket.

    ```
    srun --nodes=2 --ntasks=8 --cpu-bind=sockets ./application
    ```

    <figure>
      <img src="../../../assets/images/cpu-bind-sockets.svg" width="650" alt="CPU bind sockets">
    </figure>

=== "Custom binding"

    It is possible to specify exactly where each task will run by giving SLURM a list of CPU-IDs to bind to. In this example, we use this feature to run 64 MPI tasks per compute node on LUMI in a way that spreads out the MPI ranks across all compute core complexes (CCDs) in the AMD EPYC CPU, so that each CCD is half populated. Typically, this is done to get more effective memory capacity and memory bandwidth per MPI rank, but also to reach higher clock frequencies when only half of the cores in a CCD are being active.

    ```
    #SBATCH --ntasks-per-node=64
    ...
    srun --cpu-bind=map_cpu:0,1,2,3,8,9,10,11,16,17,18,19,24,25,26,27,32,33,34,35,40,41,42,43,48,49,50,51,56,57,58,59,64,65,66,67,72,73,74,75,80,81,82,83,88,89,90,91,96,97,98,99,104,105,106,107,112,113,114,115,120,121,122,123 ./application
    ```

    If you would not specify the CPU binding like this, the tasks would run on cores 0-63 in sequential order and only be able to utilize half of the available memory bandwidth. This might make a substantial difference, depending on the application.

    For reference, the binding maps for a few more configurations are given here. 96 cores, corresponding to 6 out of 8 cores used on each CCD,

    ```
    #SBATCH --ntasks-per-node=96
    ...
    srun --cpu-bind=map_cpu:0,1,2,3,4,5,8,9,10,11,12,13,16,17,18,19,20,21,24,25,26,27,28,29,32,33,34,35,36,37,40,41,42,43,44,45,48,49,50,51,52,53,56,57,58,59,60,61,64,65,66,67,68,69,72,73,74,75,76,77,80,81,82,83,84,85,88,89,90,91,92,93,96,97,98,99,100,101,104,105,106,107,108,109,112,113,114,115,116,117,120,121,122,123,124,125 ./application
    ```

    and 112 cores (7 out of 8 cores on a CCD). This configuration is useful because of the divisor 7, which allows for grid partitioning using dimensions divisible by e.g. 7 or 14. For example, an electronic structure program which relies on k-point parallelization could use 14 k-points and get efficient parallelization using 112 cores rather than 128.

    ```
    #SBATCH --ntasks-per-node=112
    ...
    srun --cpu-bind=map_cpu:0,1,2,3,4,5,6,8,9,10,11,12,13,14,16,17,18,19,20,21,22,24,25,26,27,28,29,30,32,33,34,35,36,37,38,40,41,42,43,44,45,46,48,49,50,51,52,53,54,56,57,58,59,60,61,62,64,65,66,67,68,69,70,72,73,74,75,76,77,78,80,81,82,83,84,85,86,88,89,90,91,92,93,94,96,97,98,99,100,101,102,104,105,106,107,108,109,110,112,113,114,115,116,117,118,120,121,122,123,124,125,126 ./application
    ```

More options and details are available in the [srun documentation][srun] or via
the manpage: `man srun`.

### Distribution

To control the distribution of the tasks, you use the `--distribution=<dist>` 
option of `srun`. The value of `<dist>` can be subdivided in multiple levels for
the distribution across for the nodes, sockets and cores. The first level of
distribution describe how the taks are distributed between the nodes.

=== "block"

    The `block` distribution method will distribute tasks to a node such that
    consecutive tasks share a node.

    ```
    srun --nodes=2 --ntask=256 --distribution=block ./application
    ```

    <figure>
      <img src="../../../assets/images/distribution-block.svg" width="450" alt="Distribution block">
    </figure>

=== "cyclic"

    The `cyclic` distribution method will distribute tasks to a node such that 
    consecutive tasks are distributed over consecutive nodes (in a round-robin
    fashion).

    ```
    srun --nodes=2 --ntask=256 --distribution=cyclic ./application
    ```

    <figure>
      <img src="../../../assets/images/distribution-cyclic.svg" width="450" alt="Distribution cyclic">
    </figure>

You can specify the distribution across sockets within a node by adding a second
descriptor, with a colon (`:`) as a separator. In the example below the numbers
represent the **rank of the tasks**.

=== "block:block"

    The `block:block` distribution method will distribute tasks to the nodes 
    such that consecutive tasks share a node. On the node, consecutive tasks are
    distributed on the same socket before using the next consecutive socket.

    ```
    srun --nodes=2 --ntask=256 --distribution=block:block ./application
    ```

    <figure>
      <img src="../../../assets/images/distribution-block-block.svg" width="400" alt="Distribution block:block">
    </figure>

=== "block:cyclic"

    The `block:cyclic` distribution method will distribute tasks to the nodes 
    such that consecutive tasks share a node. On the node, tasks are
    distributed in a round-robin fashion across sockets.

    ```
    srun --nodes=2 --ntask=256 --distribution=block:cyclic ./application
    ```

    <figure>
      <img src="../../../assets/images/distribution-block-cyclic.svg" width="400" alt="Distribution block:cyclic">
    </figure>

=== "cyclic:block"

    The cyclic distribution method will distribute tasks to a node such that 
    consecutive tasks are distributed over consecutive nodes in a round-robin
    fashion. Within the node, tasks are then distributed in blocks between the 
    sockets.

    ```
    srun --nodes=2 --ntask=256 --distribution=cyclic:block ./application
    ```

    <figure>
      <img src="../../../assets/images/distribution-cyclic-block.svg" width="400" alt="Distribution cyclic:block">
    </figure>

=== "cyclic:cyclic"

    The cyclic distribution method will distribute tasks to a node such that 
    consecutive tasks are distributed over consecutive nodes in a round-robin
    fashion. Within the node, tasks are then distributed in round-robin fashion
    between the sockets.

    ```
    srun --nodes=2 --ntask=256 --distribution=cyclic:cyclic ./application
    ```

    <figure>
      <img src="../../../assets/images/distribution-cyclic-cyclic.svg" width="400" alt="Distribution cyclic:cyclic">
    </figure>


More options and details are available in the [srun documentation][srun] or via
the manpage: `man srun`.

## OpenMP Thread Affinity

Since version 4, OpenMP provides the `OMP_PLACES` and `OMP_PROC_BIND` 
environment variables to specify how the OpenMP threads in a program are 
bound to processors.

### OpenMP places

OpenMP use the concept of places to define where the threads should be pinned. A
place is a set of hardware execution environments where a thread can "float".
The `OMP_PLACES` environment variable defines these places using either an 
abstract name or with a list of CPUIDs. The available abstract names are

- `threads` : hardware/logical thread
- `cores`   : core (having one or more hardware threads)
- `sockets` : socket (consisting of one or more cores)

Alternatively, the `OMP_PLACES` environment variable can be defined using an 
explicit ordered list of places with general syntax 
`<lowerbound>:<length>:<stride>`.

### OpenMP binding

While the places deal with the hardware resources, it doesn't define how the 
threads are mapped to the places. To map of the threads to the places you use 
the environment variable `OMP_PROC_BIND=<bind>`. The value of `<bind>` can be 
one of the following values:

- `spread` : distribute (spread) the threads as evenly as possible
- `close`  : bind threads close to the master thread
- `master` : assign the threads to the same place as the master thread
- `false`  : allows threads to be moved between places and disables thread affinity

The best options depend on the characteristics of your application. In general 
using `spread` increase available memory bandwidth while using `close` improve
cache locality.