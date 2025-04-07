# General info of the tools




LUMI-O is used via client tools that take care of moving data to and from LUMI-O and managing data objects. There are several different kinds of client software for accessing the object storage servers. LUMI-O can be used with any object storage client that is compatible with S3 protocol.


## Supported tools

The `lumio` module provides some pre-installed tools to interact with LUMI-O:
`rclone`, `s3cmd` and `restic`.

Please refer to the manuals of the respective tools for more detailed information.

The most common commands for `s3cmd` and `rclone` to

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





## Credentials & Configuration


### Moving tool configuration files

In some cases it might be required to read
credentials from some other location than the default 
locations under home. This can be achieved using environment variables or command line flags.


|      | rclone        | s3cmd                  | aws                                         |
|------|---------------|------------------------|---------------------------------------------|
| DEFAULT | `~/.config/rclone/rclone.conf`   | `~/.s3cfg`  | `~/.aws/credentials` and `~/.aws/config`|
| ENV  | `RCLONE_CONFIG` | `S3CMD_CONFIG`           | `AWS_SHARED_CREDENTIALS_FILE` and `AWS_CONFIG_FILE` |
| FLAG | `--config FILE` | `-c FILE`, `--config=FILE` |                                             |

The `aws` cli additionally has the concept of [profiles](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html), and you can specify 
which one to use using the `--profile <name>` flag or the `AWS_PROFILE` environment variable.

### Environment

Most programs will use the environment variables `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`
when trying to authenticate. So these can be set if one does not wish to save the credentials on disk.
The environment variables do not always take precedence over values set in configuration files, as
is the case for `s3cmd` and `rclone`. This means that invalid credentials in config files will
lead to an access denied even if there are valid credentials in the environment. The `aws` command
will use the environment variables instead of `~/.aws/credentials` if they are set. 
`rclone` will additionally require `RCLONE_S3_ENV_AUTH=true` in the environment or `env_auth = true`
in the config file.


Unless you have properly configured the s3 tools to use LUMI-O, they will usually default to using amazon aws s3. This is also the case for most other programs
so if you wish to use LUMI-O with other software, you usually have to find some configuration option or environment variable to set a non-default
host name. The correct hostname to use for LUMI-O is `https://lumidata.eu`

