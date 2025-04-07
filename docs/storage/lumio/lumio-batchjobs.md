# Using LUMI-O with batch jobs

...

See also the general guide for [how to run jobs on LUMI](../../runjobs/index.md). 



You can access the data in LUMI-O also via a batch job. 

Do the following commands _before_ lauching the batch job:

```
module load lumio
lumio-conf

```



The command `lumio-conf` results a user prompt. `-k` flag is not used with lumio-conf. 

Actual path for lumio-conf:
/appl/lumi/SW/system/EB/lumio/2.0.0/bin/lumio-conf