[data-storage-options]: ../index.md

# Main storage - LUMI-P

The LUMI-P hardware partition provides 4 independent [Lustre](lustre.md) file
systems. Each of these provides a storage capacity of 20 PB with an aggregate
bandwidth of 240 GB/s. Each Lustre file system is composed of 1 MDS (metadata
server) and 32 Object Storage Targets (OSTs). Hard disk drives (spinning disks)
are used in LUMI-P.

Before using LUMI-P, users should familiarize themselves with the performance
characteristics of the Lustre file system and adjust their data
workflows accordingly. In particular, having a large number of small files may
put stress on the metadata servers and may limit the performance due to limited
striping as explained in the Lustre section below.

For an overview of options for using LUMI-P, see the [data storage
options][data-storage-options] page.
