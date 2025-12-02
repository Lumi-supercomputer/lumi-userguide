# LUMI-O

[auth.lumidata.eu]: https://auth.lumidata.eu
[lumi-o-tools]: https://github.com/Lumi-supercomputer/LUMI-O-tools
[rclone-manual]: https://rclone.org/docs/


## What is LUMI-O?

LUMI-O is object storage service accessible through a web interface and S3 API. 
LUMI-O is based on completely different technology than the Lustre parallel filesystem (LUMI-P and LUMI-F). Also, unlike the Lustre parallel file system, LUMI-O is a separate service from LUMI compute partitions. 

LUMI-O offers a total of 30 PB storage space for storing, sharing, and staging of data. By default 150 TB of storage space is allocated per LUMI project, but projects can request for more LUMI-O storage space by contacting the [LUMI helpdesk](../../helpdesk/index.md).


!!! Info "Some features of LUMI-O"

    - A separate service from the rest of LUMI, with a fast connection for data transfer between LUMI filesystem and LUMI-O
    - Accessible also without connecting to LUMI
    - Service breaks of LUMI don't usually affect to availability of LUMI-O
    - Usage with client tools like rclone and s3cmd, or via LUMI web interface
    - Possible to set granular access rights to data (e.g. for other projects or users from other projects) 
    - Possible to set a temporary access link to otherwise private data
    - Possible to share public data across the internet (for the duration of your project)
    - In LUMI-O one project is treated as one account: all project members have the same access/user rights to the projects data
    - Data lifetime in LUMI-O is the same as your project lifetime 



## Usage of LUMI-O

All LUMI projects have LUMI-O available by default.

To access LUMI-O, you will need to [generate access tokens](./auth-lumidata-eu.md). These tokens are personal and exclusive for a project. There are no other credentials allowing access to LUMI-O buckets. 
You can use LUMI-O [via the LUMI web interface](../../compute/webui/index.md#accessing-lumi-o) (limited functionality), or with different [client tools](./clients-general.md) like `rclone`. Read more how to create the credentials and configure the connection from the [Accessing LUMI-O](./auth-lumidata-eu.md) page.

For examples how to use LUMI-O, see the 'Use case examples' section and [training material](#training-material).


## Structure of object storage

Structure of an object storage is different from a normal file system structure. Instead of directories and files, the data is organized in a flat structure with *buckets* that contain *objects*. 

- **Buckets**: Containers used to store one or more objects. Buckets can not contain other buckets, so the structure is much flatter than a normal filesystem structure. One bucket can contain up to 500k objects. 
- **Objects**: Any type of data. An object is stored in a bucket.
- **Metadata**: Both buckets and objects have metadata specific to them. The 
  metadata of a bucket specifies e.g., the access rights to the bucket. While
  traditional file systems have fixed metadata (filename, creation date, type,
  etc.), an object storage allows you to add custom metadata.



Objects are managed through simple atomic operations. One can put an object in the object storage, get its content, copy an object or delete an object. But contrary to a file e.g. in the Lustre filesystem, the object in LUMI-O cannot be modified: One cannot simply change a part of the content of an object. To edit an object, it needs to be replaced with a new object.

With LUMI-O, one LUMI project is considered as _one user account_, i.e. by default all project members have the same user rights to all the data that is stored in LUMI-O for the project.

!!!info
    Projects in LUMI-O are handled as "single user tenants/accounts", where the project numerical id (e.g. 465000001) corresponds both the tenant/account name and the project name.
    Subsequently, **all members of a LUMI-O project have the exact same rights and permissions**, unlike in the LUMI filesystem, where files have individual owners.**Keep this in mind if you have critical data in LUMI-O as any other member of your LUMI project could accidentally delete it**.

## Training material

A good introductory lecture and exercises about using LUMI-O object storage are included in the trainings that LUMI user support team gives on a regular basis. See the material for [the latest introductory training](https://lumi-supercomputer.github.io/intro-latest) and other trainings from [LUMI training materials](https://lumi-supercomputer.github.io/LUMI-training-materials/).


## LUMI-O vs Amazon S3

LUMI-O is an S3 compatible storage solution. However, this does not mean
that the system is the same as the "Amazon S3 Cloud Storage". The interface for reading and writing data 
is exactly the same, but AWS has a bunch of additional features which are not really part of "just" s3 storage, like _self-service provisioning of IAM users_,
_life cycle configuration_ and _write once, read many functionality_. 

It's worth keeping the above in mind, as many people use S3 and Amazon S3 interchangeably
when writing guides or instructions.  

!!! warning 
	Some advanced  operations which are supported by AWS will complete successfully when run against
	LUMI-O, e.g object locks, but will actually have no effect. Unless it is explicitly stated that a feature
	is provided by LUMI-O, assume that it will not work and be extra thorough in verifying correct functionality. 



