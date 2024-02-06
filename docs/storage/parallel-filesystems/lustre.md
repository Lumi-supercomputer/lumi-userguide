# Lustre

Lustre is a parallel distributed high-performance file system for clusters
ranging from small to large-scale as well as multi-site systems. The role of
Lustre is to chunk up files into data blocks and spread file data across
multiple storage servers, which can be written to and read from in parallel.

## Lustre Building Blocks

A Lustre file system is composed of three major functional units as shown in
the simplified diagram below.

<figure>
  <img 
    src="../../../assets/images/lustre-overview.svg"
    width="600px"
    alt="Overview of the building blocks of a Lustre file system"
  >
  <figcaption>Overview of the building blocks of a Lustre file system</figcaption>
</figure>

- One or more **metadata servers (MDS)** that has one or more **metadata
  targets (MDT)** per Lustre file system that stores namespace metadata, such
  as filenames, directories, access permissions, and file layout
- One or more **object storage servers (OSS)** that store file data on one or
  more **object storage targets (OST)**
- **Clients** are compute-, visualization- or login nodes that access and use
  the data

## File Striping

One of the main factors leading to the high performance of Lustre file systems
is the ability to stripe data across multiple storage targets (OSTs). This
means that files are split into chunks which are then distributed among the
OSTs. Read and write operations on striped files will access multiple OSTs
concurrently. As a result, I/O performance is improved since writing or reading
from multiple OSTs simultaneously increases the available I/O bandwidth.

<figure>
  <img 
    src="../../../assets/images/lustre-striping.svg" 
    width="600px"
    alt="Sriping of a 8MB file over 4 OSTs"
  >
  <figcaption>
    striping of an 8 MB file over 4 OSTs (stripe count = 4). Each stripe is 1 MB
    (stripe size = 1m) in size. Each OST store 2 stripes.
  </figcaption>
</figure>

File striping will predominantly improve performance for applications doing
serial I/O from a single node or parallel I/O to a single shared file from
multiple nodes. This behavior is usually found in application using MPI-I/O,
parallel HDF5 and parallel NetCDF.

### Set the Striping Pattern

The striping for a file or directory can be set using the command `lfs
setstripe`.

```bash
$ lfs setstripe --stripe-count <count> --stripe-size <size> <dir|file>
```

where `<count>` sets the number of stripes, i.e. the number of OSTs and
`<size>` the size of the stripes. The argument of the `lfs setstripe` command
is a path to a directory or a file:

- if a directory is used, it sets the default layout for new files created in
  the directory. This default layout can then be changed for individual
  files inside the directory by creating them with the `lfs setstripe` command.
- if a file is used, a new file with the specified layout will be created.

Maximal striping can be achieved by setting the stripe count to `-1`.

### Get the Striping Pattern

Information about the striping of a directory or a file can be retrieved using
the `lfs getstripe` command.

```bash
$ lfs setstripe --stripe-count=4 --stripe-size=2m /scratch/user/test
$ touch /scratch/user/test/file.txt
$ lfs getstripe /scratch/user/test/
/scratch/user/test/
stripe_count:  4 stripe_size:   2097152 pattern: raid0 stripe_offset: -1

$ lfs getstripe /scratch/e1000/olouant/test/file.txt
/scratch/user/test/file.txt
lmm_stripe_count:  4
lmm_stripe_size:   2097152
lmm_pattern:       raid0
lmm_layout_gen:    0
lmm_stripe_offset: 14
        obdidx           objid           objid           group
            14        46050141      0x2beab5d                0
             1        45873824      0x2bbfaa0                0
             3        45885822      0x2bc297e                0
             5        46052767      0x2beb59f                0
```

In the example above, we see that `file.txt` inherited the layout of its parent
directory and that the file is striped on 4 OSTs (14, 1, 3 and 5).

## Performance Considerations

Striping should be adapted to your application I/O pattern and the size of your
files. The following section describes general considerations.

### Stripe count

In theory, a larger number of stripes increases the I/O bandwidth and thus
performance. In particular, applications which write to a single file from
hundreds of nodes, may benefit from striping over as many OSTs. Moreover,
striping is needed if you write a huge amount of data as a single OST may not
have enough free space to store all the data. For applications creating a large
number of small files as with a file per process scheme, large stripe counts
can cause overhead and impede the performance.

- when multiple processes access the same large file in parallel set a stripe
  count >1 and an integral factor of the number of processes.
- with a file-per-process I/O pattern, avoid striping (stripe count of 1) to
  limit OST contention.

### Stripe size

Stripe size has less of an impact on performance than the stripe count and no
impact at all if the stripe count is 1. However, when dealing with large files,
the stripe size may influence the performance:

- the smallest recommended stripe size is 512 KB.
- a good stripe size is between 1 MB and 4 MB in most situations.
- the maximum stripe size is 4 GB, but you should only use this value for huge files.

If your application writes to the file in a consistent and aligned way, make
the stripe size a multiple of the `write()` size. The goal is to perform write
operations that go entirely to one server instead of crossing object
boundaries.
