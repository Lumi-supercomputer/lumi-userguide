# GPU nodes - LUMI-G

[storage]: ../../runjobs/lumi_env/storing-data.md
[interconnect]: ../../hardware/interconnect.md
[MI250x-amd]: https://www.amd.com/en/products/server-accelerators/instinct-mi250x
[benchmarks]: https://www.amd.com/en/graphics/server-accelerators-benchmarks

The LUMI-G hardware partition consists of 2560 GPU-based nodes.

| Nodes | CPUs                       | Memory  | GPUs                                  | Disk | Network     |
| :---: | :------------------------: | :-----: | :-----------------------------------: | :--: | :---------: |
| 2560  | 1x 64 cores AMD EPYC 7A53  | 512 GiB | 4x AMD Instinct MI250X<br>128GB HBM2e | none | 4x 200 Gb/s |

Each LUMI-G compute nodes is equipped with four AMD MI250X GPUs. Based on the
2nd Gen AMD CDNA architecture. A MI250x GPU is a multi-chip module (MCM) with 
two GPU dies named by AMD Graphics Compute Die (GCD). Each of these dies features 
110 compute units (CU) and have access to a 64 GB slice of HBM memory for a total
of 220 CUs and 128 GB total memory per MI250x module. An in-package Infinity 
Fabric interface between the GCDs deliver a theoretical peak bidirectional
bandwidth of up to 400 GB/s. From a software perspective as well as from the
Slurm perspective, one MI250x module is considered as two GPUs. It means the
LUMI-G nodes can be considered as 8 GPUs nodes. 

More information about the AMD MI250x can be found here:

- [MI250X information on the AMD website][MI250x-amd]
- [Applications performance and benchmarks][benchmarks]

In addition to the GPU, LUMI-G nodes feature a single 64-core AMD EPYC 7A53
"Trento" CPU configured as 4 NUMA nodes (NPS4). Each of these NUMA nodes have
two links to one of the four MI250x modules: one link per GCD and a group of 8 
cores + L3 cache with a peak bandwidth of 36 GB/s.

The figure below gives a general overview of a LUMI-G node as well as the 
topology of the CPU-GPU and GPU-GPU links. 

<figure>
  <img 
    src="../../../assets/images/lumig-node-architecture.svg" 
    width="842"
    alt="LUMI-G compute nodes overview"
  >
  <figcaption>Overview of a LUMI-G compute node</figcaption>
</figure>

From the figure above, you can see that there is no direct link between the GPU
(GCD) numbering and the NUMA node numbering. Keep this in mind as prober NUMA
and GPU binding is critical to achieve good performance.

## Network

The LUMI-G compute nodes each have four 200 Gb/s interfaces to the
[Slingshot-11 interconnect][interconnect] with one interface directly connected
to each GPU. Thus, all network communication (even for the CPU) must go via one
of the GPU network interfaces.

## Disk storage

There is no local storage on the compute nodes in LUMI-G. You have to use one of
the [network based storage options][storage]. 