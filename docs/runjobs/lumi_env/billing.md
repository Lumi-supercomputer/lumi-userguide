[lumi-c]: ../../hardware/lumic.md
[lumid-gpu]: ../../hardware/lumid.md#gpu  
[lumid-cpu]: ../../hardware/lumid.md#cpu  
[lumi-f]: ../../storage/parallel-filesystems/lumif.md
[lumi-p]: ../../storage/parallel-filesystems/lumip.md
[lumi-o]: ../../storage/lumio/index.md
[slurm-quickstart]: ../../runjobs/scheduled-jobs/slurm-quickstart.md
[slurm-partitions]: ../../runjobs/scheduled-jobs/partitions.md
[data-storage-options]: ../../storage/index.md

# Billing policy

Running jobs on the compute nodes and storing data in storage space will consume
the billing units allocated to your project:

- Compute is billed in units of CPU-core-hours for CPU nodes and GPU-hours for GPU nodes.
- Storage space is billed in units of TB-hours.

## How to check your billing units

To check how many billing units you have used, you can use the following command:

```
lumi-allocations
```

It will report the CPU-core-hours and GPU-hours allocated and consumed for all the projects
you are a part of. The tool also reports the storage billing units.

A description of how the jobs are billed is provided in the next sections.  

## Compute billing

Compute is billed whenever you submit a job to the [Slurm job scheduler][slurm-quickstart].

### CPU billing

For CPU compute, your project is allocated CPU-core-hours that are consumed
when running jobs on the CPU nodes.   
CPU billing applies to partitions `standard`, `small`, `debug` and `largemem`, and also to the visualization partition `lumid`.

<!--
The CPU-core-hours are billed as:

```text
cpu-core-hours-billed = cpu-cores-allocated x runtime-of-job
```

For example, allocating 32 CPU cores in a job running for 2 hours consumes:

```text
32 CPU-cores x 2 hours = 64 CPU-core-hours
```


### CPU Slurm partition billing details


For some [Slurm partitions][slurm-partitions] special billing rules apply.

-->

#### Exclusive CPU partitions

The `standard` partition is operated in exclusive mode: it's not possible to reserve a part of a node on this partition, but the entire node will always be allocated for your job. Thus, 128 CPU-core-hours are billed for every allocated node and per hour even if your job has requested less than 128 cores per node.

For example, allocating 16 nodes in a job running for 12 hours consumes:

```text
16 nodes x 128 CPU-cores/node x 12 hours = 24576 CPU-core-hours
```

#### Non-exclusive CPU partitions

When using the `small` and `debug` CPU partitons, or the `largemem` partition of [LUMI-D][lumid-cpu], you are billed per allocated core.
However, if you are above a certain threshold of memory allocated per core, you are billed per slice of 2GB memory (which is still billed in units of CPU-core-hours).
Using the `largemem` partition, or the high memory nodes in [LUMI-C][lumi-c], is thus more expensive.


Specifically, the formula used for billing for these partitions is:

```text
CPU-core-hours-billed = max(
  CPU-cores-allocated, ceil(memory-allocated / 2GB)
  ) x runtime-of-job
```

Thus,

- if you use 2GB or less of memory per core, you are charged per allocated
  cores.
- if you use more than 2GB of memory per core, you are charged per 2GB slice
  of memory.

For example, allocating 4 CPU-cores and 4GB of memory in a job running for 1 day
consumes:

```text
4 CPU-cores x 24 hours = 96 CPU-core-hours
```

Allocating 4 CPU-cores and 32GB of memory in a job running for 1 day consumes:

```text
(32GB / 2GB) x 24 hours = 384 CPU-core-hours
```

#### Visualization partition `lumid`

The `lumid` visualization nodes located in [LUMI-D hardware partition][lumid-gpu] are billed in CPU-core-hours (since May 2026).

<!--
will consume 32 CPU hours per hour for the usage of the visualization GPUs
or 1/8 of the CPU or memory resources in a node.

max(ceil(ncpus/16),ceil(memory_gib/256),ngpus)*64 CPU hours (per hour of usage)

-->

```text
CPU-core-hours-billed = 
    max(
        ceil(CPU-cores-allocated / 16), 
        ceil(memory-allocated / 256 GB), 
        GCDs-allocated )
  * 64 * runtime-of-job
```

For example, a job allocating 1 GCD and running for 0.5 hours, 
consumes:

```text
1 * 64 * 0.5  = 32 CPU-core-hours
```

If you allocate 1 GCD for 4 hours but allocate 512 GB of memory, then you are billed for this memory:

```
ceil(512 / 256) * 64 * 4 = 512 CPU-core-hours
```



### GPU billing

For GPU compute, your project is allocated GPU-hours that are consumed
when running jobs on the GPU nodes. A GPU-hour corresponds to the allocation
of a full [MI250x module (2 GCDs)](../../hardware/lumig.md) for one hour.

#### Exclusive GPU partitions

For the `standard-g` partition which is operated in exclusive mode, full nodes are always allocated, and the 4 GPUs modules are thus billed per node:

```text
GPU-hours-billed = 4 * runtime-of-job
```

i.e., one node hours correspond to 4 GPU-hours. If you allocate 4 nodes in the
`standard-g` partition and your job runs for 24 hours,
you will consume

```text
4 * 4 * 24 = 384 GPU-hours
```

#### Non-exclusive GPU partitions

For the `small-g` and `dev-g` Slurm partitions, where allocation can be done at 
the level of Graphics Compute Dies (GCD), you will be billed at a 0.5 rate per
GCD allocated. However, if you allocate more than 8 CPU cores or more than 64 GB
of memory per GCD, you will be billed per slice of 8 cores or 64 GB of memory.

The billing formula is:

```text
GPU-hours-billed = (
    max(
        ceil(CPU-cores-allocated / 8),
        ceil(memory-allocated / 64GB),
        GCDs-allocated )
    * runtime-of-job) * 0.5
```

For example, for a job allocating 2 GCDs and running for 24 hours, you will 
consume

```text
(2 * 24 ) * 0.5 = 24 GPU-hours
```

If you allocate 1 GCD for 24 hours but allocate 128 GB of memory, then you will
be billed for this memory:

```
ceil(128 / 64) * 24 * 0.5 = 24 GPU-hours
```

## Storage billing

For storage, your project is allocated TB-hours. Storage is billed whenever you
store data in your project folders. Storage is billed by volume used over time.
The billing units are TB-hours.

The number of TB-hours billed depends on the type of storage you are using. See
the [data storage options][data-storage-options] page for an overview of the different storage options.

### Main storage (LUMI-P) billing

The main storage backed by [LUMI-P][lumi-p] is billed directly as:

```text
TB-hours-billed = storage-volume x time-used
```

For example, storing 1.2 TB of data for 4 days consumes:

```text
1.2 TB x 24 hours/day x 4 days = 115.2 TB-hours
```

### Flash storage (LUMI-F) billing

The flash storage backed by [LUMI-F][lumi-f] is billed at a 3x rate compared
to the main storage:

```text
TB-hours-billed = 3 x storage-volume x time-used
```

For example, storing 1.2 TB of data for 4 days consumes:

```text
3 x 1.2 TB x 24 hours/day x 4 days = 345.6 TB-hours
```

### Object storage (LUMI-O) billing

The object storage backed by [LUMI-O][lumi-o] is billed at a 0.25x rate compared
to the main storage:

```text
TB-hours-billed = 0.25 x storage-volume x time-used
```

For example, storing 1.2 TB of data for 4 days consumes:

```text
0.25 x 1.2 TB x 24 hours/day x 4 days = 28.8 TB-hours
```
