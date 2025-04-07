
# Using the Allas object storage on LUMI

<!-- Move to CSC docs? -->

This page guideline applies to the users of the Allas object storage, which is an object storage service similar to LUMI-O for the users of the Finnish national computing clusters.

This guide assumes that the user is already familiar with using Allas on the Finnish national clusters, and is only giving some LUMI specific details that make Allas access different from LUMI.

See also CSC documentation https://docs.csc.fi/data/Allas/allas_lumi/
(The page is not up to date what it comes to rclone remotes)


## Accessing Allas from LUMI

...

## Using Allas via batch jobs

The command `allas-conf` (or the actual path that this is an alias for) results a password prompt when given at the first time during the session, and also later in some cases. It's best to do the following actions _before_ launching your batch job:

```
module use /appl/local/csc/modulefiles
module load allas
allas-conf -k project_<CSC-project-number>
```

The option `-k` should keep the connection open for 8 hours (at least on Puhti and Mahti, haven't checked this on LUMI yet, but I assume it's the same) without prompting the user.
Your password is saved in an environment variable `$OS_PASSWORD`.

After this you should be able to use Allas via a batch job.
Your CSC project number is also saved in an environment variable `$OS_PROJECT_NAME`
You can check these e.g. with
```
echo $OS_PASSWORD
echo $OS_PROJECT_NAME
```


You can now have something following (e.g. with rclone) in your job script. The option `-f` is needed in the source command to skip some internal checks that are not compatible with batch jobs:

```
#make sure connection to Allas is open:
source /appl/local/csc/soft/cli/allas-cli-utils/allas_conf -f -k $OS_PROJECT_NAME

#do something with rclone, e.g. download data:
rclone copy allas:path/to/dataset/in/bucket ./

#do your analysis

#again make sure connection to Allas is open:
source /appl/local/csc/soft/cli/allas-cli-utils/allas_conf -f -k $OS_PROJECT_NAME

#copy the results data to a bucket in Allas:
rclone copyto mydatafile12 allas:/path/to/bucket
```

