# LUMI-O

[auth.lumidata.eu]: https://auth.lumidata.eu
[lumi-o-tools]: https://github.com/Lumi-supercomputer/LUMI-O-tools
[rclone-manual]: https://rclone.org/docs/


## What is LUMI-O?

LUMI-O is a S3 compatible object storage based on Ceph Reef (v18.2.2). It is a completely separate instance from the LUMI filesystem (LUMI-P and LUMI-F). LUMI-O offers a total of 30 PB storage space for storing, sharing, and staging of data. By default 150 TB of storage space is allocated per LUMI project, but projects can request for more LUMI-O storage space by contacting the [LUMI helpdesk](../../helpdesk/index.md).

!!! Info "Some features of LUMI-O"

    - Separate service from the LUMI filesystem, with a fast connection for data transfer between LUMI filesystem and LUMI-O
    - Accessible also without connecting to LUMI
    - Service breaks of LUMI don't usually affect to availability of LUMI-O
    - Usage with client tools like rclone and s3cmd, or via LUMI web interface
    - Possible to set granular access rights to data (e.g. for other projects or users of other projects) 
    - Possible to set a temporary access link to otherwise private data
    - Possible to share pubic data across the internet (for the duration of your project)
    - Data lifetime in LUMI-O is the same as your project lifetime 


## Usage of LUMI-O

To access LUMI-O, you will need to [generate authentication credentials](./auth-lumidata-eu.md). 
You can use LUMI-O [via the LUMI web interface](../../runjobs/webui/index.md#accessing-lumi-o) (limited functionality), or with different [client tools](./clients-general.md) like `rclone`. Read more about how to create the credentials and configure the connection from the [Accessing LUMI-O](./auth-lumidata-eu.md) page.

For examples how to use LUMI-O, see the 'Use case examples' section and [teaching material](#teaching-material).


## Structure of object storage

Structure of an object storage differs a bit from a normal file system structure. In an object-based storage, data is managed as 'objects', instead of being organized as files in a directory hierarchy.

Within your object storage project space, you can create buckets. These buckets
will store objects with metadata associated with these objects.

- **Buckets**: Containers used to store one or more objects.
  Object storage uses a flat structure with only
  one level which means that buckets cannot contain other buckets.
- **Objects**: Any type of data. An object is stored in a bucket.
- **Metadata**: Both buckets and objects have metadata specific to them. The 
  metadata of a bucket specifies e.g., the access rights to the bucket. While
  traditional file systems have fixed metadata (filename, creation date, type,
  etc.), an object storage allows you to add custom metadata.

Objects are managed through simple atomic operations. One can put an object in the object storage, get its content, copy an object or delete an object. But contrary to a file in Lustre, the object cannot be modified: One cannot simply change a part of the content, but the object needs to be replaced with a new object.

In LUMI-O, one LUMI project is considered as one user account, i.e. by default all project members have the same access rights to the data stored in LUMI-O by the project.


## Teaching material

An introduction lecture and exercises about LUMI-O are included in the 'LUMI introduction' trainings that LUMI user support team gives. See the latest training from [LUMI training materials](https://lumi-supercomputer.github.io/LUMI-training-materials/).


## LUMI-O vs Amazon S3

LUMI-O is an S3 compatible storage solution. However, this does not mean
that the system is the same as the "Amazon S3 Cloud Storage". The interface for reading and writing data 
is exactly the same, but AWS has a bunch of additional features, like _self-service provisioning of IAM users_,
_life cycle configuration_ and _write once, read many functionality_, which are not really part of "just" s3 storage. 

It's worth keeping the above in mind, as many people use S3 and Amazon S3 interchangeably
when writing guides or instructions.  

!!! warning 
	Some advanced  operations which are supported by AWS will complete successfully when run against
	LUMI-O, e.g object locks, but will actually have no effect. Unless it is explicitly stated that a feature
	is provided by LUMI-O, assume that it will not work and be extra thorough in verifying correct functionality. 



<!-- This is not a comprehensive tutorial, but more of
a list of examples of things that are possible when using LUMI-O.
Please consult the manual pages of the tools for additional details. -->



