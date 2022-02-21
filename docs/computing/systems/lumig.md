# LUMI-G: The GPU Partition

[MI250x-amd]: https://www.amd.com/en/products/server-accelerators/instinct-mi250x
[benchmarks]: https://www.amd.com/en/graphics/server-accelerators-benchmarks

!!! warning
    This page is about a partition that is not yet available

The GPU partition will consist of 2560 nodes, each node with one 64 core AMD 
Trento CPU and four AMD MI250X GPUs. Each MI250X GPU consists of two compute 
dies, each with 110 compute units. Each compute unit has 64 stream processors 
for a total of 14080 stream processors.

| Nodes | CPUs       | CPU cores | Memory   | GPUs                                                       | Network     |
| :---: | :--------: | :-------: | :------: | :--------------------------------------------------------- | :---------: |
| 2560  | AMD Trento | 64        | 512 GiB  | 4x AMD Instinct MI250X<br>220 Compute units<br>128GB HBM2e | 4x 200 Gb/s |

## MI250X overview

Based on the 2nd Gen AMD CDNA architecture, the MI250X GPUs features 2 Graphics
Compute Die (GCD) each with 110 compute units for a total of 220 compute
units per GPU. Each MI250X GPU provides 128GB of HBM2e delivering 3.2 TB/s of 
memory bandwidth. An in-package Infinity Fabric interface between the GCDs 
deliver a theoretical maximum bi-directional bandwidth of up to 400 GB/s.

Below, a summary of the theoretical peak performance of one MI250X:

- **FP64/FP32 Vector** :  47.9 TFLOPS
- **FP64/FP32 Matrix** :  95.7 TFLOPS
- **FP16/BF16**        : 383.0 TFLOPS
- **INT4/INT8**        : 383.0 TOPS 

More information can be found here:

- [MI250X information on the AMD website][MI250x-amd]
- [Applications performance and benchmarks][benchmarks]

## Installation timeline

LUMI-G is not yet installed, the current timeline is as follows:

- **mid-March 2022**: 6 cabinets (140 Pflop/s)
- **early May 2022**: start of the LUMI-G pilot phase
- **mid-June 2022**: the rest of LUMI-G
- **Summer 2022**: general availability
