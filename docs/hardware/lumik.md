# Cloud - LUMI-K

The LUMI-K hardware partitiion consists of 34 compute nodes (3 control-plane nodes, 3 infra nodes, 28 worker nodes) and 7 storage nodes.
The node specification is shown below:

| Role    | Nodes | CPUs                                | vCPU cores     | Memory   | Network     | Disk.        |
| :--:    | :---: | :---------------------------------: | :-----------:  | :------: | :---------: | :---------:  |
| Compute | 34    | AMD EPYC 7742<br>(2.25 GHz base)    | 128            | 512 GiB  | 25 Gb/s     | 1.6 TB x 5   |  
| Storage | 7     | AMD EPYC 7742<br>(2.25 GHz base)    | 128            | 128 GiB  | 25 Gb/s     | 3.84 TB x 12 |

# Compute
The main compute capacity for the applications running on the LUMI-K comes from the worker nodes. Each worker node is
equipped with a single AMD EPYC 7742 64 cores CPU. Each core has a base clock of 2.25 GHz and 2 threads per core
which makes it 128 virtual CPU cores per worker node for the kuberentes cluster. Moreover each node is equipped with
16 x 32 GB DDR4 3200 MHz Dual Rank memory and 5 x 1.6 TB SSD disks.

# Storage
The storage nodes have a similar hardware configuration except total amount of memory and SSD disks. Each storage node
has 8 x 16 GB DDR4 3200 MHz Dual Rank memory and 12 x 3.84 TB SSD disks. Application pods are not scheduled on the storage
nodes since these nodes are dedicated for the Kubernetes cluster's storage backend.
