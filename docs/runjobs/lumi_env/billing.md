[lumi-c]: ../../hardware/lumic.md
[lumi-g]: ../../hardware/lumig.md  
[lumi-d]: ../../hardware/lumid.md  
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

- Compute is billed in units of CPU-core-hours for CPU nodes, and in GPU-hours for GPU nodes (except for the `lumid` visualization partition of LUMI-D, which is also billed in CPU-core-hours since May 2026).
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


### GPU nodes - LUMI-G

For GPU compute on the LUMI'sAMD MI250X GPU nodes, your project is allocated GPU-hours that are consumed
when running jobs on the GPU nodes. A GPU-hour corresponds to the allocation
of a full [MI250x module (2 GCDs)][lumi-g] for one hour, i.e. on LUMI-G, one node hour corresponds to 4 GPU-hours.  

#### Partitions allocatable by node 

- Slurm partitions: `standard-g`  

The partition `standard-g` is operated in exclusive mode: it's not possible to reserve a part of a node on this partition, but entire nodes will always be allocated for your jobs, and four MI250x GPU modules (8 GCD's) are thus billed for every allocated node even if your job has requested less than 8 GCD's per node.  

The billing formula is:

```text
GPU-hours-billed = 4 * NNodes * runtime-of-job
```

For example, allocating 4 nodes and running for 24 hours on standard-g consumes:

```text
4 * 4 nodes * 24 hours = 384 GPU-hours
```

#### Partitions allocatable by resources 

- Slurm partitions: `small-g`, `dev-g`  


For the `small-g` and `dev-g` partitions, where allocation can be done at 
the level of Graphics Compute Dies (GCD's), you will be billed at a 0.5 rate per
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

For example, a job allocating 2 GCDs and running for 24 hours consumes:


```text
2 GCD's * 24 hours * 0.5 = 24 GPU-hours
```

If you allocate 1 GCD for 24 hours but allocate 128 GB of memory, then you will
be billed for this memory:

```
(128 GB / 64 GB) * 24 hours * 0.5 = 24 GPU-hours
```

### CPU nodes - LUMI-C

For CPU compute, your project is allocated CPU-core-hours that are consumed
when running jobs on the CPU nodes.   


#### Partitions allocatable by node 

- Slurm partitions: `standard`  


The `standard` partition is operated in exclusive mode: it's not possible to reserve a part of a node on this partition, but entire nodes will always be allocated for your jobs. 128 CPU-core-hours are billed for every allocated node and per hour even if your job has requested less than 128 cores per node.




The billing formula is:

```text
CPU-core-hours-billed = NNodes * 128 CPU-cores/node * runtime-of-job
```

For example, allocating 16 nodes and running for 12 hours on standard consumes:

```text
16 nodes * 128 CPU-cores/node * 12 hours = 24576 CPU-core-hours
```

#### Partitions allocatable by resources 

- Slurm partitions: `small`, `debug`  


When using the partitions `small` or `debug`, you are billed per allocated core. However, if you are above a certain threshold of memory allocated per core, you are billed per slice of 2GB memory (which is still billed in units of CPU-core-hours).
Using the high memory nodes in [LUMI-C][lumi-c] is thus more expensive.


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

For example, allocating 4 CPU-cores and 8GB of memory in a job running for 1 day
consumes:

```text
4 CPU-cores x 24 hours = 96 CPU-core-hours
```

Allocating 4 CPU-cores and 32GB of memory in a job running for 1 day consumes:

```text
(32GB / 2GB) x 24 hours = 384 CPU-core-hours
```



### Data analytics nodes - LUMI-D

The data analytics nodes of [LUMI-D hardware partition][lumi-d] include [large memory CPU nodes][lumid-cpu], and [Nvidia GPU nodes][lumid-gpu] for visualization purposes. These partitions are billed in CPU-core-hours. 

#### Large memory nodes

- Slurm partitions: `largemem`

The partition `largemem` is operated in exclusive mode, i.e. full nodes (128 CPU-cores) are always allocated for your jobs. 

If you request less than 256 GB/node, your job is billed by the requested CPU-cores (i.e. for 128 CPU-cores per node). If you request more than 256 GB/node, your job is billed by the allocated memory. 

Specifically, the formula used for billing is:

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

For example, allocating 128 CPU-cores (1 node) and 256 GB of memory in a job running for 1 day
consumes:

```text
128 CPU-cores x 24 hours = 3 072 CPU-core-hours
```

Allocating 128 CPU-cores (1 node) and 3000 GB of memory in a job running for 1 day consumes:

```text
(3000 GB / 2 GB) x 24 hours = 36 000 CPU-core-hours
```



#### Visualization partition

- Slurm partitions: `lumid`  


The `lumid` visualization nodes in [LUMI-D][lumid-gpu] are billed in CPU-core-hours (since May 2026).

<!--
will consume 32 CPU hours per hour for the usage of the visualization GPUs
or 1/8 of the CPU or memory resources in a node.

max(ceil(ncpus/16),ceil(memory_gib/256),ngpus)*64 CPU hours (per hour of usage)

-->
Specifically, the formula used for billing is:  

```text
CPU-core-hours-billed = 
    max(
        ceil(CPU-cores-allocated / 16), 
        ceil(memory-allocated / 256 GB), 
        GPUs-allocated )
  * 64 * runtime-of-job
```
_Note that with Nvidia GPU nodes the term 'GCD' is not used, and one GPU instance ("1/8 of a GPU node") is just referred as 'GPU'._ 


For example, a job allocating 1 GPU and running for 0.5 hours, 
consumes:

```text
1 * 64 * 0.5 hours = 32 CPU-core-hours
```

If you allocate 1 GPU for 4 hours but allocate 512 GB of memory, then you are billed for this memory:

```
(512 GB / 256 GB) * 64 * 4 hours = 512 CPU-core-hours
```




## Storage billing

For storage, your project is allocated TB-hours. Storage is billed whenever you
store data in your project folders. Storage is billed by volume used over time.
The billing units are TB-hours.

The number of TB-hours billed depends on the type of storage you are using. See
the [data storage options][data-storage-options] page for an overview of the different storage options.

### Main storage - LUMI-P

The main storage backed by [LUMI-P][lumi-p] is billed directly as:

```text
TB-hours-billed = storage-volume x time-used
```

For example, storing 1.2 TB of data for 4 days consumes:

```text
1.2 TB x 24 hours/day x 4 days = 115.2 TB-hours
```

### Flash storage - LUMI-F

The flash storage backed by [LUMI-F][lumi-f] is billed at a 3x rate compared
to the main storage:

```text
TB-hours-billed = 3 x storage-volume x time-used
```

For example, storing 1.2 TB of data for 4 days consumes:

```text
3 x 1.2 TB x 24 hours/day x 4 days = 345.6 TB-hours
```

### Object storage - LUMI-O

The object storage backed by [LUMI-O][lumi-o] is billed at a 0.25x rate compared
to the main storage:

```text
TB-hours-billed = 0.25 x storage-volume x time-used
```

For example, storing 1.2 TB of data for 4 days consumes:

```text
0.25 x 1.2 TB x 24 hours/day x 4 days = 28.8 TB-hours
```
