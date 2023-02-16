# lo-commands, easy and safe

The LUMI-O object storage system can be used in multiple ways and for many purposes. In many cases, using LUMI-O efficiently requires that the user know the features of both the object storage system and the software or protocol used to manage the data in LUMI-O.

For users who simply want to use LUMI-O for storing data that is in the LUMI computing environment, LUST provides a set of commands for managing and moving data between the LUMI computing environment and LUMI-O:


| lo-command | help text | Function |
| :--- | :--- | :--- |
| [lo-put](#lo-put)| [help](https://github.com/CSCfi/lumio-cli-utils/blob/master/help/lo-put.md)|Upload a file or directory to LUMI-O |
| [lo-check](#lo-check) |[help](https://github.com/CSCfi/lumio-cli-utils/blob/master/help/lo-check.md)| Check if all the objects, that lo-put should have created, are found in LUMI-O |
| [lo-list](#lo-list) |[help](https://github.com/CSCfi/lumio-cli-utils/blob/master/help/lo-list.md)| List buckets and objects in LUMI-O |
| [lo-publish](#lo-publish) |[help](https://github.com/CSCfi/lumio-cli-utils/blob/master/help/lo-check.md)|Upload a file to LUMI-O into a bucket that allows public access over the internet |
| [lo-flip](#lo-flip) |[help](https://github.com/CSCfi/lumio-cli-utils/blob/master/help/lo-flip.md)|Upload a file temporarily to LUMI-O into a bucket that allows public access over the internet |
| [lo-get](#lo-get) |[help](https://github.com/CSCfi/lumio-cli-utils/blob/master/help/lo-get.md)| Download a stored dataset (object) from LUMI-O |
| [lo-find](#lo-find)|[help](https://github.com/CSCfi/lumio-cli-utils/blob/master/help/lo-find.md)|Search and locate data uploaded with *lo-put* |
| [lo-delete](#lo-delete) |[help](https://github.com/CSCfi/lumio-cli-utils/blob/master/help/lo-delete.md)| Delete an object in LUMI-O |
| [lo-info](#lo-info) |[help](https://github.com/CSCfi/lumio-cli-utils/blob/master/help/lo-info.md)| Display information about an object in LUMI-O |
| [lo-access](#lo-access) |[help](https://github.com/CSCfi/lumio-cli-utils/blob/master/help/lo-access.md)| Control access permissions of a bucket in LUMI-O |
| lo-stream |[help](https://github.com/CSCfi/lumio-cli-utils/blob/master/help/lo-stream.md)|Stream the content of an object to standard output |
| lo-encrypt |[help](https://github.com/CSCfi/lumio-cli-utils/blob/master/help/lo-encrypt.md)|Make an encrypted copy of an object uploaded in LUMI-O |

In addition to the above commands, there are separate tools for other purposes:

 * __lumio_conf__ : Set up and open a connection to LUMI-O
 * __lumio-backup__ : Create a backup copy of a local dataset in a backup repository in LUMI-O.
 * __lumio-mount__ : Mount a bucket in lumio to be used as a read-only directory in the local environment.
 * __lumio-health-check__ : Check the integrity of over 5 GB objects in LUMI-O.
 * [__lumio-dir-to-bucket__](https://github.com/CSCfi/lumio-cli-utils/blob/master/help/lumio-dir-to-bucket.md) : copy a local file or directory to LUMI-O. Parallel upload processes are used for over 5GB files.

If you use the lo-commands outside the supercomputers, check the [lumio-cli-utils documentation](https://github.com/CSCfi/lumio-cli-utils/blob/master/README.md) for how to install these tools.

Below we discuss briefly of the most frequetly used features of lo-commands. New features are added to lo-commands every now and then and they may not be covered in the examples below. Use the help option `--help` to check the command specific information. For example:
```text
lo-put --help
```


# Example: Saving data from scratch directory to LUMI-O

## Opening a connection

In order to use these tools in LUMI-O, first familiarize yourself with [Accessing LUMI-O](./accessing-lumi-o.md):
```text
source /project/project_462000008/lumi-o/lumi-o_setup.sh
```
Then open a connection to LUMI-O:
```text
lumio-conf
```
The connection remains open for eight hours. You can rerun the _lumio-conf_ command at any time
to extend the validity of the connection for eight more hours or to switch to another LUMI-O
project.

By default, _lumio-conf_ lists your projects that have access to LUMI-O, but if you know the name of the project, you
can also give it as an argument:
```text
lumio-conf project_201234
```

## Copying data between LUMI scratch directory and LUMI-O

Copying data from directory _/scratch/project_462000008/dataset_3_ to LUMI-O:

```text
cd /scratch/project_462000008
lo-put dataset_3
```
The data in directory _dataset_3_ is stored to the default bucket _462000008-<node_name>-project_ as object: _dataset_3.tar_.
Available data buckets in LUMI-O can be listed with command:

```text
lo-list
```
And the content of 201234-lumi-SCRATCH can be listed with command:

```
lo-list 462000008-<node_name>-project
```
The directory that was stored to LUMI-O can be retrieved back to any LUMI paritition with lo-get command and providing the full path to the bucket, which can be seen with the previous command.

```text
lo-get 462000008-uan01-project/project/project_462000008/lumi-o/dataset_3.tar
```


# A commands in more detail

## lo-put uploads data to LUMI-O<a name="lo-put"></a>

`lo-put` is used to upload data from the disk environment of LUMI to
the LUMI-O storage environment. The basic syntax of the command:
```text
lo-put directory_or_file
```

By default, this tool performs the following operations:

1.    Ensure that there is a working connection to the LUMI-O storage service and
define the project that will be used to store the data.

2.    In the case of a directory, the content of the directory is collected as a single file
using the `tar` command.

3.    The packed data is uploaded to LUMI-O using the `rclone` command and the _S3_ protocol.


By default, lo-put uses the standard bucket and object names that depend on the username, project and location
of the data uploaded:

*    a) Data from /scratch in LUMI is uploaded to the bucket _projectNumber-<node-name>-scratch/_
*    b) Data from /projappl in Puhti is uploaded to the bucket _projectNumber-<node-name>-project_
*    c) In other cases, the data is uploaded to _username-projectNumber-MISC_

For example, for the user _andersmart_, a member of the project _462000008_, data located in the HOME directory
is uploaded to the bucket _andersmart-462000008-misc_.

If you wish to use other than the standard bucket, you can define a bucket name with the option _-b_ or  
_--bucket_.

The compressed dataset is stored as one object. By default, the object name depends on the file name and location. The possible subdirectory path in LUMI-O is included in the object name, e.g. a file called _test_1.txt_ in /scratch/project_462000008 in LUMI-O can be stored using the commands:
```text
cd /scratch/project_462000008
lo-put test_1.txt
```

In this case, the file is stored in the bucket _462000008-<node-name>-scratch_.
as the object _test_1.txt_

If you have another file called _test_1.txt_ located in _/scratch/project_462000008/andersmart/project2/_,
you can store it using the commands
```text
cd /scratch/project_462000008/andersmart/project2/
lo-put test_1.txt
```
or
```text
cd /scratch/project_462000008/andersmart
lo-put project2/test_1.txt
```
In this case, the file is stored in the bucket _462000008-<node-name>-scratch_
as the object _/scratch/project_462000008/anders/project2/test_1.txt_.

In addition to the actual data object, another object containing metadata is created. This metadata object has the
same name as the main object with the extension *_ometa*. This metadata file is used by the
other *lo-commands*, and normally, it is not displayed to the user, but if you examine the buckets
using tools like _swift_ or _rclone_, you will see these metadata objects as well.

If you wish to use a name differing from the default object name, you can define it with the option _-o_ or  
_--object_:
```text
cd /scratch/project_462000008
lo-put project2/test_1.txt -b newbucket1 -o case1.txt -c
```

The command above uploads the file *test_1.txt* to LUMI-O in the bucket _newbucket1_ as the object _case1.txt.zst_.
As the option _-c_ is used, the data is stored in zstd compressed format.

You can give several file or directory names for _lo-put_ and use * as a wildcard character when naming the data to be uploaded. Note that in these cases each item (file or directory) will be stored as a separate object. For example, say that we have a directory called _job123_ that contains files _input1.txt_, _input2.txt_ and _program.py_. In addition there are directories _output_dir_1_ and _output_dir_2_ .

Command:
```text
lo-put job123/output_dir_1 jobs123/input1.txt
```
uploads content of _output_dir_1_ to object _job123/output_dir_1.tar_ and _input1.txt_ to _job123/input1.txt_.

Similarly command
```text
lo-put job123/output_dir*
```
uploads content of _output_dir_1_ to object _job123/output_dir_1.tar_ and content of _output_dir_2_ to object _job123/output_dir_2.tar_.

During upload datasets that are larger than 5 GB will be split and stored as several objects. This is done automatically to a bucket that is named by adding extension `_segments` to the original bucket name. For example, if you would upload a large file to  bucket  _andersmart-462000008-misc_ the actual data would be stored as several pieces into bucket _andersmart-462000008-misc_segments_. The target bucket (_andersmart-462000008-misc_) would contain just a front object that contains information what segments make the stored dataset. Operations performed to the front object are automatically reflected to the segments. Normally users don't need to operate with the segments buckets at all and objects inside these buckets should not be deleted or modified.


## lo-check<a name="lo-check"></a>

This command goes through the LUMI-O object names, that a corresponding `lo-put` command would create, and then checks if object with the same name already exists in LUMI-O. The main purpose of this command is to provide a tool to check if a large `lo-put` command was successfully executed. `lo-check` accepts the same command line options as `lo-put`.

For example, if a dataset is uploaded with command:
```text
lo-put dataset_4/*
```
The upload can be checked with command:
```text
lo-check dataset_4/*
```
The _lo-check_ command compares the item names to be uploaded to the matching objects in LUMI-O.
The files or directories that don't have a target object LUMI-O, are reported and stored to a file:
missing_bucket-name_number. If some of the objects in the sample commands above would be missing, then
lo-check would list the missing files and directories in file `missing_dataset_4_67889` (the number in the end is
just a random number).

This file of missing items can be used with lo-put option --input-list, to continue the failed upload process:
```text
lo-put --input-list missing_dataset_4_67889
```

You should note, that _lo-check_ does does not check if the actual contents of the object is correct. It checks only the object names, which may originate from some other sources.

In addition to checking, if upload was successful, _lo-check_ can be used to do a "dry-run" test for _lo-put_ to see, what objects will be created or replaced before running the actual _lo-put_ command.


## lo-list<a name="lo-list"></a>

lo-list is used to show the names of buckets and objects stored to LUMI-O. lo-list is designed to be used for objects uploaded with _lo-put_ but it shows objects that have been uploaded with other tools too. However, it doesn't show the _ometa_ metadata file files created by lo-put, to keep the object listings shorter.

### lo-list examples

List all buckets belonging to a project:
```text
lo-list
```
Display the objects included in a bucket:
```text
lo-list bucket_name
```
Typing a part of an object's name lists a subset of objects:
```text
lo-list bucket_name/beginning_of_the_object
```
A more detailed listing, containing object size and date can be obtained with option `-l`
```text
lo-list -l
```
Option `-d` make lo-list to interpret /-characters in object names as pseudofolder separators.
```text
lo-list -d
```

## lo-publish<a name="lo-publish"></a>

`lo-publish` copies a file to LUMI-O a bucket that can be publicly accessed. Thus, anyone with the address (URL) of the
uploaded data object can read and download the data with a web browser or tools like _wget_ and _curl_.
lo-publish works similarly to lo-put with some differences:

1) lo-publish can upload only files, not directories.
2) The access control of the target bucket is set so that it is available for any user in read-only mode.

The basic syntax:
```text
lo-publish file_name
```
By default, the file is uploaded to the bucket _username-projectNumber_-pub. You can define other bucket names using the option _-b_. You should note that this command makes all data in the target bucket publicly accessible, including data that has been previously uploaded to the bucket.

The public URL of a data object will be:
`https://462000008.lumidata.eu/andersmart-462000008-pub/test_1.txt`

An object uploaded with _lo-publish_ can be removed from LUMI-O using the command _lo-delete_.

A sample session with _lo-publish_, uploading the document _test_1.txt_ to the default public bucket in LUMI-O:

<pre><b>lo-publish test_1.txt</b>
Files to be uploaded:  test_1.txt
rclone mkdir lumi-pub:andersmart-462000008-pub
Bucket: andersmart-462000008-pub
Processing: test_1.txt
Checking total size of test_1.txt. Please wait.
Uploading data to lumio.
Transferred:              0 B / 0 B, -, 0 B/s, ETA -
Transferred:            1 / 1, 100%
Elapsed time:         0.6s
Confirming upload...
test_1.txt OK
test_1.txt uploaded to andersmart-462000008-pub
Public link: https://462000008.lumidata.eu/andersmart-462000008-pub/test_1.txt

Upload ready

</pre>

## lo-flip<a name="lo-flip"></a>

`lo-flip` is a tool to make individual files temporarily available over the internet. It is intended for situations where you
want to make a copy of a file visible on the internet for a short while e.g. for copying to another platform shared with a co-worker.

lo-flip copies a file to LUMI-O into a bucket that can be publicly accessed. Thus, anyone with the address (URL) of the
uploaded data object can read and download the data with a web browser or tools like _wget_ and _curl_.
lo-flip works similarly to lo-publish with some differences:
    1) Only the predefined bucket name (_username-projectNumber_-flip) can be used.
    2) Upon execution, it checks the content of the flip bucket and deletes objects that are older than two days.

The basic syntax:
```text
lo-flip file_name
```
The file is uploaded to the bucket _username-projectNumber_-flip. The URL of the uploaded object:
```text
https://462000008.lumidata.eu/andersmart-462000008-flip/test2.txt
```


## lo-find<a name="lo-find"></a>

The `lo-find` command lists and locates data that has been uploaded to LUMI-O using `lo-put`.

The basic syntax:
```text
lo-find query_term
```

The query term is compared to the names and original paths of the files that have been uploaded to
LUMI-O, and matching objects are reported (but not downloaded).

The query term is processed as a regular repression where some characters, e.g. period (.), have a special meaning.
The same regular expression syntax is used with e.g. the _grep_, _awk_ and _sed_ commands.
The most commonly occurring special characters:

- Period (**.**) is used to define any single character.
- **^** marks the beginning of a line.
- **$** marks the end of a line.
- **[ ]** matches any character inside the brackets. For example, [abc] would match a, b or c.
- **[^ ]** matches any character except the characters inside the brackets.   
    For example, [^abc] would select all rows that contain characters than are not a, b and c.
- ** * ** matches zero or more of the preceding characters or expressions.
    `\{n,m\}` matches n to m occurrences of the preceding characters or expressions.

Options:


- **-a**, **--all**  By default only the standard buckets, used by lo-put, are searched. Option `--all` defines that all the buckets of the project will be included in the search.
- **-f**, **--files** List the names of matching files inside the objects in addition to the object names.
- **-p**,**--project _project_ID_** Search matches in the buckets of the defined project instead of the currently configured project.
- **-b**, **--bucket _bucket_name_** By default, all default buckets used by `lo-put` are searched. The option _-bucket_ allows you to specify a single bucket for the search. Use this option also in cases where you have stored data in a bucket with a non-standard name.
- **-s**, **-silent** Print only object names and the number of hits. If the _-f_ option is used, print the object name and the matching file names on one row.

## lo-info shows information about an uploaded dataset<a name="lo-info"></a>

The command `lo-info` allows you to get information about a dataset that has been uploaded to LUMI-O using `lo-put`.   

```text
lo-info bucket/object_name
```           
If you execute this command without any object name, it will list basic information of all of the objects of the current project and a total summary about how much data and objects your LUMI-O project contains.
```text
lo-info
```   


## lo-get retrieves stored data<a name="lo-get"></a>

This tool is used to download data that has been uploaded to the LUMI-O service using the `lo-put` command.
The basic syntax:
```text
lo-get object_name
```
By default, the object is retrieved, uncompressed and extracted to a file or directory that was used in upload. If a directory or file with the same name already exists, you must either remove the existing file or directory, or assign the downloaded data to a new directory with the `-target` option.

Options:

- **-p**, **--project _project_ID_** Retrieve data from the buckets of the defined project instead of the currently configured project.
- **-f**, **--file _file_name_** Retrieve only a specific file or directory from the stored dataset. **Note:** Define the full path of the file or directory within the stored object.
- **-d** **--target_dir** <dir_name> If this option is defined, a new target directory is created and the data is retrieved there.
- **-t** **--target_file** <file_name> Define a file name for the object for the object to be downloaded.
- **-l** **--original_location**       Retrieve the data to the original location in the directory structure.
- **--asis**                        Download the object without unpacking tar files and uncompressing zst compressed data.
- **--s3cmd**                       Use S3 protocol and s3cmd command for data retrieval in stead of Swift protocol and rclone.

At the moment, _lo-get_ can download only one object at a time. If you need to download large number of objects you need to use loops. For example to download all the objects in bucket _bucket_123_ , you could use commands:

```text
#make a list of objects
lo-list 462000008-uan01-project > object_list_462000008-uan01-project

#use the list in for loop
for ob in $(cat object_list_462000008-uan01-project)
do
  lo-get $ob
done  

#remove the object list
rm object_list_462000008-uan01-project
```


## lo-delete<a name="lo-delete"></a>
lo-delete is used to remove data that has been uploaded to LUMI-O service using the lo-put command.
The basic syntax of the command is:
<pre>lo-delete object_name</pre>

By default _lo-delete_ asks user to confirm the removal of an object. This checking can be skipped with option `-f`.

If you want to remove a bucket, you can use option `--rmb`. By default _lo-delete --rmb_ removes only empty buckets. If you want to delete non-empty bucket, you need to add option `--FORCE` to the command.

## lo-access<a name="lo-access"></a>

By default, only project members can read and write the data in a bucket.
Members of the project can grant read and write access to the bucket and
the objects it contains, for other LUMI-O projects or make the bucket publicly
accessible to the internet.

**lo-access** is a tool to control access permissions (swift protocol) of a bucket in LUMI-O.

Syntax
```text
lo-access +/-type project_id bucket
```
Options:

- **+r**,  **+read** <project_id>        Grant read access to the bucket for the project.
- **+w**,  **+write** <project_id>       Grant write access to the bucket for the project.
- **+rw**, **+read-write**  <project_id> Grant read and write access to the bucket for the project.
- **-r**,  **-read** <project_id>        Remove read access from the bucket.
- **-w**,  **-write** <project_id>       Remove write access from the bucket.
- **-rw**, **-read-write**  <project_id> Remove read and write access from the bucket to the project.
- **+p**,  **+public**                   Give public read-only access to the bucket.
- **-p**,  **-public**                   Remove public read-only access to the bucket.

For example, to allow members of project: _project_462000008_ to have read-only access to bucket: _my_data_bucket_, you can use command:
```text
lo-access +r project_462000008 _my_data_bucket_
```
The access permissions are set similarly to the corresponding _segments bucket too.

Note, that bucket listing tools don't show the bucket names of other projects,
not even in cases were the project has read and/or write permissions to the bucket.

For example in this case a user, belonging to project _project_462000008_,
don't see the _my_data_bucket_ in the bucket list produced by command:
```text  
lo-list
```
but the user can still list the contents of this bucket with command:  
```text
lo-list my_data_bucket
```
And download objects from the bucket with lo-get.

lo-access manages the access permissions only in the project and bucket level.
Use **swift post** command for more sophisticated access control.

If you run _lo-access_ command for a bucket without any modification options,
it will print out the current settings of the bucket.


### Configuring your lo-commands

A users can modify the default settings of lo-commands by making a configuration file named as **.a_tools_conf** to their **home directory**.  In this file you can set default values for many of the functions that are defined with lo-put command options.

For example, if you are working mostly with files that would benefit from compression, you might like to use the _--compress_ option with lo-put. If you want this to be default setting you could create .a_tools_conf file
that contains setting:

```text
compression=1
```
Now command:
```text
lo-put my_data.b
```
will compress the data during the upload process (that would normally not be the case). However, you can still skip compression with option _--nc_.

```text
lo-put --nc my_data.b
```

You can check most commonly used settings from this sample [.a_tools_conf](https://github.com/CSCfi/lumio-cli-utils/edit/master/.a_tools_conf) file. Copy the sample file to your home directory and un-comment and define the variables you wish to use.
