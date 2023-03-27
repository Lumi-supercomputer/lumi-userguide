# LUMI-O

The LUMI-O object store offers a total of 30 PB storage for storing, sharing, and staging of data.
In an object-based storage, data is managed as objects instead of being organized as files in a directory hierarchy.

To use LUMI-O you will need to generate authentication credentials, which you can then use 
with different tools to connect to LUMI-O

For more details on what an object store is, refer to the [LUMI-O storage documentation](/hardware/storage/lumio)

## Configuring the LUMI-O connection

Start by loading the lumio module which provides configuration and data transfer tools:

```
module load lumio
```

To configure a connection to LUMI-O, run the command:
```text
lumio-conf
```

This command asks you to connect with your browser to the [LUMI-O credentials management service](https://auth.lumidata.eu), create credentials there and the copy the project nunber
and keys for the setup tool, for authentication use **MyAccessID**. The setup process will create configuration files for _s3cmd_ and _rclone_.

For a step by step description, read the [Creating LUMI-O credentials](auth-lumidata-eu.md) instructions.

Using the [LUMI-O credentials management service](https://auth.lumidata.eu) you can also generate configuration for different object storage clients like 
shell, boto3, rlcone, s3cmd and aws. This is useful for using LUMI-O from somewhere else than LUMI, where the `lumio-conf` command is not available ( The tool can be downloaded from the [LUMI-O git repository](https://github.com/Lumi-supercomputer/LUMI-O-tools), but we only officially support the tool on LUMI  ) 

## Tools to transfer data

The `lumi-o` module provides some pre-installed tools to interact with LUMI-O: `rclone`, `s3cmd` and `restic`
This is not a comprehensive documentation of these tools, for that you can refer to the official documentation for the tools. 

The most common commands for `s3cmd` and `rclone` to

List buckets

- `rclone lsd lumi-o:`
- `s3cmd ls s3:`

Create bucket _mybuck_

- `rclone mkdir lumi-o:mybuck`
- `s3cmd mb s3:/mybuck`

List objects in bucket _mybuck_

- `rclone ls lumi-o:mybuck`
- `s3cmd ls --recursive  s3://mybuck`

Uppload file _file1_ to bucket _mybuck_

- `rclone copy file1 lumi-o:mybuck/`
- `s3cmd put file1 s3://mybuck` 

Download file _file1_ from bucket _mybuck_

- `rclone copy lumi-o:mybuck/file1 ./`
- `rclone get s3://mybuck/file1 .`



### rclone

For `rclone`,  Lumi-o configuration provides two  remotes: _lumi-o:_ and _lumi-pub:_ . The buckets used by _lumi-pub_ will be publicly visible using the URL: https://_project-number_.lumidata.eu/_bucket_name_.

The basic syntax of Rclone:
```text
rclone subcommand optons source:path dest:path 
```

The most frequently used Rclone commands:

*    [rclone copy]( https://rclone.org/commands/rclone_copy/) – Copy files from the source to the destination, skipping what has already been copied.
*    [rclone sync](https://rclone.org/commands/rclone_sync/) – Make the source and destination identical, modifying only the destination.
*    [rclone move](https://rclone.org/commands/rclone_move/) – Move files from the source to the destination.
*    [rclone delete](https://rclone.org/commands/rclone_delete/) – Remove the contents of a path.
*    [rclone mkdir](https://rclone.org/commands/rclone_mkdir/) – Create the path if it does not already exist.
*    [rclone rmdir](https://rclone.org/commands/rclone_rmdir/) – Remove the path.
*    [rclone check](https://rclone.org/commands/rclone_check/) – Check if the files in the source and destination match.
*    [rclone ls](https://rclone.org/commands/rclone_ls/) – List all objects in the path, including size and path.
*    [rclone lsd](https://rclone.org/commands/rclone_lsd/) – List all directories/containers/buckets in the path.
*    [rclone lsl](https://rclone.org/commands/rclone_lsl/) – List all objects in the path, including size, modification time and path.
*    [rclone lsf](https://rclone.org/commands/rclone_lsf/) – List the objects using the virtual directory structure based on the object names.
*    [rclone cat](https://rclone.org/commands/rclone_cat) – Concatenate files and send them to stdout.
*    [rclone copyto](https://rclone.org/commands/rclone_copyto/) – Copy files from the source to the destination, skipping what has already been copied.
*    [rclone moveto](https://rclone.org/commands/rclone_moveto/) – Move the file or directory from the source to the destination.
*    [rclone copyurl](https://rclone.org/commands/rclone_copyurl/) – Copy the URL's content to the destination without saving it in the tmp storage.

A more extensive list can be found on the [Rclone manual pages](https://rclone.org/docs/) or by typing the command `rclone` in Lumi.

### s3cmd

The syntax of the `s3cmd` command:
```text
s3cmd -options command parameters
```

The most commonly used _s3cmd_ commands:

| s3cmd command | Function |
| :---- | :---- |
| mb | Create a bucket |
| put | Upload an object |
| ls | List objects and buckets |
| get | Download objects and buckets |
| cp | Move object |
| del | Remove objects or buckets |
| md5sum | Get the checksum |
| info | View metadata |
| signurl | Create a temporary URL |
| put -P | Make an object public |
| setacl --acl-grant | Manage access rights |


The table above lists only the most essential _s3cmd_ commands. For more complete list, visit the [s3cmd manual page](https://s3tools.org/usage) or type:
```text
s3cmd -h
```

### restic

`restic` is a slightly different from `rclone` and `s3cmd` and is mainly used for doing backups. 

**Setup the restic repository**

```bash
$ export AWS_ACCESS_KEY_ID=<MY_ACCESS_KEY>
$ export AWS_SECRET_ACCESS_KEY=<MY_SECRET_ACCESS_KEY>
$ restic -r s3:https://lumidata.eu/<bucket> init
```

After this we can run commands like `restic restore` and `restic backup`. 
the  `-r` flag with the correct bucket and the KEY environment variables are always needed
when running `restic` commands.

For more information see the [Restic documentation](https://restic.readthedocs.io/en/stable/index.html)

### Raw HTTP request 

**We don't recommend using this unless there is a specific need as other tools are easier to use. It's here more as a reference how to provide the credentials to the http API**
See [Common error messages](error-messages.md) for explanations on some of the http return codes. 


```bash

export S3_ACCESS_KEY_ID=<MY_ACCESS_KEY>
export S3_SECRET_ACCESS_KEY=<MY_SECRET_ACCESS_KEY>

file=README.md
bucket=my-nice-bucket
resource="/${bucket}/${file}"
contentType="application/x-compressed-tar"
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
