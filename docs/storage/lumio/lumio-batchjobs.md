# Using LUMI-O with batch jobs


You can access the data in LUMI-O also inside a batch job.


Before launching the batch job, run the following commands to open the connection to LUMI-O:

```
module load lumio
lumio-conf
```

It is good to run the `lumio-conf` command once already at this point, to make sure that everything works with the connection to LUMI-O.

Since `lumio-conf` results a command line prompt (LUMI project, LUMI-O [access keys](./auth-lumidata-eu.md#create-lumi-o-credentials)), it can't be used inside a batch job. To make sure that the connection to LUMI-O is open inside a batch job, you need to first set environment variables for the LUMI project ID and LUMI-O access keys, and then call the command in the form `lumio-conf --noninteractive` inside the batch job. 

Set the following environment variables:

```
export LUMIO_PROJECTID=<project_id>     # E.g. export LUMIO_PROJECTID=46YXXXXXX

export LUMIO_S3_ACCESS=<Access_key>     

export LUMIO_S3_SECRET=<Secret_key>     
```

If you want, you can now check the values of these variables with:

```
echo $LUMIO_PROJECTID

echo $LUMIO_S3_ACCESS

echo $LUMIO_S3_SECRET
```

Besides setting the variables, you need to make sure that the Access keys are valid for long enough, otherwise connecting to LUMI-O will fail. 

<!-->
The command `lumio-conf` results a user prompt. `-k` flag is not used with lumio-conf. Also `-f` does not seem to be needed.
The user prompt asks for the project number, the access key and the secret key. -->

In your batch job, you can then have something like the following:

```
#make sure connection to LUMI-O is open:
lumio-conf --noninteractive

#do something with rclone, e.g. download data:
rclone copy lumi-46YXXXXXX-private:mybucket/mydata.txt .

#do your analysis

#again make sure connection to LUMI-O is open:
lumio-conf --noninteractive

#do something, e.g. copy the modified data to LUMI-O:
rclone copy ./mydata2.txt lumi-46YXXXXXX-private:mybucket
```

<!--Actual path for lumio-conf:
/appl/lumi/SW/system/EB/lumio/2.0.0/bin/lumio-conf 

Can't execute it from there... Need to use just the lumio-conf command.
-->

