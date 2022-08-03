# Data Analytics Nodes

[a40-product]: https://www.nvidia.com/en-us/data-center/a40/
[a40-specs]: https://www.nvidia.com/content/dam/en-zz/Solutions/Data-Center/a40/proviz-print-nvidia-a40-datasheet-us-nvidia-1469711-r8-web.pdf

!!! warning
    Only the large memory nodes of LUMI-D are available at the moment.

</br>

The LUMI-D partition consists of a 16 nodes with large memory capacity and
Nvidia GPUs. LUMI-D is intended for interactive data analytics and
visualization. It is also a good place run pre- and post-processing jobs that
require a lot of memory.



| Nodes | CPU                                                                 | Memory | GPUs                                 | Disk      | Network    |
|-------|---------------------------------------------------------------------|--------|--------------------------------------|-----------|------------|
| 8     | AMD EPYC 7742<br>2.25 GHz base<br>3.4 GHz boost<br>128 cores (2x64) | 4 TB   | none                                 | 25 TB SSD | 2x100 Gb/s |
| 8     | AMD EPYC 7742<br>2.25 GHz base<br>3.4 GHz boost<br>128 cores (2x64) | 2 TB   | 8x NVIDIA A40<br>48 GB of memory | 14 TB SSD | 2x100 Gb/s |

**Note**: The CPUs in LUMI-D are one generation older (Zen 2 / "Rome") than in
LUMI-C (Zen 3 / "Milan"). There should be no big problem with
software compatibility, though, as only a few new processor instructions related
to encryption and virtualization was added to the Zen 3 core. We expect that
almost all programs compiled for LUMI-C (e.g. with `-march=znver3`)
will run on LUMI-D with good performance.

## GPUs

The interactive GPU nodes have 8 NVIDIA A40 GPUs each with 10 752 CUDA
cores, 336 Tensor cores, 84 RT cores and 48 GiB GDDR6 Memory. The CUDA Toolkit 
for GPU development is also installed so that it is possible to run and test 
CUDA code, but the main purpose is visualization of these GPUs are visualizing,
not GPU computing.

* [Nvidia A40 Product Page][a40-product]
* [Nvidia A40 Data Sheet][a40-specs]
