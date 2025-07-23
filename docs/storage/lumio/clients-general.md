# Managing data

This page describes the basics of transferring and managing data with LUMI-O. Make sure that you have first properly set up the [authentication and access](./auth-lumidata-eu.md) for LUMI-O.


## Tools to transfer data

LUMI-O is used via tools (client software) that take care of moving data to and from LUMI-O and managing data objects. There are several different kinds of client software for accessing object storage servers. LUMI-O can be used with any object storage client that is compatible with S3 protocol.


The `lumio` module provides some pre-installed client software to interact with LUMI-O:
`rclone`, `s3cmd` and `restic`. On this page we give just some basic information of a few client software that can be used with LUMI-O. Please refer to the manuals of the client software for more detailed information.

### rclone

[rclone-manual]: https://rclone.org/docs/


The configuration by `lumio` module provides two kinds of remote endpoints for `rclone`, private and public: 

- **lumi-<project_number\>-private**: A private endpoint. The buckets and objects uploaded to this
              endpoint will not be publicly accessible.
- **lumi-<project_number\>-public**: A public endpoint. The buckets and objects uploaded to this
                endpoint will be publicly accessible using the URL:
                ```
                https://<project_number>.lumidata.eu/<bucket_name>
                ```
                Be careful to not upload data that cannot be public to this
                endpoint.


