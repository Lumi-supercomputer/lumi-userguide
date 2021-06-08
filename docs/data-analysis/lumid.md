# Technical details about LUMI-D

[rtx-8000-product]: https://www.nvidia.com/en-us/design-visualization/quadro/rtx-8000/
[rtx-8000-specs]: https://www.nvidia.com/content/dam/en-zz/Solutions/design-visualization/quadro-product-literature/quadro-rtx-8000-us-nvidia-946977-r1-web.pdf

The LUMI-D partition consists of a 12 servers with large memory capacity and
Nvidia GPUs. LUMI-D is intended for interactive data analytics and
visualization. It is also a good place run pre- and post-processing jobs that
require a lot of memory.

| Nodes | CPU Type                 | CPU cores  | Memory   | GPUs                                     | Disk      | Network    |
|-------|--------------------------|------------|----------|------------------------------------------|-----------|------------|
| 4     | AMD EPYC 7742 (2.25 GHz) | 128 (2x64) | 8192 GiB | n/a                                      | 25 TB SSD | 2x100 Gb/s |
| 8     | AMD EPYC 7742 (2.25 GHz) | 128 (2x64) | 2048 GiB | 8x NVIDIA RTX8000 <br> with 48 GB memory | 14 TB SSD | 2x100 Gb/s |

**Note**: The CPUs in LUMI-D are one generation older (Zen 2 / "Rome") than in
LUMI-C and LUMI-G (Zen 3 / "Milan"). There should be no big problem with
software compatibility, though, as only a few new processor instructions related
to encryption and virtualization was added to the Zen 3 core. We expect that
almost all programs compiled for LUMI-C and LUMI-G (e.g. with `-march=znver3`)
will run on LUMI-D with good performance. Please see this page [FIXME] for more
information about Zen 2 vs. Zen 3 differences.

## GPUs

The interactive GPU nodes have 8 NVIDIA Quadro RTX8000 GPUs each with 4,608 GPU
cores, 576 Tensor cores, 72 RT cores and 48 GiB GDDR6 Memory. The current Nvidia
driver version is [FIXME]. The CUDA Toolkit for GPU development is also
installed so that it is possible to run and test CUDA code, but the main purpose
is visualization of these GPUs are visualizing, not GPU computing.

Links:

* [Nvidia Product Page][rtx-8000-product]
* [Nvidia Data Sheet][rtx-8000-specs]

## Storage

* The servers in LUMI-D have local SSDs with a total capacity of 25 TB for the
  CPU nodes and 14 TB for the GPU nodes [FIXME]. This storage is accessible on
  the path `/scratch/local` [FIXME]. It is a good idea to use the local disks
  when working with many small files (e.g. compiling), as that will be faster
  than using the parallel file system.
* The LUMI-D nodes are connected with 2x 100GbE Adapters to the Cray Slingshot 
  Network, which means that they can access to all the parallel file systems 
  (LUMI-P and LUMI-F) with good performance.
