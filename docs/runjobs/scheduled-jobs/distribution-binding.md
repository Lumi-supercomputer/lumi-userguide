# Distribution and binding options

[interactive]: ./interactive.md#using-salloc

This section is a deep dive into the advanced topic of binding and distributing
tasks via Slurm on LUMI.

!!! Warning "For full node allocation only"

    This section of the documentation only applies if you have a full-node 
    allocation. This is the case if you submit to the `standard`, `standard-g`,
    partitions. For other partitions, it will apply if you use the `--exclusive` 
    sbatch directive.

    Similarly, binding cannot by applied for interactive jobs if you run `srun` 
    outside of an allocation, meaning you directly call `srun` on a login node.
    You have to [create an allocation with `salloc`][interactive] first.

## Background

[distribution]: #distribution

[srun]: https://slurm.schedmd.com/srun.html
[numa]: https://en.wikipedia.org/wiki/Non-uniform_memory_access
[lumi-c]: ../../hardware/lumic.md

A compute node consists of a hierarchy of building blocks: one or more sockets
(processors), consisting of multiple physical cores each with one or more
logical threads, enabling simultaneous multithreading.

<figure>
  <img 
    src="../../../assets/images/socket-core-threads.svg" 
    width="700"
    alt="Concept of socket, core and threads">
  <figcaption>Concept of socket, core and threads</figcaption>
</figure>

For example, each [LUMI-C][lumi-c] compute node contains 2 sockets. Each socket
has 64 physical cores and each core has 2 logical threads. This means that you
can launch up to 2 x 2 x 64 = 256 tasks (or threads) per node.

A processor can also be partitioned in [Non-Uniform Memory Access (NUMA)][numa]
domains. These domains divide the memory into multiple domains local to a group
of cores. The memory in the local NUMA node can be accessed faster than the
other NUMA nodes leading to better performance when a process/thread access
memory on the local NUMA node. LUMI-C uses 4 NUMA domains per socket (8 NUMA
domains per node). Thread migration from one core to another poses a problem
for a NUMA architecture by disconnecting a thread from its local memory
allocations.

For the purpose of load balancing, the Linux scheduler will periodically migrate
the running processes. As a result, processes are moved between thread, core, or
socket within the compute node. However, the memory of a process doesn't
necessarily move at the same time leading to slower memory accesses.

Pinning (the binding of a process or thread to a specific core) can improve the
performance of your code by increasing the percentage of local memory accesses.
Once a process is pinned, it is bound to a specific set of cores and will only
run on the cores in this set, therefore preventing migration by the operating
system.

!!! warning "Correct binding only for full node allocation"

    Binding only makes sense if your request a full node (user exclusive) 
    allocation. This is the default for the `standard`, `standard-g`, 
    partitions

## Slurm binding options

This section describes options to control the way the process are pinned and
distributed both between the node and within the nodes when launching your
application with `srun`.

### CPU binding

Task (process) binding can be done via the `--cpu-bind=<bind>` option when
launching your application with `srun` with `<bind>` the type of resource:

- `threads` : tasks are pinned to the logical threads
- `cores` : tasks are pinned to the cores
- `sockets` : tasks are pinned to the sockets
- `map_cpu:<list>` : custom bindings of tasks with `<list>` a comma-separated
  list of CPUIDs
- `mask_cpu:<list>` : custom bindings of tasks with `<list>` a comma-separated
  mask of cores


=== "Threads"

    In this example, we have pinned the tasks to the threads. Tasks are assigned
    the 1 logical threads of the CPU cores.

    ```
     $ srun --nodes=2 \
            --ntasks-per-node=2 \
            --cpu-bind=threads bash -c ' \
              echo -n "task $SLURM_PROCID (node $SLURM_NODEID): "; \
              taskset -cp $$' | sort

    task 0 (node 0): pid 122525's current affinity list: 0
    task 1 (node 0): pid 122526's current affinity list: 1
    task 2 (node 1): pid 105194's current affinity list: 0
    task 3 (node 1): pid 105195's current affinity list: 1
    ```

