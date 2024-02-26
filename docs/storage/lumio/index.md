# LUMI-O

[auth.lumidata.eu]: https://auth.lumidata.eu
[lumi-o-tools]: https://github.com/Lumi-supercomputer/LUMI-O-tools
[rclone-manual]: https://rclone.org/docs/

The LUMI-O object store offers a total of 30 PB storage for storing, sharing,
and staging of data.

In an object-based storage, data is managed as objects instead of being
organized as files in a directory hierarchy.

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

To use LUMI-O, you will need to generate authentication credentials, which you
can then use with different tools to connect to LUMI-O.

## Configuring the LUMI-O connection

Start by loading the `lumio` module which provides configuration and data
transfer tools:

```
module load lumio
```

To configure a connection to LUMI-O, run the command:
```text
lumio-conf
```

This command asks you to connect with your browser to the [LUMI-O credentials
management service](auth-lumidata-eu.md), create credentials there and the copy
the project number and keys for the setup tool. The setup process will create configuration files for `s3cmd`
and `rclone`.

For a step-by-step description, read the [Creating LUMI-O
credentials](auth-lumidata-eu.md) instructions.

Using the [LUMI-O credentials management service,](auth-lumidata-eu.md) you can
also generate configuration for different object storage clients like shell,
boto3, rclone, s3cmd and aws. This is useful for using LUMI-O from somewhere
else than LUMI, where the `lumio-conf` command is not available (The tool can be
downloaded from the [LUMI-O repository][lumi-o-tools], but we only officially
support the tool on LUMI) 

## Tools to transfer data

The `lumio` module provides some pre-installed tools to interact with LUMI-O:
`rclone`, `s3cmd` and `restic`.

Please refer to the manuals of the respective tools for more detailed information.

The most common commands for `s3cmd` and `rclone` to

=== "Rclone"
    
    | Action                                     | Command                              |
    |--------------------------------------------|--------------------------------------|
    | List buckets                               | `rclone lsd lumi-o:`                 |
    | Create bucket *mybuck*                     | `rclone mkdir lumi-o:mybuck`         |
    | List objects in bucket *mybuck*            | `rclone ls lumi-o:mybuck/`           |
    | Upload file *file1* to bucket *mybuck*     | `rclone copy file1 lumi-o:mybuck/`   |
    | Download file *file1* from bucket *mybuck* | `rclone copy lumi-o:mybuck/file1 .`  |

=== "s3cmd"

    | Action                                     | Command                             |
    |--------------------------------------------|-------------------------------------|
    | List buckets                               | `s3cmd ls s3:`                      |
    | Create bucket *mybuck*                     | `s3cmd mb s3://mybuck`              |
    | List objects in bucket *mybuck*            | `s3cmd ls --recursive  s3://mybuck` |
    | Upload file *file1* to bucket *mybuck*     | `s3cmd put file1 s3://mybuck`       |
    | Download file *file1* from bucket *mybuck* | `s3cmd get s3://mybuck/file1 .`     |

### rclone

For `rclone`, the LUMI-O configuration provides two remotes endpoints: 

- **lumi-o**: The private endpoint. The buckets and objects uploaded to this
              endpoint will not be publicly accessible.
- **lumi-pub**: The public endpoint. The buckets and objects uploaded to this
                endpoint will publicly accessible using the URL:
                ```
                https://<project-number>.lumidata.eu/<bucket_name>`
                ```
                Be careful to not upload data that cannot be public to this
                endpoint.


The basic syntax of the `rclone` command is:

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
| [mkdir][rc_mkdir]   | Create the path if it does not already exist                                     |
| [rmdir][rc_rmdir]   | Remove the path                                                                  |
| [check][rc_check]   | Check if the files in the source and destination match                           |
| [ls][rc_ls]         | List all objects in the path, including size and path                            |
| [lsd][rc_lsd]       | List all directories/containers/buckets in the path                              |
| [lsl][rc_lsl]       | List all objects in the path, including size, modification time and path         |
| [lsf][rc_lsf]       | List the objects using the virtual directory structure based on the object names |

A more extensive list can be found on the [Rclone manual pages][rclone-manual]
or by typing the command `rclone` in LUMI.

### s3cmd

The syntax of the `s3cmd` command:

```bash
s3cmd -options <command> parameters
```

The most commonly used _s3cmd_ commands:

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
complete list, visit the [s3cmd manual page](https://s3tools.org/usage) or type:

```text
s3cmd -h
```

If you need to make uploaded objects or buckets public you can add the `-P, --acl-public` flag
to `s3cmd put`. 

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

## Raw HTTP request 

The LUMI-O object storage can be used by issuing HTTP request.

!!! warning

    We don't recommend using the HTTP API unless there is a specific need. The 
    tools listed above are easier to use. This section only serve as a reference
    on how to provide the credentials to the HTTP API. 

    See [Common error messages](error-messages.md) for explanations on some of
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
