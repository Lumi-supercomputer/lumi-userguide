# Available Partitions

The partition setup of LUMI prioritizes jobs that aim to scale out. As a
consequence most nodes are reserved for jobs that use all available resources.
However, some nodes are reserved for smaller allocations and debugging. 

## Partitions allocatable by node

The following partitions are available for allocation by nodes. When using
these partitions, your jobs use all resources available on the node and won't
share the node with other jobs. Therefore, make sure that
your application can take advantage of all the resources on the node as you
will be billed for the complete node regardless of the resource actually used.

| Name     | Max walltime | Max jobs     | Max ressources/job |
| -------- | ------------ | ------------ | ------------------ |
| standard | 2 days       | 100          | 500 nodes          |
| bench    | 1 day        | n/a          | All nodes          |

The `bench` partition is not available by default and is reserved for 
large-scale runs. Projects wishing to have access to this partition must send a 
request to the support.

## Partitions allocatable by resources

The following partitions are available for allocation by resources. This means
that you can request a sub-node allocation: you can request only part of the 
resources (cores and memory) available on the compute node. This also means 
that your job may share the node with other jobs.

| Name    | Max walltime | Max jobs                | Max ressources/job |
| ------- | ------------ | ----------------------- | ------------------ |
| debug   | 30 minutes   | 1 running<br/>1 queuing | 4 nodes            |
| small   | 1 day        | 200                     | 4 nodes            |

!!! info "Large Memory Nodes"
    The large memory nodes (512GB and 1TB) are located in the `small` partition.
    Therefore, in order to use these nodes, you need to select the `small`
    partition (`--partion=small`). Then, the large memory nodes will be 
    allocated if you request more memory than the standard compute nodes.

## Getting information about partitions

A list of the available partitions can be obtained using the `sinfo` command.
If you want more precise information about a particular partition, you can use
the following command:

```
scontrol show partition <partition-name>
```

The output of this command will give you information about the defaults and
limits which applies to the `<partition-name>` partition.

