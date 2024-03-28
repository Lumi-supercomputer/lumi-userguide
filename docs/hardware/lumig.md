---
hide:
  - toc
---

# GPU nodes - LUMI-G

[storage]: ../storage/index.md
[network]: ./network.md
[MI250x-amd]: https://www.amd.com/en/products/accelerators/instinct/mi200/mi250x.html
[benchmarks]: https://www.amd.com/en/graphics/server-accelerators-benchmarks
[zen3-wiki]: https://en.wikipedia.org/wiki/Zen_3

The LUMI-G hardware partition consists of 2978 nodes with 4 AMD MI250x GPUs and 
a single 64 cores AMD EPYC "Trento" CPU. The aggregated HPL Linpack performance
of LUMI-G is 379.70 PFlop/s.

<figure>
  <img 
    src="../../assets/images/lumig-overview.svg" 
    width="800"
    alt="LUMI-G overview"
  >
  <figcaption>Overview of a LUMI-G compute node</figcaption>
</figure>

The LUMI-G compute nodes are equipped with four AMD MI250X GPUs based on the
2nd Gen AMD CDNA architecture. A MI250x GPU is a multi-chip module (MCM) with 
two GPU dies named by AMD Graphics Compute Die (GCD). Each of these dies features 
110 compute units (CU) and has access to a 64 GB slice of HBM memory for a total
of 220 CUs and 128 GB total memory per MI250x module.

!!! note "GCDs are GPUs for Slurm and the HIP runtime"

    From a software perspective as well as from the Slurm perspective, one
    MI250x module is considered as two GPUs. It means the LUMI-G nodes can be
    considered as 8 GPUs nodes. If you do a `hipGetDeviceCount` runtime call the
    value returned for a full node will be 8.

More information about the AMD MI250x can be found here:

- [MI250X information on the AMD website][MI250x-amd]
- [Applications performance and benchmarks][benchmarks]

The LUMI-G nodes CPU is a single 64-core AMD EPYC 7A53 "Trento" CPU. The cores
of this CPU are ["Zen 3" compute cores][zen3-wiki] supporting AVX2 256-bit
vector instructions for a maximum throughput of 16 double precision FLOP/clock
(AVX2 FMA operations). The cores have 32 KiB of private L1 cache, a 32 KiB
instruction cache, and 512 KiB of L2 cache. The L3 cache is shared between the
groups of eight cores and has a capacity of 32 MiB for a total 256 MiB of L3
cache per processor. The CPU is configured as 4 NUMA nodes (NPS4), i.e., 128 GiB
of DDR4 memory per NUMA node for a total of 512 GiB CPU memory.

The figure below gives a general overview of a LUMI-G node as well as the 
topology of the CPU-GPU and GPU-GPU links.

<figure>
  <img 
    src="../../assets/images/lumig-node-overview.svg" 
    width="990"
    alt="LUMI-G compute node overview"
  >
  <figcaption>Overview of a LUMI-G compute node</figcaption>
</figure>

The two GCDs in the MI250x modules are connected by an in-package Infinity
Fabric interface that can provide a theoretical peak bidirectional bandwidth of
up to 400 GB/s. Additionally, GCDs on different MI250x modules are linked with
either a single or double Infinity Fabric link, which can provide a peak
bidirectional bandwidth of 100 GB/s and 200 GB/s, respectively.

It is important to note that there is no direct correlation between the GPU
(GCD) numbering and the NUMA node numbering. For example, NUMA 0/core 0 is not
connected to GPU 0/GCD 0. Properly binding the NUMA node to the GPU might be
crucial for achieving optimal performance in your application. The figure below
illustrates these links from both the CPU and GPU perspectives.

<figure>
  <img 
    src="../../assets/images/lumig-cpu-gpu-links.svg" 
    width="900"
    alt="LUMI-G CPU-GPU links"
  >
  <figcaption>CPU-GPU links from a CPU centric or GPU centric point of view</figcaption>
