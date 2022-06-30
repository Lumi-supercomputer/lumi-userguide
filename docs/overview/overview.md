

<style scoped>
.lumi-overview {
  display: flex; 
  flex-direction: row; 
  align-items: center;
}

.lumi-overview p {
  width: 50%;
}

.lumi-overview figure {
    width: 50%;
  }

@media (max-width: 740px) {
  .lumi-overview {
    flex-direction: column;
  }

  .lumi-overview p {
    width: 100%;
  }

  .lumi-overview figure {
    width: 100%;
  }
}
</style>

# LUMI Overview

[lumi-c]: ../computing/systems/lumic.md
[lumi-d]: ../computing/systems/lumid.md
[lumi-f]: ../storage/parallel/lumif.md
[lumi-p]: ../storage/parallel/lumip.md

<div class="lumi-overview">
  <p>
    LUMI is one of the three European pre-exascale supercomputers. It's an 
    HPE Cray EX supercomputer consisting of several partitions targeted for 
    different use cases. The largest partition of the system is the "LUMI-G" 
    partition consisting of GPU accelerated nodes using a future-generation AMD 
    Instinct GPUs. In addition to this, there is a smaller CPU-only partition, 
    "LUMI-C" that features AMD EPYC "Milan" CPUs and an auxiliary partition 
    for data analytics with large memory nodes and some GPUs for data 
    visualization. Besides partitions dedicated to computation, LUMI also offer 
    several storage partitions for a total of 117 PB of storage space.
  </p>
  <figure>
    <img 
      src="../../assets/images/lumi-snowflake.svg" 
      width="90%" 
      style="margin: 0 auto;"
      alt="LUMI from 3000 feets"
    >
  </figure>
</div>

## LUMI-C: The CPU Partition

The LUMI-C partition consists of 1536 compute nodes with an estimated combined
LINPACK performance of ca. 8 Petaflops. Each LUMI-C compute nodes are equipped 
with 2 AMD EPYC 7763 CPUs with 64 cores each running at 2.5 GHz for a total 
of 128 cores per node. The cores have support for 2-way simultaneous 
multithreading (SMT) allowing for up to 256 threads per node.

- [More information about LUMI-C][lumi-c]

## LUMI-D: The Data Analytics Partition

LUMI-D is intended for interactive data analytics and visualization. It is also
a good place run pre- and post-processing jobs that require a lot of memory. It
consists of a 8 nodes with large memory capacity (4 TB) and 8 nodes with NVIDIA
A40 GPUs. Each LUMI-D compute nodes are equipped with 2 AMD EPYC 7742 CPUs
with 64 cores each running at 2.25 GHz for a total of 128 cores per node.

- [More information about LUMI-D][lumi-d]

## LUMI-P and F: Parallel Filesystems

LUMI has two Lustre parallel file systems consisting of:

A main storage partition (LUMI-P) composed of 4 independent Lustre file systems
with an aggregated performance of 240 GB/s and a 20 PB storage capacity each

- [More information about LUMI-P][lumi-p]

A flash storage partition (LUMI-F) optimized to support high IOPS rates with 
an aggregated performance of 1740 GB/s and 7 PB of storage capacity

- [More information about LUMI-F][lumi-f]

## LUMI-O: The Object Storage

Object storage is a data storage architecture that manages data as objects 
instead of a file hierarchy. Each object includes the data, the metadata and a
globally unique identifier. This partition may be used for storing, sharing and
staging your data. It's based on Ceph and has a storage capacity of 30 PB.
