---
hide:
  - navigation
---

# Technical details about LUMI-D

The LUMI-D partition consists of 12 servers with large memory capacity and Nvidia GPUs. LUMI-D is intended for interactive data analytics and visualization. It is also a good place to run pre- and post-processing jobs which require a lot of memory.

| Nodes | CPUs  | Memory   | GPUs                                     | Local storage      | Network     |
| :---: | :------------------------------: | :------: | ---------------------------------------- | :-------: | :---------: |
| 4     | AMD EPYC 7742<br>with 64 cores at 2.25 GHz<br>2 CPU sockets per node | 8192 GiB | none                                     | 25 TB SSD | 2x 100 Gb/s |
| 8     | AMD EPYC 7742<br>with 64 cores at 2.25 GHz<br>2 CPU sockets per node | 2048 GiB | 8x Nvidia Quadro RTX 8000<br>each with 48 GiB memory  | 14 TB SSD | 2x 100 Gb/s |

**Note**: The CPUs in LUMI-D are one generation older (Zen 2 / "Rome") than in LUMI-C and LUMI-G (Zen 3 / "Milan"). There should be no big problem with software compatibility, though, as only a few new processor instructions related to encryption and virtualization was added to the Zen 3 core. We expect that almost all programs compiled for LUMI-C and LUMI-G (e.g. with `-march=znver3`) will run on LUMI-D with good performance. Please see this page [FIXME] for more information about Zen 2 vs Zen 3 differences.

## GPUs

The interactive GPU nodes have 8 Nvidia Quadro RTX 8000 GPUs each with 4,608 CUDA cores, 576 Tensor cores, 72 RT cores and 48 GiB GDDR6 memory. The current Nvidia driver verion is [FIXME]. The CUDA Toolkit for GPU development is also installed so that it is possible to run and test CUDA code, but the main purpose of these GPUs is visualization, not GPU computing.

Links:

* [Nvidia Product Page](https://www.nvidia.com/en-us/design-visualization/quadro/rtx-8000/)
* [Nvidia Data Sheet](https://www.nvidia.com/content/dam/en-zz/Solutions/design-visualization/quadro-product-literature/quadro-rtx-8000-us-nvidia-946977-r1-web.pdf)

## Storage

* The servers in LUMI-D have local SSDs with a total capacity of 25 TB for the four CPU-only nodes and 14 TB for the eight GPU nodes [FIXME]. This storage is accessible on the path `/scratch/local` [FIXME]. It is a good idea to use the local disks when working with many small files (e.g. compiling), because that will be faster than using the parallel file system.
* The LUMI-D nodes are connected with 2x 100 Gb/s adapters to the HPE/Cray Slingshot network, which means that they can access to all the parallel file systems (LUMI-P and LUMI-F) with good performance.
