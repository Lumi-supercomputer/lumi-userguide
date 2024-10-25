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

Firstly, the results only make sense for jobs that utilize a full node as it is not possible on LUMI to measure the power consumption of individual cores. Note that if you ask for an exclusive node (which is the default in the standard and standard-g partitions) but use only some of the cores, memory and/or GPUs, the other cores, memory and GPUs are still consuming some energy which will be included in the reported number.

Secondly, running the same job twice on different nodes might give different results, because of variability between chips which is significant on modern machines as chips aren't binned as much anynmore for power consumption and clock speeds as they used to be. Even the temperature of the cooling water entering the machine can influence power consumption.

Note also that it is not possible to measure the energy consumption of the Slingshot network or the storage operations. This is shared infrastructure and it is not possible to track how much each job contributes to their energy consumption. It is far from negligible though at the scale of a supercomputer.

## For the whole project

Getting the energy consumption for the whole project, is a bit more tricky. One can in priciple process the output of the `sacct` command with an `awk` command to sum up the reported energy consumption of all jobs that the project has run. In some cases the reported number for some jobs might be incorrect though, which has happened sometimes, and this might result the total energy consumption to be something way bigger than it really is. So you'll have to check manually if the numbers make sense and process manually if they don't.

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

Open the file with a text editor and delete the lines that contain weird results for job energies. Then, to sum up the 5th column (job energies), one can, e.g.,  use the command:

```bash
echo "Energy consumed by project: $(cat consumedenergies.txt | awk '{sum+=$5;} END{print sum;}') Joules"
```

If relevant, please see also the [page for `sacct`](https://slurm.schedmd.com/sacct.html) in Slurm documentation for more options with `sacct`. 

Please note again that the results are not very trustworthy and even irrelevant if nodes are not properly filled (and certainly irrelevant on shared nodes). You shouldn't be surprised if you see a 20% or 30% variation running the job again on a different day on a different set of nodes, even when using full nodes. There is no need to send a ticket about this to the LUMI User Support Team; it is the very nature of modern semiconductors and computers. Energy results only make sense when making proper statistics over a large number of similar runs. The energy consumption of a job is in no way a deterministic number and the full energy consumption cannot even be measured due to the shared interconnect and storage. And we can also do nothing about the occasional number that is completely off.