=== "Cores"

    In this example, we have pinned the tasks to the cores. Tasks are assigned
    the 2 logical threads of the CPU cores.

    ```
     $ srun --nodes=2 \
            --ntasks-per-node=2 \
            --cpu-bind=cores bash -c ' \
              echo -n "task $SLURM_PROCID (node $SLURM_NODEID): "; \
              taskset -cp $$' | sort

    task 0 (node 0): pid 122729's current affinity list: 0,128
    task 1 (node 0): pid 122730's current affinity list: 1,129
    task 2 (node 1): pid 105389's current affinity list: 0,128
    task 3 (node 1): pid 105390's current affinity list: 1,129
    ```

=== "Sockets"

    In this example, we have pinned the tasks to the sockets. Each task is 
    assigned the 128 logical threads available on the sockets.

    ```
     $ srun --nodes=2 \
            --ntasks-per-node=2 \
            --cpu-bind=sockets bash -c ' \
              echo -n "task $SLURM_PROCID (node $SLURM_NODEID): "; \
              taskset -cp $$' | sort

    task 0 (node 0): pid 122174's current affinity list: 0-63,128-191
    task 1 (node 0): pid 122175's current affinity list: 0-63,128-191
    task 2 (node 1): pid 104666's current affinity list: 0-63,128-191
    task 3 (node 1): pid 104667's current affinity list: 0-63,128-191
    ```

=== "Custom binding"

    It is possible to specify exactly where each task will run by giving SLURM a
    list of CPU-IDs to bind to. In this example, we use this feature to run 16
    MPI tasks on a LUMI-C compute nodes. In a way that spreads out the MPI ranks
    across all compute core complexes (CCDs, L3 cache). Typically, this is done
    to get more effective memory capacity and memory bandwidth per MPI rank and
    increase cache capacity available to each rank.

    ```bash
    #SBATCH ...
    #SBATCH --partition=standard
    #SBATCH --ntasks-per-node=16
    
    # First socket
    export SLURM_CPU_BIND="map_cpu:0,8,16,24,32,40,48,56"
    # Second socket
    export SLURM_CPU_BIND="${SLURM_CPU_BIND},64,72,80,88,96,104,112,120"
    
    # Alternative way using the seq command
    #export SLURM_CPU_BIND="map_cpu:$(seq -s ',' 0 8 127)"

    srun <app> <args>
    ```

    The example above, we use the `SLURM_CPU_BIND` environment variable to set
    the CPU map. This is equivalent to using `--cpu-bind` option with `srun`.

    For hybrid MPI+OpenMP application multiple core need to be assigned to each
    of the tasks. These can be achieved by setting a CPU mask, 
    `--cpu-bind=cpu_mask:<task1_mask,task2_mask,...>`, where the task masks are
    hexadecimal values. For example, with 16 tasks per node and 4 cores
    (threads) per task, one every 2 cores assigned to the task. In this 
    scenario, the base mask will be `0x55` in hexadecimal which is `0b01010101`
    in binary. Then, to binding masks for the tasks will be

    - First task `0x55`: cores 0, 2, 4 and 6
    - Second task `0x5500`: cores 8, 10, 12 and 14
    - Third task `0x550000`: cores 16 18 20 and 22
    - ...

    So that, the CPU mask will be `0x55,0x5500,0x550000,...`. Setting the CPU
    mask can be tedious, below is an example script that computes and set the
    CPU mask based on the values of `SLURM_NTASKS_PER_NODE` and 
    `OMP_NUM_THREADS`.

    ```bash
    #!/bin/bash
    #SBATCH --nodes=1
    #SBATCH --ntasks-per-node=16
    #SBATCH --partition=standard
    #SBATCH --time=12:00:00
    #SBATCH --account=<project>
    
    export OMP_NUM_THREADS=4
    export OMP_PROC_BIND=true
    export OMP_PLACES=cores
    
    cpus_per_task=$((SLURM_CPUS_ON_NODE / SLURM_NTASKS_PER_NODE))
    threads_spacing=$((cpus_per_task / OMP_NUM_THREADS))
    
    base_mask=0x0
    for i in $(seq 0 ${threads_spacing} $((cpus_per_task-1)))
    do
      base_mask=$((base_mask | (0x1 << i)))
    done

    declare -a cpu_masks=()
    for i in $(seq 0 ${cpus_per_task} 127)
    do
      mask_format="%x%$((16 * (i/64)))s"
      task_mask=$(printf ${mask_format} $((base_mask << i)) | tr " " "0")
      cpu_masks=(${cpu_masks[@]} ${task_mask})
    done

    export SLURM_CPU_BIND=$(IFS=, ; echo "mask_cpu:${cpu_masks[*]}")

    srun <app> <args>
    ```

