# Overview

[lumi-c]: ../hardware/lumic.md
[lumi-g]: ../hardware/lumig.md
[lumi-d]: ../hardware/lumid.md
[network]: ../hardware/network.md
[lumi-top500]: https://top500.org/system/180048/

---
Here you find a description of the LUMI system architecture and the different
hardware partitions available on LUMI.

---


LUMI is one of the three European pre-exascale supercomputers. It's an HPE Cray
EX supercomputer consisting of several hardware partitions targeted different
use cases. All the hardware partitions are connected via an HPE Slingshot 11
high-speed [interconnect][network]. As of 06/2024, LUMI ranks fifth on the
[top500.org list][lumi-top500] and is currently the fastest supercomputer in
Europe.

The primary compute power in LUMI is found in the [LUMI-G][lumi-g] hardware
partition which features GPU accelerated nodes using AMD Instinct MI250X GPUs.
In addition to this, there is a smaller [LUMI-C][lumi-c] CPU-only hardware
partition that features AMD EPYC "Milan" CPUs, as well as a small
[LUMI-D][lumi-d] data analytics hardware partition featuring large memory nodes
(4 TB) and some NVIDIA A40 GPUs for data visualization.



