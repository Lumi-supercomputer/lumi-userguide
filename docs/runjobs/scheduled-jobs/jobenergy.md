# Energy consumption of jobs 

With the following commands one can check _an estimate_ for the _energy consumption_ of their jobs:

For finished jobs:
```bash
sacct -j [jobID] -o ConsumedEnergy
```

For running jobs:
```bash
sstat -j [jobID] -o ConsumedEnergy
```

Please keep in mind that the results that one gets with these commands are only rough estimates, and only give some information of what the compute nodes consume when the jobs are run.

First of all, the results roughly make sense only for jobs that utilize a full node (i.e. when you have a full socket for yourself). 

Also, running the same job twice on different nodes might give different results, simply because there are variations between semiconductors. 

It's also good to keep in mind that it's not possible to measure what is the energy consumption from the slingshot network, and also storing the data consumes some energy, etc.
