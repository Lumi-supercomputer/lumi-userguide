# Technical details about LUMI-G

## Compute

The LUMI-G partition is the main part of LUMI capable of a 552 PF/s LINPACK
performance when using all the GPUs. 

### Nodes

The complete technical specifications for the LUMI-G nodes are still secret
under non-disclosure agreements. This is the information that we can currently
reveal:

| Number of Nodes | CPU                                                                       | GPU                                       | Memory | Local storage | Network     |  
|-----------------|---------------------------------------------------------------------------|-------------------------------------------|--------|---------------|-------------|   
| T.B.A.          | AMD custom-made "Zen 3" CPU with 64 cores at 2.x GHz<br>Only 1 CPU socket | 4x AMD MI200<br>with >= 32 GB HBM2 memory | 512 GB | none          | 4x 100 Gb/s |


### CPU specfications

The EPYC 7003 series server CPU has the ["Zen 3" compute core](1), which is the
same core that is found in the Ryzen 5000 series consumer GPUs. The cores are
fully x64-64 compatible and support AVX2 256-bit vector instructions for a
maximum throughput of 16 double precision FLOPS.

More to come on the exact CPU model!

[1]: https://en.wikipedia.org/wiki/Zen_3

### GPUs specs

More to come!

## Network

The LUMI-G nodes will have a 4 network connection with 100 Gb/s each to the
Slingshot network. There is one connection per GPU. This means that the GPUs can
talk to each other directly over the network.

## Storage

There is no local storage on the compute nodes in LUMI-G. You have to use one of
the parallel file systems.

