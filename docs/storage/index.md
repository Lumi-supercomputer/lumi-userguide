[lumif]: ./parallel-filesystems/lumif.md
[lumip]: ./parallel-filesystems/lumip.md
[lumio]: ./lumio/index.md
[lumi-g]: ../hardware/lumig.md
[billing]: ../runjobs/lumi_env/billing.md
[contwrapper]: ../software/installing/container-wrapper.md
[containers]: ../software/containers/singularity.md
[helpdesk]: ../helpdesk/index.md

[sionlib]: https://www.fz-juelich.de/ias/jsc/EN/Expertise/Support/Software/SIONlib/_node.html
[hdf5]: https://www.hdfgroup.org/solutions/hdf5/

# Overview

---

Here you find a description of available LUMI storage systems, what kind of
systems they are and on what hardware partitions they are located at.

---

On LUMI you have access to network file system storage based on the
[LUMI-P][lumip] and [LUMI-F][lumif] hardware partitions. At a later point,
object storage based on [LUMI-O][lumio] will also become available. The use of
storage is billed according to the
[billing policy](../runjobs/lumi_env/billing.md#storage-billing).

## Where to store data?

=== "User home"

    Each user has a home directory (`$HOME`) that can contain up to
    20 GB of data. It is intended to store user configuration files and personal
    data. The user home directory is purged once the user account expires.

=== "Project persistent"

    Persistent storage intended to share data amongst the members of a project.
    You can see this disk area as the project home directory. Typically, this
    space is used to share applications and libraries compiled for the project.
    The project persistent storage is located at
    `/project/project_<project-number>`. The project persistent directory is
    purged once the project expires.

=== "Project scratch"

    Temporary storage for input, output, or checkpoint data of your application.
    When running jobs on LUMI, this is the main storage you should use for your
    disk I/O needs.
    
    You are not supposed to use the scratch space as long-term storage. The 
    scratch file system is a temporary storage space. Files that have not been
    accessed will be **purged after 90 days**.

=== "Project flash"

    A high performance variant of project scratch. Use this when running jobs
    on LUMI that need very fast disk I/O operations. Note the difference in
    billing of the project scratch and project fast as detailed on the
    [billing page][billing].

    The project flash space is only meant for very short term file storage.
    Files that have not been accessed will be **purged after 30 days**.

## LUMI network file system disk storage areas

On LUMI there are several network based disk storage areas. An overview is
provided in the tables below. Please familiarize yourself with the
characteristics of the hardware partitions before using the different storage
areas.

|                            | Path                       | Intended use                                                     | Hardware partition used |
|----------------------------|----------------------------|------------------------------------------------------------------|-------------------------|
| **User<br> home**          | `/users/<username>`        | User home directory for<br> personal and configuration files     | [LUMI-P][lumip]         |
| **Project<br> persistent** | `/project/<project>`       | Project home directory for<br> shared project files              | [LUMI-P][lumip]         |
| **Project<br> scratch**    | `/scratch/<project>`       | Temporary storage for<br> input, output or checkpoint data       | [LUMI-P][lumip]         |
| **Project<br> flash**      | `/flash/<project>`         | High performance temporary<br> storage for input and output data | [LUMI-F][lumif]         |


|                           | Quota | Max files | Expandable            | Backup | Retention        |
|---------------------------|-------|-----------|-----------------------|--------|------------------|
| **User<br>home**          | 20 GB | 100k      | No                    | No     | User lifetime    |
| **Project<br>persistent** | 50 GB | 100k      | Yes,<br> up to 500GB  | No     | Project lifetime |
| **Project<br>scratch**    | 50 TB | 2000k     | Yes,<br> up to 500TB  | No     | 90 days          |
| **Project<br>fast**       |  2 TB | 1000k     | Yes,<br> up to 100TB  | No     | 30 days          |

|                    | Quota | Max<br>buckets | Max<br>objects<br>per bucket     | Backup | Retention           |
|--------------------|-------|----------------|----------------------------------|--------|---------------------|
| **Object storage** | 10 TB | 1000           | 500 000                          | No     | project lifetime    |

Note that, except for the user home directory, data storage is allocated per
project. When a storage space is marked as expandable, it means that you can
request more space if needed. Please contact the [User Support Team][helpdesk]
to request more storage space.

!!! warning "Data retention policies are not active"

    Automatic cleaning of project scratch and fast storage is not active at the
    moment. Please remove the files that are no longer needed by your project
    on a regular basis.

!!! failure "Don't circumvent the retention policy"

    Deliberately modifying file access times to bypass the retention policy is
    prohibited. It's an anti-social behavior that may impact other users negatively.

### About the number of files quota

For reasons related to performance, we are particularly attentive to the number
of files present on the parallel file system. A lot of small files negatively
impact all users by stressing the file system metadata servers. Therefore, any
requests to increase the number of files quota will be evaluated carefully by the
User Support Team and must be fully justified to be granted.

Examples of requests that will be *rejected* include:

- You are installing a lot of small files, e.g. using Conda. Please use a
  [container][containers] or the [container wrapper][contwrapper] tool instead.
- The compilation of your application is generating too many files for your home
  or project directory: you should compile your application from the scratch and
  then install it in your home or project directory. Exceptions can be made if
  you are developing an application on LUMI and you want to keep the source and
  object files in the long term.

In general, applications that generate a lot of small files per process are
not well suited for LUMI. If you are the developer of such application, you
should consider tools like [HDF5][hdf5] or [SIONlib][sionlib].

You can check the memory and file usage quotas of your projects with the
following command:

```bash
$ lumi-workspaces
```

## Temporary storage on compute nodes

The `/tmp` directory on the compute nodes resides in memory. The memory used
for `/tmp` is included in the job memory allocation. If you use `/tmp`, you
must allocate memory for it in order to avoid running out of memory.

Data storage on LUMI is provided by the [LUMI-P][lumip] parallel file system
hardware partition, the [LUMI-F][lumif] flash based parallel file system
hardware partition, and the [LUMI-O][lumio] object storage hardware partition
for a total of 117 PB of storage space.
