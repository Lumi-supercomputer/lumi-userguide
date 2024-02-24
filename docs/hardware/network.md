---
hide:
  - toc
---

[slingshot-11-hpe-page]: https://www.hpe.com/emea_europe/en/compute/hpc/slingshot-interconnect.html

All LUMI compute nodes use the [HPE Cray Slingshot-11][slingshot-11-hpe-page]
200 Gbps network interconnect (NIC). The LUMI-C nodes (CPU) are equipped with a
single endpoint while the LUMI-G nodes (GPU nodes) have 4 endpoints - one for
each AMD MI250x GPU modules. Each endpoint provides up to 50 GB/s of
bidirectional bandwidth. The HPE Cray Slingshot NIC features high-performance
RDMA and hardware acceleration for MPI and SHMEM based software.

## Topology

LUMI uses the dragonfly network topology. In this topology, a group of endpoints, 
for example the compute nodes, are connected to a switch. Multiple switches 
connected in an all-to-all fashion to create a group. This group is sometimes 
referred to as an electrical group as these switches can be connected by short 
copper cables. The electrical groups are then connected to each other in an
all-to-all fashion. Optical cables are used for group-to-group communication
as distances are much larger. The figure below presents a graphical representation
of a dragonfly topology.

<figure>
  <img 
    src="../../assets/images/dragonfly-overview.svg" 
    width="750"
    alt="Example dragonfly topology"
  >
  <figcaption>Example dragonfly topology.</figcaption>
</figure>

In summary, the LUMI network dragonfly can be summarized as these three ranks:

- **Rank 1:** multiple compute nodes connected to a switch
- **Rank 2:** multiple switches all-to-all connected with copper cables forming
  an electrical group
- **Rank 3:** multiple electrical groups all-to-all connected with optical cables

The dragonfly topology allows for communication to be performed in a maximum of 
3 switch hops: one hop inside the source group, one hop between the group and one 
hop inside the destination group.

<figure>
  <img 
    src="../../assets/images/network-hops.svg" 
    width="700"
    alt="Communication switch hops"
  >
  <figcaption>Switch hops from source to destination</figcaption>
</figure>

## Inter- and intra-partition bandwidth

The table below provides an overview of the total available bandwidth for inter-
and intra-partition communication.

|        | LUMI-G   | LUMI-C    | LUMI-M   | LUMI-F   | LUMI-P   |
|--------|----------|-----------|----------|----------|----------|
| LUMI-G | 276 TB/s | 38.4 TB/s | 2.4 TB/s | 7.2 TB/s | 9.6 TB/s |
| LUMI-C |          | 22.4 TB/s | 0.8 TB/s | 3.2 TB/s | 3.2 TB/s |
| LUMI-M |          |           |          | 0.1 TB/s | 0.4 TB/s |
| LUMI-F |          |           |          |          | 0.4 TB/s |

The different partitions presented in the table correspond to

  - **LUMI-G:** the AMD MI250x GPU nodes
  - **LUMI-C:** the CPU nodes
  - **LUMI-M:** the login nodes, LUMI-D, the largemem nodes and the management racks
  - **LUMI-P:** the four Lustre filesystems using mechanical disk
  - **LUMI-F:** the Lustre filesystem using Flash-based storage

## LUMI-C

LUMI-C, the CPU partition, has 8 electrical groups of 256 nodes. The groups 
are composed of 16 switches connected in all-to-all. There are 16 nodes connected
to each of the switches.

<figure>
  <img 
    src="../../assets/images/lumic-network-overview.svg" 
    width="600"
    alt="LUMI-C network overview"
  >
  <figcaption>LUMI-C network overview</figcaption>
</figure>


## LUMI-G

LUMI-G, the GPU partition, has 24 electrical groups of 124 nodes, except the last group which contains 126 nodes.
The groups are composed of 32 switches connected in all-to-all.
There are 16 endpoints connected to each of the switches.
The LUMI-G compute nodes have 4 endpoints per nodes, each endpoint connected to different switches.

<figure>
  <img 
    src="../../assets/images/lumig-network-overview.svg" 
    width="800"
    alt="LUMI-G network overview"
  >
  <figcaption>LUMI-G network overview</figcaption>
</figure>


