# Slurm partitions

[lumi-c]: ../../hardware/lumic.md
[lumi-g]: ../../hardware/lumig.md
[lumi-d]: ../../hardware/lumid.md
[herorun]: ./hero-runs.md

The Slurm partition setup of LUMI prioritizes jobs that aim to scale out.
As a consequence, most nodes are reserved for jobs that use all available resources
within a node.
However, some nodes are reserved for smaller allocations and debugging.

A list of the available partitions can be obtained using the `sinfo` command.
To get a shorter summary, use `sinfo -s`.

## Slurm partitions allocatable by node

The following partitions are available for allocation by node. When using
these partitions, your jobs use all resources available on the node and won't
share the node with other jobs. Therefore, make sure that your application can
take advantage of all the resources on the node as you will be billed for the
complete node regardless of the resource actually used as detailed in the
[billing policy](../../runjobs/lumi_env/billing.md).

| Name           | Max walltime | Max jobs          | Max resources/job | Hardware<br>partition<br>used         |
| -------------- | ------------ | ----------------- | ----------------- | --------------------------------------|
| standard-g     | 2 days       | 210 (200 running) | 1024 nodes        | [LUMI-G][lumi-g]                      |
| standard       | 2 days       | 120 (100 running) |  512 nodes        | [LUMI-C][lumi-c]                      |
| bench          | 6 hours      | n/a               |  All nodes        | [LUMI-C][lumi-c] and [LUMI-G][lumi-g] |

The `bench` partition is not available by default and is reserved for
large-scale benchmark runs. Projects wishing to have access to this partition
must send a [request for a full machine run][herorun].

## Slurm partitions allocatable by resources

The following partitions are available for allocation by resources. This means
that you can request a sub-node allocation: you can request only part of the
resources (cores, gpus, and memory) available on the compute node. This also means
that your job may share the node with other jobs.

| Name     | Max walltime | Max jobs                | Max resources/job  | Hardware partition | Purpose                                                     |
| -------- | ------------ | ----------------------- | ------------------ | ------------------ | ----------------------------------------------------------- |
| dev-g    | 3 hours      |   2 (1 running)         | 32 nodes           | [LUMI-G][lumi-g]   | Debugging[\*](#debugging-nodes)                             |
| debug    | 30 minutes   |   2 (1 running)         |  4 nodes           | [LUMI-C][lumi-c]   | Debugging and testing[\*](#debugging-nodes)                 |
| small-g  | 3 days       | 210 (200 running)       |  4 nodes           | [LUMI-G][lumi-g]   |                                                             | 
| small    | 3 days       | 220 (200 running)       |  4 nodes           | [LUMI-C][lumi-c]   | Small or memory intense jobs[&dagger;](#large-memory-nodes) |
| largemem | 1 day        |  30 (20 running)        |  1 nodes           | [LUMI-D][lumi-d]   | Memory intense jobs[&dagger;](#large-memory-nodes)          |
| lumid    | 4 hours      |   1 (1 running)         |  1 GPU             | [LUMI-D][lumi-d]   | Visualisation[&Dagger;](#visualisation-nodes)               |

!!! info "Notes about specific partitions"

    #### Debugging nodes
    \* Nodes in the `debug` and `dev-g` partition are meant for debugging and
    quick testing purposes and not for production runs. Repeated abuse of these
    partitions might result in account suspension.

    #### Large memory nodes
    &dagger; The [LUMI-C][lumi-c] large memory nodes (512GB and 1TB) are located in the
    `small` partition. Therefore, to use these nodes, you need to
    select the `small` partition (`--partition=small`). Then the LUMI-C large
    memory nodes will be allocated if you request more memory than is available
    in the LUMI-C standard compute nodes.
 
    The nodes in the `largemem` partition are part of [LUMI-D][lumi-d] and have
    4TB of memory per node.

    #### Visulation nodes
    &Dagger; [LUMI-D](lumi-d) nodes are the only nodes in LUMI that have Nvidia GPUs.
    They are only intended for visualisation purposes like Paraview. They should not be
    used for calculations and production runs.


## Getting information about Slurm partitions

If you want more precise information about a particular partition, you can use
the following command:

```bash
scontrol show partition <partition-name>
```

The output of this command will give you information about the defaults and
limits which applies to the `<partition-name>` partition.