</figure>

Each MI250x module is directly connected to the slingshot-11 network providing
up to 25+25 GB/s peak bandwidth.
Details about the LUMI network are provided [here][network].

To summarize, each MI250x modules have 5 GPU-GPU links, 2 CPU-GPU links and 1 
PCIe links to the slingshot-11 interconnect.


## The MI250x Graphics Compute Die

As mentioned previously, the MI250x GPU modules have two Graphics Compute Dies (GCD).
Each GCD has 112 physical compute units (CUs), but 2 of these are disabled
which means that 110 CU can actually be used.
To boost memory throughput, all CU share a L2 cache.
This L2 cache has an 8 MB capacity and is
divided in 32 slices capable of delivering 128 B/clock/slice for a total of 6.96
TB/s peak theoretical bandwidth.

The L2 cache also improves synchronization capabilities for algorithms that rely
on atomic operations to coordinate communication across an entire GPU. These 
atomic operations are executed close to the memory in the L2 cache.

<figure>
  <img 
    src="../../assets/images/mi250x-gcd.svg" 
    width="800"
    alt="MI250x Graphics Compute Die (GCD)"
  >
  <figcaption>Overview of MI250x Graphics Compute Die (GCD)</figcaption>
</figure>

When a kernel is dispatched for execution on the GPU, it is in the form of a
grid of thread blocks. This grid, as well as the thread blocks themselves, can
be one, two, or three-dimensional. The size of the grid or block is determined
by the programmer, but there are limits on the size.

- **Grid**: the number of blocks that can be specified along each dimension is
  (2147483647, 2147483647, 2147483647)
- **Block**: the maximum number of threads for each dimension is 
  (1024, 1024, 1024) with an upper thread block size limit of 1024, i.e.,
  `size.x * size.y * size.z <= 1024`.

!!! note "About terminology"
    
    AMD occasionally refers to thread blocks as workgroups, and to threads as
    work-items. However, the terms thread and thread block are more commonly 
    used, as they are more familiar to CUDA programmers.

The thread blocks are assigned to one of the 110 compute units (CUs) and are
scheduled in groups of 64 threads known as wavefronts. This is comparable to a
warp on NVIDIA hardware, with the primary distinction being that a warp consists
of 32 threads, while a wavefront comprises 64 threads.

The figure below presents a schematic view of a MI250x compute unit.

<figure>
  <img 
    src="../../assets/images/mi250x-compute-unit.svg" 
    width="800"
    alt="MI250x Compute Unit (CU)"
  >
  <figcaption>Overview of a LUMI-G compute node</figcaption>
</figure>

The way the wavefronts are executed by a compute unit is the following:

- a wavefront consisting of 64 work-items is assigned to one of the 16-wide
  SIMD units
- the majority of the instructions execute in a single cycle, with one instruction
  necessitating four cycles per wavefront
- as there are four SIMD units per compute unit, allowing four wavefronts to be
  executed concurrently, the throughput remains constant at one instruction per
  wavefront per compute unit

The compute units have 512 64-wide 4 bytes Vector General Purpose Registers
(VGPRs).  In addition to these registers, the unit also provides access to low
latency storage through a 64 kB Local Data Share (LDS). This shared memory is
akin to NVIDIA's "shared memory" and is accessible to all threads within a block
(workgroup). The programmer manages the LDS allocation. Additionally,
each compute unit has access to 16 kB of L1 cache.

The vector ALUs are completed by matrix cores optimized to execute Matrix Fused
Multiply Add (MFMA) instructions. These matrix cores provide significant
acceleration for Generalized Matrix Multiplication (GEMM) computations, which
are essential for Linear Algebra that plays a key role in most High-Performance
Computing applications and AI wokloads. Each compute unit contains four matrix
cores, capable of achieving a throughput of 256 FP64 Flops/cycle/CU.

## Disk storage

There is no local storage on the compute nodes in LUMI-G. You have to use one of
the [network-based storage options][storage]. 
