
[lustre]: parallel/lustre.md
[lumif]: parallel/lumif.md 
[lumip]: parallel/lumip.md
[contwrapper]: ../software/containers/wrapper.md

[sionlib]: https://www.fz-juelich.de/ias/jsc/EN/Expertise/Support/Software/SIONlib/_node.html
[hdf5]: https://www.hdfgroup.org/solutions/hdf5/

<!-- Where to store data -->

## LUMI disk areas

On LUMI, there are several disk areas: home, projects, scratch (LUMI-P) and fast 
flash-backed scratch (LUMI-F). Please familiarize yourself with the areas and 
their specific purposes.

|              | Path                       | Description                                                                            |
|--------------|----------------------------|----------------------------------------------------------------------------------------|
| **Home**     | `/users/<username>`        | for user personal and configuration files                                              | 
| **Project**: | `/project/<project_name>`  | act as the project home directory                                                      |
| **Scratch**  | `/scratch/<project_name>`  | intended as temporary storage for input, output or checkpoint data of your application |
| **Flash**    | `/flash/<project_name>`    | fast scratch space based on flash storage                                              |

## Where to store data?

From the table below you can get an overview of the available options for storage. Note
that, except for the user home directory, data storage is allocated per project.

|                       | Quota | Max files | Expandable   | Backup | Retention        |
|:---------------------:|-------|-----------|:------------:|--------|------------------|
| User<br>Home          | 20 GB | 100k      | No           | Yes    | User lifetime    |
| Project<br>Persistent | 50 GB | 100k      | Yes<br>500GB | No     | Project lifetime |
| Project<br>Scratch    | 50 TB | 2000k     | Yes<br>500TB | No     | 90 days          |
| Project<br>Fast       |  2 TB | 1000k     | Yes<br>100TB | No     | 30 days          |

When a storage space is marked as expandable, it means that you can request 
more space if needed.

=== "User home"

    Each user has a home directory (`$HOME`) that can contain up to
    20 GB of data. It is intended to store user configuration files and personal
    data.  The user home directory is purged once the user account expire.

=== "Project persistent storage"

    Is intended to share data amongst the members of a project. You can see this
    workspace as the project home directory. Typically, this space can be used 
    to share applications and libraries compiled for the project. The project
    persistent storage is located at `/project/project_<project-number>`. The
    project persistent directory is purged once the project expire.

=== "Project scratch" 

    Lustre file systems intended as temporary storage for input, output or
    checkpoint data of your application. LUMI offers 2 types of scratch storage
    solution: LUMI-P with spinning disks and LUMI-F based on flash storage.

- [Learn more about Lustre][lustre]
- [Learn more about the Project Scratch storage][lumip]
- [Learn more about the Project Fast storage][lumif]

!!! failure "LUMI-F unavailable until summer 2022"

    To prepare for the installation of LUMI-G, LUMI-F has been removed from the
    system and will be available again after LUMI-G installation is completed.

!!! failure "Data rentention policies not active"

    Scratch automatic cleaning is not active at the moment. Please remove the 
    files that are no longer needed by your project on a regular basis if you 
    don't want to run out of TB-hours.

## Using compute nodes `/tmp`
                                                                         
The `/tmp` directory on the compute nodes resides in memory and is included in
the job memory request. This means that your job can run of memory if you write
to much data to `/tmp`   

<!-- ## Billing

Storage is billed by volume as well as time. The billing units are TB-hours. For
the regular scratch file system, 1TB that stays for 1 hour on the filesystem, 
consumes 1TB-hour. For the flash based filesytem 1TB for 1 hour consumes 
10 TB-hours. -->

## About the number of files quota

For reasons related to performance, we are particularly attentive to the number
of files present on the parallel filesystem. A lot of small files negatively
impact all users by stressing the filesystem metadata servers. Therefore, any 
requests to increase the number of files will be evaluated carefully by the 
Support Team and must be fully justified.

Requests that will be **rejected** include:

- You are using Conda: you should use the [container wrapper][contwrapper]
  tool.
- The compilation of your application is generating too many files for your home
  or project directory: you should compile your application from the scratch and
  then install it in your home or project directory. Exception can be made if
  you are developing an application on LUMI and you want to keep the source and
  object files in the long term.

In general, applications that generate a lot of small files per processes are 
not well suited for LUMI. If you are the developer of such application, you 
should consider tools like [HDF5][hdf5] or [SIONlib][sionlib].

You can check the memory and file usage quotas of your projects with the following commands:

```
module load lumi-workspaces

lumi-workspaces
```


## Object Storage

Not available yet

|                 | Quota | Max buckets | Objects/bucket | Backup | Retention                      |
|-----------------|-------|-------------|----------------|--------|--------------------------------|
| Object Storage  | 10 TB | 1000        | 500K           | No     | Project lifetime<br> + xx days |