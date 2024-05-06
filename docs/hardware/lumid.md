# Data Analytics Nodes - LUMI-D

[lumic]: ../hardware/lumic.md
[storage]: ../storage/index.md
[interconnect]: network.md
[a40-product]: https://www.nvidia.com/en-us/data-center/a40/
[a40-specs]: https://www.nvidia.com/content/dam/en-zz/Solutions/Data-Center/a40/proviz-print-nvidia-a40-datasheet-us-nvidia-1469711-r8-web.pdf

The LUMI-D partition consists of 16 nodes with large memory capacity, of
which 8 nodes also feature Nvidia visualization GPUs. LUMI-D is intended for
interactive data analytics and visualization.

| Nodes | CPUs                                               | CPU cores          | Memory | GPUs                                  | Disk      | Network    |
|-------|----------------------------------------------------|--------------------|--------|---------------------------------------|-----------|------------|
| 8     | 2x AMD EPYC 7742<br>(2.25 GHz base,<br> 3.4 GHz boost) | 128 cores (2x64)   | 4 TiB   | none                                  | 25 TB SSD | 2x200 Gb/s |
| 8     | 2x AMD EPYC 7742<br>(2.25 GHz base,<br> 3.4 GHz boost) | 128 cores (2x64)   | 2 TiB   | 8x NVIDIA A40,<br>48 GB of memory     | 14 TB SSD | 2x200 Gb/s |

## CPU
The CPUs in LUMI-D are one generation older (Zen 2 / "Rome") than in
[LUMI-C][lumic] (Zen 3 / "Milan"). There should be no big problem with software
compatibility, though, as only a few new processor instructions related to
encryption and virtualization was added to the Zen 3 core. We expect that
almost all programs compiled for LUMI-C (e.g. with `-march=znver3`) will run on
LUMI-D with good performance.

## GPU

The visualization GPU nodes have 8 NVIDIA A40 GPUs each with 10 752 CUDA cores,
336 Tensor cores, 84 RT cores and 48 GiB GDDR6 Memory. The CUDA Toolkit for GPU
development is also installed so that it is possible to run and test CUDA code,
but the main purpose of these GPUs is visualization, not GPU computing.

* [Nvidia A40 Product Page][a40-product]
* [Nvidia A40 Data Sheet][a40-specs]

## Network

The LUMI-D compute nodes each have two 200 Gb/s interfaces to the [Slingshot-11
interconnect][interconnect].

## Disk storage

The LUMI-D nodes provide some local disk storage. Additionally, you have
access to all the [network-based storage options][storage].
