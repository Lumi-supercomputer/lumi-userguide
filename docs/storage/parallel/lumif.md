[lumi-p]: lumip.md
[lumi-g]: ../../computing/systems/lumig.md
[data-storage-options]: ../../storage/storing-data.md

# Flash storage - LUMI-F

!!! warning "Project fast storage currently not available"

    To prepare for the installation of [LUMI-G][lumi-g], LUMI-F has been taken
    offline. It will become available again once the [LUMI-G][lumi-g]
    installation is completed.

The LUMI-F hardware partition provides a Lustre file system with a storage
capacity of 7 PB and an aggregate bandwidth of 1 740 GB/s. It is composed of 2
MDSs (metadata servers) and 58 Object Storage Targets (OSTs). Solid state
drives (SSDs) are used in LUMI-F.

Before using LUMI-F, users should familiarize themselves with the performance
characteristics of the [Lustre](lumip.md#lustre) file system and adjust their
data workflows accordingly.

For an overview of options for using LUMI-F, see the [data storage
options][data-storage-options] page.
