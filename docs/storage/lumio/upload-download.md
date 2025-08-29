# Simple upload and download


Since all project members are seen as one user in LUMI-O (one project = one account), one can not distinguish what bucket or object has been added by which project member. 
Especially if you have several members in your project, it is a good idea to name the buckets such that you can easily identify them as yours, like:

"Results_myusername" or "SimulationData_ElliExample"


Also, it's good to keep in mind that since all project members have the same rights to the data of the project in LUMI-O, one should remember that the other project members are also able to modify or delete the content that you have added, and this can't be changed or restricted. For important data, it's a good practice in any case to have backup elsewhere, and not only keep one copy in one location. 

First set the Access keys for your LUMI project as adviced in [Accessing LUMI-O](./auth-lumidata-eu.md). 



## Upload and download (in terminal on LUMI)

Once you have the credentials created, run the following commands:

```
module load lumio
lumio-conf
```

Now you are able to use e.g. `rclone` commands to interact with LUMI-O. To list the buckets that have been created in LUMI-O for your project, run the following command:

```
rclone lsd lumi-46XXXXXXX-private:   #Replace 46XXXXXXX with your LUMI project number
```

The command above lists all the buckets for this LUMI project in LUMI-O. If no one from your project has uploaded content to LUMI-O so far, the output is empty. 

The following command creates a new bucket with the name _mynewbucketname_myusername_ :

```
rclone mkdir lumi-46XXXXXXX-private:mynewbucketname_myusername
```

It's in general a good idea to name a bucket such that you will remember that it's your bucket, especially if there are several members in your project. Also this helps the other members in your project to identify that this bucket is yours. 

You can download a file (e.g. mydatafile.txt) from LUMI filesystem to this bucket with:

```
rclone copy mydatafile.txt lumi-46XXXXXXX-private:mynewbucketname_myusername
```

To see that your datafile is now an object in your bucket, you can list the objects in the bucket with the command:

```
rclone ls lumi-46XXXXXXX-private:mynewbucketname_myusername/   
```

Downloading data from LUMI-O to LUMI works in a similar manner:

```
rclone copy lumi-46XXXXXXX-private:mynewbucketname_myusername/mydatafile.txt .
```

This is not the most clever example, since it just downloads the same datafile back to LUMI. Notice that rclone now overwrites the existing data file in LUMI filesystem. 

To download the data of the object 'mydatafile.txt' to a different file in LUMI filesystem, we can tell rclone to rename it e.g. as `mydatafile2.txt` with the following command (notice that now we need to use the `copyto` option with the command):

```
rclone copyto lumi-46XXXXXXX-private:mynewbucketname_myusername/mydatafile.txt ./mydatafile2.txt
```

The `copyto` command allows creating a new file with a different name, in which the content of 'mydatafile.txt' object is now downloaded from LUMI-O. 


Read more about what can be done with rclone e.g. from the [Managing data](./clients-general.md) section or from the rclone manual.


For more examples, see also the lecture and exercises about LUMI-O of the latest LUMI intro training from the [training materials](https://lumi-supercomputer.github.io/LUMI-training-materials/). 




