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

| Name     | Max walltime | Max jobs                | Max resources/job  | Hardware partition | Purpose                                                                  |
| -------- | ------------ | ----------------------- | ------------------ | ------------------ | ------------------------------------------------------------------------ |
| dev-g    | 3 hours      |   2 (1 running)         | 32 nodes           | [LUMI-G][lumi-g]   | [Debugging](#debugging-nodes)                                            |
| debug    | 30 minutes   |   2 (1 running)         |  4 nodes           | [LUMI-C][lumi-c]   | [Debugging and testing](#debugging-nodes)                                |
| small-g  | 3 days       | 210 (200 running)       |  4 nodes           | [LUMI-G][lumi-g]   | [Small GPU jobs](#small-partitions)                                      | 
| small    | 3 days       | 220 (200 running)       |  4 nodes           | [LUMI-C][lumi-c]   | [Small](#small-partitions) or [memory intense](#large-memory-nodes) jobs |
| largemem | 1 day        |  30 (20 running)        |  1 nodes           | [LUMI-D][lumi-d]   | [Memory intense jobs](#large-memory-nodes)                               |
| lumid    | 4 hours      |   1 (1 running)         |  1 GPU             | [LUMI-D][lumi-d]   | [Visualisation](#visualization-nodes)                                    |

!!! info "Notes about specific partitions"

    #### Debugging nodes
    Nodes in the `debug` and `dev-g` partition are meant for debugging and
    quick testing purposes and not for production runs. Repeated abuse of these
    partitions might result in account suspension.

    #### Small partitions
    LUMI is optimized for large jobs (dozens of nodes). However not all 
    applications can scale efficiently at large-scale or even at the node level. 
    Allocating an entire node for a serial pre/post-processing job or for an 
    application that can only use a single GPU is not an efficient use of the
    resources.
        
    The kind of jobs described above should use the small partitions. On these
    partitions you can only allocate a few nodes but you can run for a longer
    period of time.

    #### Large memory nodes
    The [LUMI-C][lumi-c] large memory nodes (512GB and 1TB) are located in the
    `small` partition. Therefore, to use these nodes, you need to
    select the `small` partition (`--partition=small`). Then the LUMI-C large
    memory nodes will be allocated if you request more memory than is available
    in the LUMI-C standard compute nodes.
 
    The nodes in the `largemem` partition are part of [LUMI-D][lumi-d] and have
    4TB of memory per node. They are mostly meant for data-intensive pre- and 
    postprocessing and should not be the only compute resource used by your
    project as there are only a limited number of those nodes.

    #### Visualization nodes
    [LUMI-D](lumi-d) nodes are the only nodes in LUMI that have Nvidia GPUs.
    They are only intended for visualisation purposes like Paraview. They are not a 
    source of CUDA-compatible compute power for regular computations. Regular computations
    should be done with codes suitable for the AMD GPUs of LUMI-G. Repeated abuse 
    may result in account suspension or project termination.


## Getting information about Slurm partitions

If you want more precise information about a particular partition, you can use
the following command:

```bash
scontrol show partition <partition-name>
```

The output of this command will give you information about the defaults and
limits which applies to the `<partition-name>` partition.
