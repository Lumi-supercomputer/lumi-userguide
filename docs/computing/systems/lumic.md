# LUMI-C: The CPU Partition

[storage]: ../../storage/index.md

The LUMI-C partition consists of 1536 compute nodes with an aggregated LINPACK 
performance of 5.63 Petaflops.

| Nodes | CPUs                                            | CPU cores     | Memory   | Local storage | Network     |
| :---: | :---------------------------------------------: | :-----------: | :------: | :-----------: | :---------: |
| 1376  | AMD EPYC 7763<br>(2.45 GHz base, 3.5 GHz boost) | 128<br>(2x64) | 256 GiB  | none          | 1x 100 Gb/s |
| 128   | AMD EPYC 7763<br>(2.45 GHz base, 3.5 GHz boost) | 128<br>(2x64) | 512 GiB  | none          | 1x 100 Gb/s |
| 32    | AMD EPYC 7763<br>(2.45 GHz base, 3.5 GHz boost) | 128<br>(2x64) | 1024 GiB | none          | 1x 100 Gb/s |


## CPU

Each LUMI-C compute nodes are equipped with two AMD EPYC 7763 CPUs with 64 cores 
each running at 2.5 GHz for a total of 128 cores per node. The cores have 
support for 2-way simultaneous multithreading (SMT) allowing for up to 256 
threads per node.

The EPYC 7763 CPU cores are ["Zen 3" compute cores][1], the same core that can 
be found in the Ryzen 5000 series consumer CPUs. These cores are fully x86-64
compatible and support AVX2 256-bit vector instructions for a maximum 
throughput of 16 double precision FLOP/clock (AVX2 FMA operations). The cores
have 32 KiB of private L1 cache, a 32 KiB instruction cache, and 512 KiB of L2
cache.

<figure>
  <img 
    src="../../../assets/images/milan-overview.svg" 
    width="560"
    alt="Overview of an AMD EPYC 7763 CPU"
  >
  <figcaption>Overview of an AMD EPYC 7763 CPU</figcaption>
</figure>

The EPYC CPUs consist of multiple chiplets, so-called core complex dies
(CCDs). There are 8 CCDs per processor with 8 cores each. The L3 cache is shared
between the eight cores of a CCD and has a capacity of 32 MiB for a total 256 
MiB of L3 cache per processor. Note this differs from the earlier Zen 2 and EPYC 7002-series processors where 4 cores shared the L3 cache and there were two groups of 4 cores (a "CCX") inside each CCD. This can improve the performance of certain workloads as a single core can have access to more L3 cache.

The CCD units are all connected to a central I/O die
which contains the memory controller. There are 8 memory channels with a peak 
theoretical bandwidth of 204.8 GB/s per socket.

The LUMI-C compute nodes are configured with 4 NUMA zones ("quadrant mode") 
with 2 CCDs per quadrant. The figure below, gives you an overview of the 
distances between the NUMA nodes.

<figure>
  <img 
    align="left" 
    src="../../../assets/images/numa-lumic.svg" 
    width="400"
    alt="Distances between NUMA nodes"
  >
  <figcaption>Distances between NUMA nodes</figcaption>
</figure>

The two processors within a node are connected by four bi-directional and 16 Bit 
wide links operating at 16 Gbps each. This provides a peak bandwidth of 256
GB/s.

[1]: https://en.wikipedia.org/wiki/Zen_3

## Network

At first, the LUMI-C nodes will have a 100 Gb/s HPE-Cray Slingshot-10 network
card.

The nodes will later be upgraded to 200 Gb/s Slingshot-11 interconnect when 
LUMI-G becomes operational in 2022.

## Storage

There is no local storage on the compute nodes in LUMI-C. You have to use one of
the [parallel file systems][storage].