More options and details are available in the [srun documentation][srun] or via
the manpage: `man srun`.

### GPU Binding

!!! warning "Only 56 cores available on LUMI-G"

    The LUMI-G compute nodes have the low-noise mode activated. This mode
    reserve 1 core to the operating system. In order to get a more balanced 
    layout, we also disabled the first core in each of the 8 L3 region. As a
    consequence only 56 cores are available to the jobs. Jobs requesting 64 
    cores/node will never run.

Correct CPU and GPU binding is important to get the best performance out of the
GPU nodes. The reason is that each of the 4 NUMA nodes is directly linked to 
one of the 4 MI250x GPU modules. You can query this topology using the `rocm-smi`
command with the `--showtoponuma` option.

```
 $ rocm-smi --showtoponuma

====================== Numa Nodes ======================
GPU[0]          : (Topology) Numa Node: 3
GPU[0]          : (Topology) Numa Affinity: 3
GPU[1]          : (Topology) Numa Node: 3
GPU[1]          : (Topology) Numa Affinity: 3
GPU[2]          : (Topology) Numa Node: 1
GPU[2]          : (Topology) Numa Affinity: 1
GPU[3]          : (Topology) Numa Node: 1
GPU[3]          : (Topology) Numa Affinity: 1
GPU[4]          : (Topology) Numa Node: 0
GPU[4]          : (Topology) Numa Affinity: 0
GPU[5]          : (Topology) Numa Node: 0
GPU[5]          : (Topology) Numa Affinity: 0
GPU[6]          : (Topology) Numa Node: 2
GPU[6]          : (Topology) Numa Affinity: 2
GPU[7]          : (Topology) Numa Node: 2
GPU[7]          : (Topology) Numa Affinity: 2
================= End of ROCm SMI Log ==================
```

As you can see, there is no direct correspondence between the numbering of the 
NUMA nodes and the numbering of the GPUs (GCDs). As a consequence, depending on
how the rank and threads of your application choose the GPU to use, you may need
a combination of CPU and GPU binding options.

####  Application that can select GPU automatically

If your application automatically selects the GPU to use by using the node local
rank, i.e., the first rank on the node selects GPU 0, the second selects GPU 1, ...,
then it is recommended to reorder the assignment of rank to NUMA node so that:

- rank 0 and 1 are assigned to NUMA node 3, close to GPUs 0 and 1
- rank 2 and 3 are assigned to NUMA node 1, close to GPUs 2 and 3
- rank 4 and 5 are assigned to NUMA node 0, close to GPUs 4 and 5
- rank 6 and 7 are assigned to NUMA node 2, close to GPUs 6 and 7

For an MPI application, not using OpenMP, the binding can be achieved by
launching the application using the following command

```
srun --cpu-bind=map_cpu:49,57,17,25,1,9,33,41 <app> <args>
```

For a hybrid MPI+OpenMP application, the binding can be achieved by launching
the application using the following command

