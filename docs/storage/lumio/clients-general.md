# Transferring and managing data

<!-- This page could be also called 'Overview of data transfer tools' in the table of contents. With the current name it hints that there is also other information related to good practices when transferring data, which would be nice, I think. But it could also be only about the client software / tools.
 -->

LUMI-O is used via tools (client software) that take care of moving data to and from LUMI-O and managing data objects. There are several different kinds of client software for accessing the object storage servers. LUMI-O can be used with any object storage client that is compatible with S3 protocol.


## Supported tools (client software)

The `lumio` module provides some pre-installed tools to interact with LUMI-O:
[`rclone`](./client-rclone.md), [`s3cmd`](./client-s3cmd.md) and [`restic`](./client-restic.md). After loading the `lumio` module on LUMI, you can use rclone, s3cmd and restic to work with LUMI-O. 

Please refer to the manuals of rclone, s3cmd and restic for more detailed information.

The most common commands for `s3cmd` and `rclone` to work with LUMI-O are listed below.

=== "Rclone"
    
    | Action                                     | Command                                              |
    |--------------------------------------------|------------------------------------------------------|
    | List buckets                               | `rclone lsd lumi-46YXXXXXX-private:`                 |
    | Create bucket *mybuck*                     | `rclone mkdir lumi-46YXXXXXX-private:mybuck`         |
    | List objects in bucket *mybuck*            | `rclone ls lumi-46YXXXXXX-private:mybuck/`           |
    | Upload file *file1* to bucket *mybuck*     | `rclone copy file1 lumi-46YXXXXXX-private:mybuck/`   |
    | Download file *file1* from bucket *mybuck* | `rclone copy lumi-46YXXXXXX-private:mybuck/file1 .`  |

    _Replace 46YXXXXXX with your LUMI project number._
    _For public buckets, replace the word 'private' with 'public'_

=== "s3cmd"

    | Action                                     | Command                             |
    |--------------------------------------------|-------------------------------------|
    | List buckets                               | `s3cmd ls s3:`                      |
    | Create bucket *mybuck*                     | `s3cmd mb s3://mybuck`              |
    | List objects in bucket *mybuck*            | `s3cmd ls --recursive  s3://mybuck` |
    | Upload file *file1* to bucket *mybuck*     | `s3cmd put file1 s3://mybuck`       |
    | Download file *file1* from bucket *mybuck* | `s3cmd get s3://mybuck/file1 .`     |


<!--

Would be great to add similar table here, but need to confirm if the same is true in all parts with rclone and s3cmd + restic? with LUMI-O
https://docs.csc.fi/data/Allas/introduction/#client-operations

-->


<!--

## File formats 

(here or in index.md / LUMI-O Overview ?)

Check LUMI-O notes by Kurt 

!!!info
    In an object storage 'files' are called objects. But since object is not same thing as a file, 'file format' is not exactly a correct term when talking about objects in an object storage.

Since object storage is a different kind of storage system than the Lustre file system on LUMI, some file formats behave naturally well with object storage, e.g. ... 



The ... file format 

-->

<!--

To be added here, or in 'Use case examples' : Some info / examples of performing downloads/uploads of large datasets


## Large number of small files

-->

## Large amount of data

If you need to transfer a file to LUMI-O that has a size more than larger than 5 GB, the data transfer will be automatically split to a multipart upload. When doing a multipart upload, the parts are first moved to your bucket in LUMI-O as separate objects, and when the download of all the parts is finished, the parts are combined to one single object. 

If the download is interrupted for one reason or another, the unfinished parts of your multipart upload are left in your bucket. 

Most of the tools (e.g. rclone) are able to identify the existing parts and continue where the download was interrupted. In some cases it might happen though, that the client tool is not able to continue the multipart upload. Notice that if the multipart upload is not finished, the parts of the unfinished multipart upload stay in your bucket to fill the quota of that specific bucket, unless you separately delete them. 
<!-- Check when LUMI-O available again
There are commands to clean up the objects that result from unfinished multipart upload (e.g. `rclone cleanup` for [`rclone`](https://rclone.org/commands/), but please refer to the manual pages for the specific client software for more information).

-->








