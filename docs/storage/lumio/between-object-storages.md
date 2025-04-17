# Copying files directly between object storages

## Examples with rclone

To copy files directly between two object storages (e.g. between two LUMI-O project storages, or LUMI-O and other object storages like [Amazon S3](https://docs.aws.amazon.com/AmazonS3/latest/userguide/Welcome.html), [Google cloud](https://cloud.google.com/learn/what-is-object-storage), [CREODIAS](https://creodias.eu/cloud/cloudferro-cloud/storage-2/object-storage/), [Allas](https://docs.csc.fi/data/Allas/introduction/)), the credentials for both object storages need to be set in the `rclone.conf` file (in the users home directory `.config/rclone/rclone.conf`). 


### General example

```
[lumi-46YXXXXXX-private]
type = s3
acl  = private
env_auth = false
provider = Ceph
endpoint = https://lumidata.eu
access_key_id     = xxxxxxxxxxxxxxxxxxxx
secret_access_key = xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
max_upload_parts  = 1000


[otherobjectstorage]
type = s3
acl = private
env_auth = false
provider = Other
endpoint = yourotherendpoint.com
access_key_id = yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy
secret_access_key = yyyyyyyyyyyyyyyyyyyyyyyyyyyyyy
```

After creating/updating this file, rclone can be used e.g. to copy files from the other object storage to LUMI-O:

```
rclone copyto otherobjectstorage:bucket-x/object-y lumi-46YXXXXXX-private:bucket-z/object-a
```

or r.g. to list files from either LUMI-O or the other object storage by using the respective name:

```
rclone lsf otherobjectstorage:
```


### Between LUMI-O and LUMI-O

Two copy/move data between two LUMI-O storages, you need to have user rights to access both these LUMI-O projects, and your access keys for both projects need to be valid. 

If you need to move a very large amount of data between two of your LUMI-O project storages, you can also contact the [LUMI user support team](../../helpdesk/index.md) for this.

An example for how to set the `rclone.conf` file:

```
[lumi-46YXXXXXX-private]
type = s3
acl  = private
env_auth = false
provider = Ceph
endpoint = https://lumidata.eu
access_key_id     = xxxxxxxxxxxxxxxxxxxx
secret_access_key = xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
max_upload_parts  = 1000

[lumi-46ZYYYYYY-private]
type = s3
acl  = private
env_auth = false
provider = Ceph
endpoint = https://lumidata.eu
access_key_id     = yyyyyyyyyyyyyyyyyyyy
secret_access_key = yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy
max_upload_parts  = 1000

```



### Between LUMI-O and Allas

[Allas](https://docs.csc.fi/data/Allas/introduction/) is an object storage (in many ways similar to LUMI-O) that is used with the supercomputing clusters in Finland. 


An example for how to set the `rclone.conf` file:
```
[lumi-46YXXXXXX-private]
type = s3
acl  = private
env_auth = false
provider = Ceph
endpoint = https://lumidata.eu
access_key_id     = xxxxxxxxxxxxxxxxxxxx
secret_access_key = xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
max_upload_parts  = 1000

[s3allas]
type = s3
acl = private
env_auth = false
provider = Other
endpoint = a3s.fi
access_key_id = yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy
secret_access_key = yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy

```

After creating/updating this file, rclone can be used e.g. to copy files from Allas to LUMI-O:

```
rclone copyto s3allas:bucket-x/object-y lumi-46YXXXXXX-private:bucket-z/object-a
```

or e.g. to list files from either Allas or LUMI-O by using the respective name:

```
rclone lsf s3allas:
```

You can also use Allas directly from LUMI with the same tools that work in the environments of CSC national clusters. See also the [CSC documentation about Allas on LUMI](https://docs.csc.fi/data/Allas/allas_lumi/) and the page [Using Allas on LUMI](./allas-lumi.md) use case.

<!-- 
To be checked and tested ^
The current configuration with Allas on LUMI seems to happen with swift. 
Does this apply on LUMI side or does it matter? Is it somehow taken care with allas_conf settings on LUMI already?

"The configuration for Allas is added automatically in `rclone.conf` when configuring Allas in s3 mode:

```
source allas_conf --mode s3cmd
```
"

-->





