# Simple upload and download


Since all project members are seen as one user in LUMI-O (one project = one account), one can not distinguish what bucket or object has been added by which project member. 
Especially if you have several members in your project, it is a good idea to name the buckets such that you can easily identify them as yours, like:

"Results_myusername" or "SimulationData_ElliExample"


Also, it's good to keep in mind that since all project members have the same rights to the data of the project in LUMI-O, one should remember that the other project members are also able to modify or delete the content that you have added, and this can't be changed or restricted. For important data, it's a good practice in any case to have backup elsewhere, and not only keep one copy in one location. 

First set the Access keys for your LUMI project as adviced in [Accessing LUMI-O](./auth-lumidata-eu.md#create-lumi-o-credentials). 


## Upload and download in LUMI web interface

Datafile max size: 5 GB  #tobechecked



## Upload and download in terminal from LUMI login node

Open connection to LUMI-O:

```
module load lumio
lumio-conf
```

Now you are able to browse the content for this project in LUMI-O with the [client tools](./clients-general.md), e.g. 

```
rclone lsd lumi-46YXXXXXX-private:   #Replace 46YXXXXXX with your LUMI project number
```

The command above lists all the buckets for this LUMI project in LUMI-O. If no one from your project has used LUMI-O so far, there is no content yet. 

To create a new bucket:

```
rclone mkdir lumi-46YXXXXXX-private:mynewbucketname_myusername
```
creates a new bucket with a name "mynewbucketname_myusername". It's in general good to name a bucket such that you will remember that it's your bucket, especially if there are several members in your project. Also this helps the other members in your project to identify that this bucket is created by you.
You can download a file (e.g. mydatafile.txt) to this bucket with:

```
rclone copy mydatafile.txt lumi-46YXXXXXX-private:mynewbucketname_myusername
```

Downloading data from LUMI-O to LUMI works in a similar manner:

```
rclone copy lumi-46YXXXXXX-private:mynewbucketname_myusername/mydatafile.txt .
```

This is not the most clever example, since it just downloads the same datafile back to LUMI. Notice that rclone now overwrites the existing data file in LUMI filesystem, if the content has changed. 

To copy the data from 'mydatafile.txt' to a different file in LUMI filesystem, we can make a copy of it with:

```
rclone copyto lumi-46YXXXXXX-private:mynewbucketname_myusername/mydatafile.txt ./mydatafile2.txt
```

The `copyto` command allows creating a new file with a different name, in which the content of 'mydatafile.txt' is copied from LUMI-O. 


Read more about what can be done with rclone [here](./client-rclone.md).


For more examples, see also the lecture and exercises about LUMI-O of the latest LUMI intro training from the [training materials](https://lumi-supercomputer.github.io/LUMI-training-materials/). 




