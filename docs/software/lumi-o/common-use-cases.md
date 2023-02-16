# Common use cases

## Processing data in LUMI

LUMI supercomputer provides disk environments for working with large datasets e.g. _flash_, _scratch_. These storage areas are however not intended for storing data that is not actively used. For example in the _scratch_ area of LUMI the un-used files are automatically removed after 180 days.

One of the main use cases of LUMI-O is to store data while it is not actively used in the LUMI supercomputer. When you start working, you stage in the data from LUMI-O. And when the data is no longer actively used, it can be staged out to LUMI-O.

In LUMI, connection to LUMI-O can be established with the guide from [Accessing LUMI-O](./accessing-lumi-o.md):
```text
source /project/project_462000008/lumi-o/lumi-o_setup.sh
```
Make sure you point the source command at the proper destination.

After that you can:

**List the data buckets and objects in LUMI-O:** For listing we recommend lo-list:
```text
lo-list
```
The command above lists available data buckets in LUMI-O. To list data objects in a bucket give command:
```text
lo-list bucket_name
```

**Copy data from LUMI-O to a supercomputer (stage in):** For downloading we recommend lo-get:
```text
lo-get bucket/object_name
```

**Copy data from a Supercomputer to LUMI-O (stage out):** For uploading we recommend lo-put:
```text
lo-put filename
```

## Sharing data

Sharing data, e.g. datasets or research results, is easy in the object storage. You can share these either with a limited audience, e.g. other projects, or allow access for everybody by making the data public.

The data can be accessed and shared in a variety of ways:

* **Private – default:** By default, if you do not specify anything else, the contents of buckets can only be accessed by authenticated members of your project.

* **Access control lists:** Access control lists (ACLs) work on buckets, not objects. With ACLs, you can share your data in a limited manner to other projects. You can e.g. grant a collaboration project authenticated read access to your datasets.

 * **Public:** You can also have ACLs granting public read access to data, which is useful e.g. for permanently sharing public scientific results or public datasets.

## Static web content

A common way to use the object storage is storing static web content, such as images, videos, audio, pdfs or other downloadable content, and adding links to it on a web page, which can run either inside LUMI or somewhere else, [like this example](https://462000002.lumidata.eu/public_example_bucket/lumi_logo.png).

Uploading data to LUMI-O can be done with any of the following clients: lo-commands, rclone or other S3-API aware s3-client tools.
## Storing data for distributed use

There are several cases where you need to access data in several locations. In these cases, the practice of staging in the data to individual servers or computers from the object storage can be used instead of a shared file storage.

## Accessing the same data via multiple CSC platforms

Since the data in the object storage is available anywhere, you can access the data via both the LUMI partitions and upcoming cloud services. This makes the object storage a good place to store data as well as intermediate and final results in cases where the workflow requires the use of e.g. both LUMI-C and LUMI-O.

## Collecting data from different sources

It is easy to push data to the object storage from several different sources. This data can then later be processed as needed.

For example, several data collectors may push data to be processed, e.g. scientific instruments, meters, or software that harvests social media streams for scientific analysis. They can push their data into the object storage, and later virtual machines and computing jobs on Puhti can process the data.

## Self-service backups of data

The object storage is also often used as a location for storing backups. It is a convenient place to push copies of database dumps.

## Files larger than 5 GB

Files larger than 5 GB are divided into smaller segments during upload.

* *lo-put* and *rclone*  split large files automatically: lo-put

## Viewing

In LUMI you can check the number of objects and the amount of stored data in your current project with the following command:
```text
lo-info
```

Please contact [LUMI User Support Team](https://lumi-supercomputer.eu/user-support/need-help/generic/) if you have questions.
