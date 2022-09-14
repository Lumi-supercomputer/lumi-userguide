# Slurm partitions

[lumi-c]: ../../computing/systems/lumic.md
[lumi-g]: ../../computing/systems/lumig.md
[lumi-d]: ../../computing/systems/lumid.md
[helpdesk]: ../../generic/helpdesk.md

The Slurm partition setup of LUMI prioritizes jobs that aim to scale out. As a
consequence most nodes are reserved for jobs that use all available resources
within a node. However, some nodes are reserved for smaller allocations and
debugging.

A list of the available partitions can be obtained using the `sinfo` command.
To get a shorter summary, use `sinfo -s`.

## Slurm partitions allocatable by node

The following partitions are available for allocation by node. When using
these partitions, your jobs use all resources available on the node and won't
share the node with other jobs. Therefore, make sure that your application can
take advantage of all the resources on the node as you will be billed for the
complete node regardless of the resource actually used as detailed in the
[billing policy](../../computing/jobs/billing.md#standard-and-bench-partitions).

| Name     | Max walltime | Max jobs          | Max resources/job  | Hardware partition used |
| -------- | ------------ | ----------------- | ------------------ | ----------------------- |
| standard | 2 days       | 120 (100 running) | 512 nodes          | [LUMI-C][lumi-c]        |
| bench    | 1 day        | n/a               | All nodes          | [LUMI-C][lumi-c]        |

The `bench` partition is not available by default and is reserved for
large-scale benchmark runs. Projects wishing to have access to this partition
must send a request to the [User Support Team][helpdesk].

## Slurm partitions allocatable by resources

The following partitions are available for allocation by resources. This means
that you can request a sub-node allocation: you can request only part of the
resources (cores and memory) available on the compute node. This also means
that your job may share the node with other jobs.

| Name     | Max walltime | Max jobs                | Max resources/job  | Hardware partition used |
| -------- | ------------ | ----------------------- | ------------------ | ----------------------- |
| debug    | 30 minutes   |   1 (1 running)         | 4 nodes            | [LUMI-C][lumi-c]        |
| small    | 3 days       | 220 (200 running)       | 4 nodes            | [LUMI-C][lumi-c]        |
| largemem | 1 day        |  30 (20 running)        | 1 nodes            | [LUMI-D][lumi-d]        |

!!! info "LUMI-C/LUMI-D Large Memory Nodes"
    The [LUMI-C][lumi-c] large memory nodes (512GB and 1TB) are located in the
    `small` partition. Therefore, in order to use these nodes, you need to
    select the `small` partition (`--partion=small`). Then the LUMI-C large
    memory nodes will be allocated if you request more memory than is available
    in the LUMI-C standard compute nodes.

    The nodes in the `largemem` partition are part of [LUMI-D][lumi-d] and have
    4TB of memory per node.

## Getting information about Slurm partitions

If you want more precise information about a particular partition, you can use
the following command:

```bash
scontrol show partition <partition-name>
```

The output of this command will give you information about the defaults and
limits which applies to the `<partition-name>` partition.
