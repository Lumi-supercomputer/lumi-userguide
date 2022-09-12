[lumi-c]: ../../computing/systems/lumic.md

# Billing policy

Running jobs on the compute nodes and storing data on the storage will consume
the billing units allocated to your project:

- Compute is billed in units of CPU-core-hours for CPU-nodes and GPU-hours for GPU-nodes.
- Storage is billed in units of TB-hours.

## Compute billing

### CPU billing

For compute, your project is allocated CPU-core-hours that are consumed when
running jobs. Depending on the partition, the way this billing is carried out
differs.

### Slurm partition billing details

For some [slurm partitions][slurm-partitions] special billing rules apply.

#### Standard and bench partitions

The `standard` and `bench` partitions are operated in exclusive mode: the
entire node will always be allocated. In practice, 128 core-hours are billed
for every allocated node and per hour even if your job has requested less than
128 cores per node.

For example, 16 nodes for 12 hours: 

```
16 nodes x 12 hours x 128 core-hour = 24576 core-hours
```

#### Small partition

When using the small partition you are billed per allocated core. However, if
you are above a certain threshold of memory allocated per core, i.e. you use
the high memory nodes in [LUMI-C][lumic], you are billed in slices of 2GB of
memory. Specifically, the formula that is used for billing is:

```
corehours = max(ncore, ceil(mem/2GB)) x time
```

Thus,
- if you use less than 2GB of memory per core, you are charged per allocated
  cores
- if you use more than 2GB of memory per core, you are charged per 2GB slice
  of memory
- if you are using the large memory nodes in [LUMI-C][lumic] you will be billed per 2GB slice
  of memory

For example, 4 cores, 4GB of memory for 1 day:

```
4 cores x 24 hours = 96 core-hours
```

For example, 4 cores, 32GB of memory for 1 day:

```
32GB / 2GB x 24 hours = 384 core-hours
```

### Checking core hours used

You can use the commands `sreport` and `sacct` to see how many core hours your project has consumed so far. These commands query the accounting database used by SLURM and are always up to date. For example, to get a summary of a how much a certain project has run start from the start of a certain date up until now, you can write:

```
sreport -t hours cluster AccountUtilization account=project_465000XXX start=2022-01-01 end=now

```

Example output:

    --------------------------------------------------------------------------------
      Cluster         Account     Login     Proper Name       Used   Energy 
    --------- --------------- --------- --------------- ---------- -------- 
         lumi project_465000+                               739228        0 
         lumi project_465000+     spock           Spock     120228        0 
         lumi project_465000+      data            Data     300000        0 
         lumi project_465000+      tpol           T'Pol     319000        0 


The top row is summary for all project members. Please note that SLURM counts usage in CPU thread hours, so the numbers need to be divided by 2 to get the corresponding CPU core hours.

## Storage billing

Storage is billed by volume used over time. The billing units are TB-hours,
i.e. using one TB of storage for one hour will be billed as one TB-hour.

### Regular Lustre file system

On the regular (spinning disk) Lustre file system, 1GB of data consume 1GB-hour
out of your storage allocation for every hour it stays on the file system.

For example, 375GB for 4 days:

```
375 GB x 4 days x 24 hours = 36000 GB-hours
```

### Flash Lustre file system

The flash based filesytem is billed at a 10x rate: 1GB of data consume 10GB-hour
out of your storage allocation for every hour it stays on the file system. As
a consequence, if you don't want to consume your storage allocation too quickly,
it's recommended to remove your data from the flash file system as soon as possible.

For example, 150GB for 2 days:

```
150 GB x 2 days x 24 hours x 10 = 72000 GB-hours
```
