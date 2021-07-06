# LUMI-C: The CPU Partiton

## Compute

The LUMI-C partition consists of 1536 compute nodes with an estimated combined
LINPACK performance of ca. 8 Petaflops.

| Nodes | CPUs                                                  | CPU cores     | Memory   | Local storage | Network     |
| :---: | :---------------------------------------------------: | :-----------: | :------: | :-----------: | :---------: |
| 1376  | AMD EPYC 7763 series<br>(2.45 GHz base, 3.5 GHz boost) | 128<br>(2x64) | 256 GiB  | none          | 1x 100 Gb/s |
| 128   | AMD EPYC 7763 series<br>(2.45 GHz base, 3.5 GHz boost) | 128<br>(2x64) | 512 GiB  | none          | 1x 100 Gb/s |
| 32    | AMD EPYC 7763 series<br>(2.45 GHz base, 3.5 GHz boost) | 128<br>(2x64) | 1024 GiB | none          | 1x 100 Gb/s |


### Cores, core complexes and compute dies

The EPYC 7003 series server CPU has the ["Zen 3" compute core][1], which is the
same core that is found in the Ryzen 5000 series consumer CPUs. The cores are
fully x64-64 compatible and support AVX2 256-bit vector instructions for a
maximum throughput of 16 double precision FLOPS.

[1]: https://en.wikipedia.org/wiki/Zen_3

### Non-uniform memory access (NUMA) configuration

The EPYC server CPU consists of multiple chips, so-called core complex dies
(CCDs). There are 8 CCDs with 8 cores each and they are all connected to a
central I/O die which contains the memory controller. There are 8 memory
channels with a peak theoretical bandwidth 204.8 GB/s per socket.

The number of NUMA zones in a CPU socket can be configured to from 1 up to 4. On
the LUMI-C compute nodes, the standard configuration is 4 NUMA zones
("quadrant mode") with 2 Core Complex Dies (CCDs) per quadrant.

## Network

At first, the LUMI-C nodes will have a 100 Gb/s network card (HPE/Cray 
Slingshot), but the nodes will later be upgraded to 200 Gb/s when LUMI-G
becomes operational in 2022.

## Storage

There is no local storage on the compute nodes in LUMI-C. You have to use one of
the parallel file systems.
