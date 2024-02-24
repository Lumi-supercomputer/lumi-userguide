# CPU nodes - LUMI-C

[storage]: ../storage/index.md
[interconnect]: network.md
[slurm-partitions]: ../runjobs/scheduled-jobs/partitions.md
[zen3-wiki]: https://en.wikipedia.org/wiki/Zen_3

The LUMI-C hardware partition consists of 2048 CPU-based compute nodes. Some of
these nodes contain more memory than others as specified in the table below.

| Nodes | CPUs                                               | CPU cores     | Memory   | Disk | Network     |
| :---: | :------------------------------------------------: | :-----------: | :------: | :--: | :---------: |
| 1888  | 2x AMD EPYC 7763<br>(2.45 GHz base, 3.5 GHz boost) | 128<br>(2x64) | 256 GiB  | none | 1x 200 Gb/s |
| 128   | 2x AMD EPYC 7763<br>(2.45 GHz base, 3.5 GHz boost) | 128<br>(2x64) | 512 GiB  | none | 1x 200 Gb/s |
| 32    | 2x AMD EPYC 7763<br>(2.45 GHz base, 3.5 GHz boost) | 128<br>(2x64) | 1024 GiB | none | 1x 200 Gb/s |

See the [Slurm partitions page][slurm-partitions] for an overview of options
for allocating these nodes.

## CPU

Each LUMI-C compute node is equipped with two AMD EPYC 7763 CPUs with 64 cores
each running at 2.45 GHz for a total of 128 cores per node. The cores have
support for 2-way simultaneous multithreading (SMT) allowing for up to 256
threads per node.

The AMD EPYC 7763 CPU cores are ["Zen 3" compute cores][zen3-wiki], the same
core that can be found in the Ryzen 5000 series consumer CPUs. These cores are
fully x86-64 compatible and support AVX2 256-bit vector instructions for a
maximum throughput of 16 double precision FLOP/clock (AVX2 FMA operations). The
cores have 32 KiB of private L1 cache, a 32 KiB instruction cache, and 512 KiB
of L2 cache.

<figure>
  <img 
    src="../../assets/images/milan-overview.svg" 
    width="560"
    alt="Overview of an AMD EPYC 7763 CPU"
  >
  <figcaption>Overview of an AMD EPYC 7763 CPU</figcaption>
</figure>

The EPYC CPUs consist of multiple chiplets, so-called core complex dies (CCDs).
There are 8 CCDs per processor with 8 cores each. The L3 cache is shared
between the eight cores of a CCD and has a capacity of 32 MiB for a total 256
MiB of L3 cache per processor. Note this differs from the earlier Zen 2 and
EPYC 7002-series processors where 4 cores shared the L3 cache, and there were
two groups of 4 cores (a "CCX") inside each CCD. This can improve the
performance of certain workloads as a single core can have access to more L3
cache.

The CCD units are all connected to a central I/O die which contains the memory
controller. There are 8 memory channels with a peak theoretical bandwidth of
204.8 GB/s per socket.

The LUMI-C compute nodes are configured with 4 NUMA zones ("quadrant mode")
with 2 CCDs per quadrant. The figure below gives you an overview of the
distances between the NUMA nodes.

<figure>
  <img 
    align="left" 
    src="../../assets/images/numa-lumic.svg" 
    width="400"
    alt="Distances between NUMA nodes"
  >
  <figcaption>Distances between NUMA nodes</figcaption>
</figure>

The two processors within a node are connected by four bidirectional and 16-bit
wide links operating at 16 Gbps each. This provides a peak bandwidth of 256 GB/s.

[1]: https://en.wikipedia.org/wiki/Zen_3

## Network

The LUMI-C compute nodes each have a single 200 Gb/s interface to the [Slingshot-11
interconnect][interconnect].

## Disk storage

There is no local storage on the compute nodes in LUMI-C. You have to use one of
the [network-based storage options][storage].
