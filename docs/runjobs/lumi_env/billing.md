[lumi-c]: ../../hardware/compute/lumic.md
[lumi-f]: ../../hardware/storage/lumif.md
[lumi-p]: ../../hardware/storage/lumip.md
[slurm-quickstart]: ../../runjobs/scheduled-jobs/slurm-quickstart.md
[slurm-partitions]: ../../runjobs/scheduled-jobs/partitions.md
[data-storage-options]: ../../runjobs/lumi_env/storing-data.md

# Billing policy

Running jobs on the compute nodes and storing data in storage space will consume
the billing units allocated to your project:

- Compute is billed in units of CPU-core-hours for CPU nodes and GPU-hours for
  GPU nodes.
- Storage space is billed in units of TB-hours.

## Compute billing

Compute is billed whenever you submit a job to the [Slurm job
scheduler][slurm-quickstart].

### CPU billing

For CPU compute, your project is allocated CPU-core-hours that are consumed
when running jobs on the CPU nodes. The CPU-core-hours are billed as:

```text
cpu-core-hours-billed = cpu-cores-allocated x runtime-of-job
```

For example, allocating 32 CPU cores in a job running for 2 hours consumes:

```text
32 CPU-cores x 2 hours = 64 CPU-core-hours
```

### Slurm partition billing details

For some [Slurm partitions][slurm-partitions] special billing rules apply.

#### Standard and bench Slurm partitions

The `standard` and `bench` Slurm partitions are operated in exclusive mode: the
entire node will always be allocated. Thus, 128 CPU-core-hours are billed for
every allocated node and per hour even if your job has requested less than 128
cores per node.

For example, allocating 16 nodes in a job running for 12 hours consumes:

```text
16 nodes x 128 CPU-cores/node x 12 hours = 24576 CPU-core-hours
```

#### Small Slurm partition

When using the small Slurm partition you are billed per allocated core.
However, if you are above a certain threshold of memory allocated per core,
i.e. you use the high memory nodes in [LUMI-C][lumi-c], you are billed per
slice of 2GB memory (which is still billed in units of CPU-core-hours).
Specifically, the formula that is used for billing is:

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
(32GB / 2GB) CPU-cores x 24 hours = 384 CPU-core-hours
```

### Checking CPU-core-hours used

You can use the commands `sreport` and `sacct` to see how many CPU-core-hours
your project has consumed so far. These commands query the accounting database
used by Slurm and are always up to date. For example, to get a summary of a how
much a certain project has run starting from a certain date up until now, you
can write:

```bash
$ sreport -t hours cluster AccountUtilization account=project_465000XXX start=2022-01-01 end=now
```

Example output:

```text
--------------------------------------------------------------------------------
  Cluster         Account     Login     Proper Name       Used   Energy 
--------- --------------- --------- --------------- ---------- -------- 
      lumi project_465000+                               739228        0 
      lumi project_465000+     spock           Spock     120228        0 
      lumi project_465000+      data            Data     300000        0 
      lumi project_465000+      tpol           T'Pol     319000        0 
```

The top row is summary for all project members. Please note that Slurm counts
usage in CPU-thread-hours, so the numbers need to be divided by 2 to get the
corresponding CPU-core-hours as there are 2 threads per core in the CPU-nodes.

## Storage billing

For storage, your project is allocated TB-hours. Storage is billed whenever you
store data in your project folders. Storage is billed by volume used over time.
The billing units are TB-hours.

The amount of TB-hours billed depends on the type of storage you are using. See
the [data storage options][data-storage-options] page for an overview of the
type of storage used in the different storage options.

### Main storage (LUMI-P) billing

The main storage backed by [LUMI-P][lumi-p] is billed directly as:

```text
TB-hours-billed = storage-volume x time-used
```

For example, storing 1.2 TB data for 4 days consumes:

```text
1.2 TB x 24 hours/day x 4 days = 115.2 TB-hours
```

### Flash storage (LUMI-F) billing

The flash storage backed by [LUMI-F][lumi-f] is billed at a 10x rate compared
to the main storage:

```text
TB-hours-billed = 10 x storage-volume x time-used
```

For example, storing 1.2 TB data for 4 days consumes:

```text
10 x 1.2 TB x 24 hours/day x 4 days = 1152 TB-hours
```