```
CPU_BIND="mask_cpu:fe000000000000,fe00000000000000"
CPU_BIND="${CPU_BIND},fe0000,fe000000"
CPU_BIND="${CPU_BIND},fe,fe00"
CPU_BIND="${CPU_BIND},fe00000000,fe0000000000"

srun --cpu-bind=${CPU_BIND} <app> <args>
```

####  Application that cannot select GPU automatically

For an application that cannot select a GPU automatically, in addition to CPU binding
described in the previous section, you can use a wrapper script to set the GPU binding.

This script sets `ROCR_VISIBLE_DEVICES` to the value of the Slurm-defined `SLURM_LOCALID`
environment variable so that:

- for node local rank 0, `ROCR_VISIBLE_DEVICES=0`
- for node local rank 1, `ROCR_VISIBLE_DEVICES=1`
- ...

```
cat << EOF > select_gpu
#!/bin/bash

export ROCR_VISIBLE_DEVICES=\$SLURM_LOCALID
exec \$*
EOF

chmod +x ./select_gpu

srun <cpu-binding-opt> ./select_gpu <app> <args>
```

### Distribution

To control the distribution of the tasks, you use the `--distribution=<dist>` 
option of `srun`. The value of `<dist>` can be subdivided in multiple levels for
the distribution across for the nodes, sockets and cores. The first level of
distribution describes how the tasks are distributed between the nodes.

=== "block"

    The `block` distribution method will distribute tasks to a node such that
    consecutive tasks share a node.

    ```
     $ srun --nodes=2 \
            --ntasks-per-node=4 \
            --distribution=block bash -c ' \
              echo -n "task $SLURM_PROCID (node $SLURM_NODEID): "; \
              taskset -cp $$' | sort

    task 0 (node 0): pid 115577's current affinity list: 0
    task 1 (node 0): pid 115578's current affinity list: 1
    task 2 (node 0): pid 115579's current affinity list: 2
    task 3 (node 0): pid 115580's current affinity list: 3
    task 4 (node 1): pid 98737's current affinity list: 0
    task 5 (node 1): pid 98738's current affinity list: 1
    task 6 (node 1): pid 98739's current affinity list: 2
    task 7 (node 1): pid 98740's current affinity list: 3
    ```


=== "cyclic"

    The `cyclic` distribution method will distribute tasks to a node such that 
    consecutive tasks are distributed over consecutive nodes (in a round-robin
    fashion).

    ```
     $ srun --nodes=2 \
            --ntasks-per-node=4 \
            --distribution=cyclic bash -c ' \
              echo -n "task $SLURM_PROCID (node $SLURM_NODEID): "; \
              taskset -cp $$' | sort
    
    task 0 (node 0): pid 115320's current affinity list: 0
    task 1 (node 1): pid 98006's current affinity list: 0
    task 2 (node 0): pid 115321's current affinity list: 1
    task 3 (node 1): pid 98007's current affinity list: 1
    task 4 (node 0): pid 115322's current affinity list: 2
    task 5 (node 1): pid 98008's current affinity list: 2
    task 6 (node 0): pid 115323's current affinity list: 3
    task 7 (node 1): pid 98009's current affinity list: 3
    ```

You can specify the distribution across sockets within a node by adding a second
descriptor, with a colon (`:`) as a separator. In the example below, the numbers
represent the **rank of the tasks**.

=== "block:block"

    The `block:block` distribution method will distribute tasks to the nodes 
    such that consecutive tasks share a node. On the node, consecutive tasks are
    distributed on the same socket before using the next consecutive socket.

    ```
     $ srun --nodes=2 \
            --ntasks-per-node=4 \
            --distribution=block:block bash -c ' \
              echo -n "task $SLURM_PROCID (node $SLURM_NODEID): "; \
              taskset -cp $$' | sort
    
    task 0 (node 0): pid 111144's current affinity list: 0
    task 1 (node 0): pid 111145's current affinity list: 1
    task 2 (node 0): pid 111146's current affinity list: 2
    task 3 (node 0): pid 111147's current affinity list: 3
    task 4 (node 1): pid 93838's current affinity list: 0
    task 5 (node 1): pid 93839's current affinity list: 1
    task 6 (node 1): pid 93840's current affinity list: 2
    task 7 (node 1): pid 93841's current affinity list: 3
    ```

