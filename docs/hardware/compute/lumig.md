# GPU nodes - LUMI-G

[storage]: ../../runjobs/lumi_env/storing-data.md
[interconnect]: ../../hardware/interconnect.md
[MI250x-amd]: https://www.amd.com/en/products/server-accelerators/instinct-mi250x
[benchmarks]: https://www.amd.com/en/graphics/server-accelerators-benchmarks
[frontier-gpu-docs]: https://docs.olcf.ornl.gov/systems/frontier_user_guide.html#frontier-compute-nodes

!!! warning
    This page is about a hardware partition that has not yet reached
    general availability.

The LUMI-G hardware partition consists of 2560 GPU based nodes.

| Nodes | CPUs             | CPU cores | Memory  | GPUs                                                         | Disk | Network     |
| :---: | :--------------: | :-------: | :-----: | :----------------------------------------------------------: | :--: | :---------: |
| 2560  | 1x AMD EPYC 7A53 | 64        | 512 GiB | 4x AMD Instinct MI250X,<br>220 compute units,<br>128GB HBM2e | none | 4x 200 Gb/s |

## GPU

Each LUMI-G compute node is equipped with four AMD MI250X GPUs. Based on the
2nd Gen AMD CDNA architecture, the MI250X GPUs each features 2 Graphics Compute
Die (GCD) each with 110 compute units for a total of 220 compute units per GPU.
Each compute unit has 64 stream processors for a total of 14080 stream
processors per GPU. Each MI250X GPU provides 128GB of HBM2e delivering 3.2 TB/s
of memory bandwidth. An in-package Infinity Fabric interface between the GCDs
deliver a theoretical maximum bi-directional bandwidth of up to 400 GB/s.

The theoretical peak performance of one MI250X GPU is:

- **FP64/FP32 Vector** :  47.9 TFLOPS
- **FP64/FP32 Matrix** :  95.7 TFLOPS
- **FP16/BF16**        : 383.0 TFLOPS
- **INT4/INT8**        : 383.0 TOPS

More information can be found here:

- [MI250X information on the AMD website][MI250x-amd]
- [Applications performance and benchmarks][benchmarks]
- [Frontier GPU node description][frontier-gpu-docs]

## CPU

Each LUMI-G compute node is equipped with a single AMD EPYC 7A53 "Trento" CPU
with 64 cores.

## Network

The LUMI-G compute nodes each have four 200 Gb/s interfaces to the
[Slingshot-11 interconnect][interconnect] with one interface directly connected
to each GPU. Thus, all network communication (even for the CPU) must go via one
of the GPU network interfaces.

## Disk storage

There is no local storage on the compute nodes in LUMI-G. You have to use one of
the [network based storage options][storage].