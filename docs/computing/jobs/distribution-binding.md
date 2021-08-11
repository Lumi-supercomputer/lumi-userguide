# Distribution and Binding

[distribution]: #distribution

[srun]: https://slurm.schedmd.com/srun.html
[numa]: https://en.wikipedia.org/wiki/Non-uniform_memory_access

A compute nodes consist of a hierarchy of building blocks: one or more sockets
(processors), consisting of multiple physical cores each with one or more 
logical threads, enabling simultaneous multithreading.

<figure>
  <img src="/assets/images/socket-core-threads.svg" width="700">
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
      <img src="/assets/images/cpu-bind-threads.svg" width="650">
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
      <img src="/assets/images/cpu-bind-cores.svg" width="650">
    </figure>

=== "Sockets"

    In this example, we have pinned the tasks to the sockets. Each task is 
    assigned the 128 logical threads available on the sockets. As there is only
    two sockets per node and 4 tasks, some tasks are bound to the same socket.

    ```
    srun --nodes=2 --ntasks=8 --cpu-bind=sockets ./application
    ```

    <figure>
      <img src="/assets/images/cpu-bind-sockets.svg" width="650">
    </figure>

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
      <img src="/assets/images/distribution-block.svg" width="450">
    </figure>

=== "cyclic"

    The `cyclic` distribution method will distribute tasks to a node such that 
    consecutive tasks are distributed over consecutive nodes (in a round-robin
    fashion).

    ```
    srun --nodes=2 --ntask=256 --distribution=cyclic ./application
    ```

    <figure>
      <img src="/assets/images/distribution-cyclic.svg" width="450">
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
      <img src="/assets/images/distribution-block-block.svg" width="400">
    </figure>

=== "block:cyclic"

    The `block:cyclic` distribution method will distribute tasks to the nodes 
    such that consecutive tasks share a node. On the node, tasks are
    distributed in a round-robin fashion across sockets.

    ```
    srun --nodes=2 --ntask=256 --distribution=block:cyclic ./application
    ```

    <figure>
      <img src="/assets/images/distribution-block-cyclic.svg" width="400">
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
      <img src="/assets/images/distribution-cyclic-block.svg" width="400">
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
      <img src="/assets/images/distribution-cyclic-cyclic.svg" width="400">
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