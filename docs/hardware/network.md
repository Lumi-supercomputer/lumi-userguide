---
hide:
  - toc
---

All LUMI compute nodes uses HPE Cray Slingshot-11 200 Gbps network interconnect
(NIC). The LUMI-C (CPU nodes) are equipped with a single endpoints while the
LUMI-G nodes (GPU nodes) have 4 endpoints - one for each AMD MI250x GPU modules.
Each endpoints provide up to 50 GB/s of bidirectional bandwidth. The HPE Cray
Slingshot NIC features high performance RDMA and hardware acceleration for MPI
and SHMEM based software.

## Topology

LUMI use the dragonfly network topology. In this topology, a group of endpoints, 
for example the compute nodes are connected to a switch. Multiple switches 
connected in an all-to-all fashion to create a group. This group is sometimes 
referred to as an electrical group as these switches can be connected by short 
copper cables. The electrical groups are then connected to each other in an
all-to-all fashion. Optical cables are used for group-to-group communication
as distances are much larger. The figure below present a graphical representation
of a dragonfly topology.

<figure>
  <img 
    src="../../../assets/images/dragonfly-overview.svg" 
    width="750"
    alt="Example dragonfly topology"
  >
  <figcaption>Example dragonfly topology.</figcaption>
</figure>

In summary the LUMI network dragonfly can be summarized as these three ranks:

- **Rank 1:** multiple compute nodes connected to a switch
- **Rank 2:** multiple switches all-to-all connected with copper cables forming
  an electrical group
- **Rank 3:** multiple electrical groups all-to-all connected with optical cables

The dragonfly topology allows for communication to be performed in a maximum of 
3 switch hops: one hop inside the source group, one hop between group and one 
hop inside the destination group.

<figure>
  <img 
    src="../../../assets/images/network-hops.svg" 
    width="700"
    alt="Communication switch hops"
  >
  <figcaption>Switch hops from source to destination</figcaption>
</figure>

## LUMI-C

LUMI-C, the CPU partition, has has 6 electrical groups of 256 nodes. The groups 
are composed of 16 switches connected in all-to-all. There is 16 nodes connected
to each of the switches.

<figure>
  <img 
    src="../../../assets/images/lumic-network-overview.svg" 
    width="600"
    alt="LUMI-C network overview"
  >
  <figcaption>LUMI-C network overview</figcaption>
</figure>


## LUMI-G

LUMI-C, the GPU partition, has has 20 electrical groups of 128 nodes. The groups 
are composed of 32 switches connected in all-to-all. There is 16 endpoints 
connected to each of the switches. The LUMI-G compute nodes have 4 enpoints 
per nodes, each endpoints connected to different swiches.

<figure>
  <img 
    src="../../../assets/images/lumig-network-overview.svg" 
    width="800"
    alt="LUMI-G network overview"
  >
  <figcaption>LUMI-G network overview</figcaption>
</figure>


