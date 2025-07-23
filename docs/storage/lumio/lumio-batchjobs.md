# Using LUMI-O with batch jobs


You can access the data in LUMI-O also inside a batch job.

Before launching the batch job, you should have a valid configuration for LUMI-O access. 



```
module load lumio
lumio-conf
```

Also you need to make sure that the [access keys](./auth-lumidata-eu.md#create-lumi-o-credentials) are valid for long enough, otherwise connecting to LUMI-O will fail. 


```
#Batch job things

#do something e.g. with rclone, e.g. download data:
rclone copy lumi-46YXXXXXX-private:mybucket/mydata.txt ./

#do your analysis


#do something, e.g. copy the modified data to LUMI-O:
rclone copy ./mydata2.txt lumi-46YXXXXXX-private:mybucket
```