Some common example commands to work with LUMI-O with `rclone` are listed in the table below. Once you have set the authentication and access (as described on the [Accessing LUMI-O](./auth-lumidata-eu.md) page, you can use LUMI-O with rclone commands. _Replace 46XXXXXXX with your LUMI project number._
_For the public endpoint, replace the word 'private' with 'public'_

    
| Action                                     | Command                                              |
|--------------------------------------------|------------------------------------------------------|
| List buckets                               | `rclone lsd lumi-46XXXXXXX-private:`                 |
| Create bucket *mybuck*                     | `rclone mkdir lumi-46XXXXXXX-private:mybuck`         |
| List objects in bucket *mybuck*            | `rclone ls lumi-46XXXXXXX-private:mybuck/`           |
| Upload file *file1* to bucket *mybuck*     | `rclone copy file1 lumi-46XXXXXXX-private:mybuck/`   |
| Download file *file1* from bucket *mybuck* | `rclone copy lumi-46XXXXXXX-private:mybuck/file1 .`  |

!!! info
    It doesn't matter which one of the _public_ or _private_ endpoints is used to list the buckets with the `rclone lsd` command. This is because the only difference between the two endpoints is that with the _public_ endpoint, the _ACL_ (that defines the access rights) is by default set to _`public-read`_, making the content in this endpoint publicly accessible. Otherwise the content uploaded to either of the endpoints is located "in the same place".



The basic syntax of an `rclone` command is:

```text
rclone <subcommand> <options> source:path dest:path 
```

The table below lists the most frequently used `rclone` subcommands:

[rc_copy]:    https://rclone.org/commands/rclone_copy/
[rc_sync]:    https://rclone.org/commands/rclone_sync/
[rc_move]:    https://rclone.org/commands/rclone_move/
[rc_delete]:  https://rclone.org/commands/rclone_delete/
[rc_mkdir]:   https://rclone.org/commands/rclone_mkdir/
[rc_rmdir]:   https://rclone.org/commands/rclone_rmdir/
[rc_check]:   https://rclone.org/commands/rclone_check/
[rc_ls]:      https://rclone.org/commands/rclone_ls/
[rc_lsd]:     https://rclone.org/commands/rclone_lsd/
[rc_lsl]:     https://rclone.org/commands/rclone_lsl/
[rc_lsf]:     https://rclone.org/commands/rclone_lsf/

| rclone subcommand   | Description                                                                      |
| ------------------- | -------------------------------------------------------------------------------- |
| [copy][rc_copy]     | Copy files from the source to the destination                                    |
| [sync][rc_sync]     | Make the source and destination identical, modifying only the destination        |
| [move][rc_move]     | Move files from the source to the destination                                    |
| [delete][rc_delete] | Remove the contents of a path                                                    |
| [mkdir][rc_mkdir]   | Create the path if it does not already exist (i.e. create a new bucket)                                    |
| [rmdir][rc_rmdir]   | Remove the path                                                                  |
| [check][rc_check]   | Check if the files in the source and destination match                           |
| [ls][rc_ls]         | List all objects in the path, including size and path                            |
| [lsd][rc_lsd]       | List all directories/containers/buckets in the path                              |
| [lsl][rc_lsl]       | List all objects in the path, including size, modification time and path         |
| [lsf][rc_lsf]       | List the objects using the virtual directory structure based on the object names |

A more extensive list can be found on the [Rclone manual pages][rclone-manual]
or by typing the command `rclone`on LUMI (when the `lumio` module is loaded).




### s3cmd

For s3cmd only one endpoint is configured by the `lumio` module. The content in this endpoint is (by default) private, but it's also possible to set individual buckets or objects in this endpoint as publicly accessible (see below).  

The most common commands to work with LUMI-O with `s3cmd` are listed below:

| Action                                     | Command                             |
|--------------------------------------------|-------------------------------------|
| List buckets                               | `s3cmd ls s3:`                      |
| Create bucket *mybuck*                     | `s3cmd mb s3://mybuck`              |
| List objects in bucket *mybuck*            | `s3cmd ls --recursive  s3://mybuck` |
| Upload file *file1* to bucket *mybuck*     | `s3cmd put file1 s3://mybuck`       |
| Download file *file1* from bucket *mybuck* | `s3cmd get s3://mybuck/file1 .`     |


To set the uploaded buckets or objects public you can add the option `-P` or `--acl-public` to the `s3cmd mb` or `s3cmd put` commands.
(For more information about checking or changing access rights, see the section about [sharing data](./advanced.md).)

The syntax of an `s3cmd` command:

```bash
s3cmd -options <command> parameters
```

The most commonly used _s3cmd_ command options:

| s3cmd command      | Function |
| :----------------- | :--------------------------- |
| mb                 | Create a bucket              |
| put                | Upload an object             |
| ls                 | List objects and buckets     |
| get                | Download objects and buckets |
| cp                 | Move object                  |
| del                | Remove objects or buckets    |
| md5sum             | Get the checksum             |
| info               | View metadata                |
| signurl            | Create a temporary URL       |
| put -P             | Make an object public        |
| setacl --acl-grant | Manage access rights         |


The table above lists only the most essential `s3cmd` commands. For more
complete list, visit the [s3cmd manual page](https://s3tools.org/usage) or type `s3cmd -h` (when the `lumio` module is loaded).





### restic


`restic` is a slightly different from `rclone` and `s3cmd` and is mainly used
for doing backups. 

**Set up the restic repository**

```bash
$ export AWS_ACCESS_KEY_ID=<MY_ACCESS_KEY>
$ export AWS_SECRET_ACCESS_KEY=<MY_SECRET_ACCESS_KEY>
$ restic -r s3:https://lumidata.eu/<bucket> init
```

After this we can run commands like `restic restore` and `restic backup`. the
`-r` flag with the correct bucket and the KEY environment variables are always
needed when running `restic` commands.

For more information, see the [Restic documentation](https://restic.readthedocs.io/en/stable/index.html)

### Python with boto3 library


When use cases become sufficiently complex one might want to interact
with LUMI-O in a more programmatic fashion instead of using the 
command line tools. One such option is the AWS SDK for Python [boto3](https://pypi.org/project/boto3/)\*.

The script

```python
import boto3

session = boto3.session.Session(profile_name='lumi-465000001')
s3_client = session.client('s3')
buckets=s3_client.list_buckets()
```

Would fetch the buckets of project 465000001 and return the information as a python dictionary. 
For the full list of available functions, see the [aws s3 client documentation](https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/s3.html). 

Note that some advanced operations which are supported by AWS might complete successfully when run against LUMI-O, but will actually have no effect. **Be extra thorough in verifying the correct functionality.**
 


If a default profile has been configured `~/.aws/credentials`
the client creation can be shortened to:

```python
import boto3
s3_client = boto3.client('s3')
```

boto3 uses the same configuration files and respects the same environment variables as the `aws` cli.

!!! note 
	You will need a sufficiently new version of boto3 (e.g version 1.26, which is installed if using python3.6, is too old) for it
	to understand a default profile set in ~/.aws/credentials and corresponding config file, 
	otherwise the tool will always default to aws s3 endpoint and you will need to specify the
	profile/endpoint when constructing the client.

\*_If you prefer to work with some other language there are also options for e.g Java, GO and Javascript_


You can create a configuration format for boto3 in [auth.lumidata.eu](https://auth.lumidata.eu) to access LUMI-O directly with boto3 e.g. from your local machine: after creating an access key, click the active key, and select "boto3" from the configuration formats. 


### Raw HTTP request


The LUMI-O object storage can be used by issuing HTTP request.

!!! warning

    We don't recommend using the HTTP API unless there is a specific need. The 
    other listed tools are easier to use. This section only serve as a reference
    on how to provide the credentials to the HTTP API. 

    See [Common error messages](#common-error-messages) for explanations on some of
    the HTTP return codes. 

The example below upload the file `README.md` to the bucket `my-nice-bucket`
using `curl`:

```bash
export S3_ACCESS_KEY_ID=<MY_ACCESS_KEY>
export S3_SECRET_ACCESS_KEY=<MY_SECRET_ACCESS_KEY>

file=README.md
bucket=my-nice-bucket
resource="/${bucket}/${file}"
contentType="text/plain"
dateValue=`date -R`
stringToSign="PUT\n\n${contentType}\n${dateValue}\n${resource}"
s3Key=$S3_ACCESS_KEY_ID
s3Secret=$S3_SECRET_ACCESS_KEY
signature=`echo -en ${stringToSign} | openssl sha1 -hmac ${s3Secret} -binary | base64`
curl -X PUT -T "${file}" \
     -H "Host: https://lumidata.eu/" \
     -H "Date: ${dateValue}" \
     -H "Content-Type: ${contentType}" \
     -H "Authorization: AWS ${s3Key}:${signature}" \
      https://lumidata.eu/${bucket}/${file}
```


## Is my bucket public or private?

If you don't know (or remember) if your bucket or object is public or private, you can check it e.g. in the two following ways:

1) Only public buckets and objects can be accessed with a link over the internet (as described in the [Sharing data](./advanced.md#for-public-data) section). If a bucket is publicly accessible, it's possible to list the objects in the bucket with the link. If an object is publicly accessible, one is able to access the data. 

2) The following commands print the ACLs for a bucket or object:

```
s3cmd info s3://<bucketname>
s3cmd info s3://<bucketname>/<objectname>
```
E.g. the line `ACL: *anon*: READ` indicates that the bucket/object is accessible with a public link. (In that case also a link to the content is printed out, but this link might be in a wrong format. For more information about access links, see the [Sharing data](./advanced.md) section.)


## Checking your utilized LUMI-O quota

Quota limits:

- The default allocated quota per LUMI project is 150 TB. 
- One project can have up to 1000 buckets
- One bucket can have up to 500 000 objects

If you need more storage space in LUMI-O, please contact the [LUMI helpdesk](../../helpdesk/index.md). 


#### LUMI-O authentication web site 

The table on [auth.lumidata.eu](https://auth.lumidata.eu/) shows the allocated quota for your project, and the current used LUMI-O quota for your project. This information is updated with a delay. 

#### LUMI web interface

In LUMI web interface one can see the sizes of objects in a bucket. Also the number of lines/rows for a bucket is the same as the number of objects in the bucket. For the list of buckets, the number of lines/rows is the same as the number of buckets.


#### Command line

When access to LUMI-O is set, the used quotas can be checked e.g. with `rclone` or `s3cmd`:

=== "Rclone"
    
    | Quota to check                                | Command                                              |
    |--------------------------------------------|------------------------------------------------------|
    | Number of buckets                          | `rclone lsd lumi-46XXXXXXX-private: | wc -l`         |
    | Number of objects in a bucket 'mybucket'   | `rclone lsd lumi-46XXXXXXX-private:mybucket | wc -l` |
    | Used quota by the project                  | `rclone size lumi-46XXXXXXX-private:`                |


    _Replace 46XXXXXXX with your LUMI project number._
    _Note that it doesn't matter if you list the content for 'private' or 'public' endpoint, in both cases all content is included to the quota._

=== "s3cmd"

    | Action                                     | Command                             |
    |--------------------------------------------|-------------------------------------|
    | Number of buckets                          | `s3cmd ls s3: | wc -l`              |
    | Number of objects in a bucket 'mybucket'   | `s3cmd ls s3://mybucket | wc -l`    |
    | Used quota by the project                  | `s3cmd du`                          |



## Common error messages



| HTTP status code | Message           | Meaning  |
|------------------|-------------------|----------|
| 400 | EntityTooLarge | The file is too large |
| 403 | QuotaExceeded | You have reached a quota limit. If you need more quota in LUMI-O, please contact LUMI helpdesk. Please specify your current quota usage and the current allocated quota for your project in the request. |
| 403 | AccessDenied | Your credentials are not allowed to view the bucket |
| 404 | NoSuchBucket | The bucket does not exist |
| 409 | Conflict | A bucket with that name already exists |





