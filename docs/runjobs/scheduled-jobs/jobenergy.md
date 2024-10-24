# Energy consumption of jobs 

## For individual jobs

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

## For the whole project

To get an energy consumption for a whole project, this is a bit more tricky. One can _in priciple_ use a `sacct` command for this which sums up the results for consumed energies of all jobs that the project has run. In some cases the energies for individual job energies might be incorrect though, which has happened sometimes, and this might result the total energy consumption to be something way bigger than it would really be. One would need to check themselves if the result for the total energy consumption of the project makes any sense. 

An example of a sacct command that sums up the results for job energies starting from 24th October 2023, taking account all users that have run jobs in the example project 465000001 and gives the result in Joules:

```bash
(sacct -S2023-10-24 -Aproject_465000001 --allusers -X -oConsumedEnergyRaw | awk '{sum+=$1;} END{print sum;}') Joules"
```

Please see, if the result makes sense. If you get something in the scale of 10^20 Joules, the result is clearly wrong. 

You can check and compare the results for energies of the individual jobs e.g. with the sacct command:

```bash
sacct -S2023-10-24 -Aproject_465000001 --allusers -X -oJobid,partition,Start,End,ConsumedEnergyRaw
```

This prints out the jobid, partition on which the job was run, start and end times of the job, and the consumed energy in Joules. You can compare the energies consumed by the jobs, and if there's something that clearly stands out as wrong, you can just ignore that result or cut it out. This can be done rather easily e.g. by printing the output of the previous command to a file, manually deleting the lines that contain clearly wrong results for energies, and then summing up the job energies for that file. See below and example:

```bash
sacct -S2023-10-24 -Aproject_465000001 --allusers -X -oJobid,partition,Start,End,ConsumedEnergyRaw > consumedenergies.txt
```

Open the file with a text editor and delete the lines that contain weird results for job energies. Then, to sum up the 5th column (job energies), one can use e.g. the command:

```bash
echo "Energy consumed by project: $(cat consumedenergies.txt | awk '{sum+=$5;} END{print sum;}') Joules"
```

If relevant, please see also the [page for `sacct`](https://slurm.schedmd.com/sacct.html) in Slurm documentation for more options with `sacct`. 

Please notice that it also of course applies here what was stated earlier on this page about (for energies of individual jobs) the correctness of results for energy consumption, and that the result is not very trustworthy especially if there are many jobs that have run on the shared nodes partitions. 