=== "block:cyclic"

    The `block:cyclic` distribution method will distribute tasks to the nodes 
    such that consecutive tasks share a node. On the node, tasks are
    distributed in a round-robin fashion across sockets.

    ```
     $ srun --nodes=2 \
            --ntasks-per-node=4 \
            --distribution=block:cyclic bash -c ' \
              echo -n "task $SLURM_PROCID (node $SLURM_NODEID): "; \
              taskset -cp $$' | sort

    task 0 (node 0): pid 110049's current affinity list: 0
    task 1 (node 0): pid 110050's current affinity list: 64
    task 2 (node 0): pid 110051's current affinity list: 1
    task 3 (node 0): pid 110052's current affinity list: 65
    task 4 (node 1): pid 92766's current affinity list: 0
    task 5 (node 1): pid 92767's current affinity list: 64
    task 6 (node 1): pid 92768's current affinity list: 1
    task 7 (node 1): pid 92769's current affinity list: 65
    ```

=== "cyclic:block"

    The cyclic distribution method will distribute tasks to a node such that 
    consecutive tasks are distributed over consecutive nodes in a round-robin
    fashion. Within the node, tasks are then distributed in blocks between the 
    sockets.

    ```
     $ srun --nodes=2 \
            --ntasks-per-node=4 \
            --distribution=cyclic:block bash -c ' \
              echo -n "task $SLURM_PROCID (node $SLURM_NODEID): "; \
              taskset -cp $$' | sort
    
    task 0 (node 0): pid 114730's current affinity list: 0
    task 1 (node 1): pid 97439's current affinity list: 0
    task 2 (node 0): pid 114731's current affinity list: 1
    task 3 (node 1): pid 97440's current affinity list: 1
    task 4 (node 0): pid 114732's current affinity list: 2
    task 5 (node 1): pid 97441's current affinity list: 2
    task 6 (node 0): pid 114733's current affinity list: 3
    task 7 (node 1): pid 97442's current affinity list: 3
    ```

=== "cyclic:cyclic"

    The cyclic distribution method will distribute tasks to a node such that 
    consecutive tasks are distributed over consecutive nodes in a round-robin
    fashion. Within the node, tasks are then distributed in round-robin fashion
    between the sockets.

    ```
     $ srun --nodes=2 \
            --ntasks-per-node=4 \
            --distribution=cyclic:cyclic bash -c ' \
              echo -n "task $SLURM_PROCID (node $SLURM_NODEID): "; \
              taskset -cp $$' | sort

    task 0 (node 0): pid 114973's current affinity list: 0
    task 1 (node 1): pid 97690's current affinity list: 0
    task 2 (node 0): pid 114974's current affinity list: 64
    task 3 (node 1): pid 97691's current affinity list: 64
    task 4 (node 0): pid 114975's current affinity list: 1
    task 5 (node 1): pid 97692's current affinity list: 1
    task 6 (node 0): pid 114976's current affinity list: 65
    task 7 (node 1): pid 97693's current affinity list: 65
    ```

More options and details are available in the [srun documentation][srun] or via
the manpage: `man srun`.

## OpenMP Thread Affinity

Since version 4, OpenMP provides the `OMP_PLACES` and `OMP_PROC_BIND`
environment variables to specify how the OpenMP threads in a program are bound
to processors.

### OpenMP places

OpenMP uses the concept of places to define where the threads should be pinned.
A place is a set of hardware execution environments where a thread can "float".
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
- `false`  : allows threads to be moved between places and disables thread
  affinity

The best options depend on the characteristics of your application. In general
using `spread` increase available memory bandwidth while using `close` improve
cache locality.
