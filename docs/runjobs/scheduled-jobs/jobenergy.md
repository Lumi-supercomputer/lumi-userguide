# Energy consumption


## Average energy consumption on LUMI

The simplest way to get an estimate of how much energy your project or jobs have been using is to utilize information of the average power consumption of the LUMI nodes that are available. 
The tables below present a weekly updating information of average energy consumptions of a LUMI-G and LUMI-C nodes.

The energy for one GPU-node-hour is the energy that one GPU node on LUMI-G has consumed in one hour, and similarily for LUMI-C. The values for energy have been calculated by dividing the total input power to the racks by the number of nodes that have been up (state either running or idle, i.e. consuming energy), and a weekly average has been taken from this data. The values contain the average energy usage of the nodes themselves, but also a part of the energy that the slingshot network requires. On the other hand these values don't contain the energy that e.g. the storage nodes or cooling of the machine take. <!-- On the other hand when talking about the energy usage of LUMI, one might also want to consider e.g. the fact that the excess heat from the machine is [transferred to the district heat network of the Kajaani city](https://www.lumi-supercomputer.eu/sustainable-future/). -->

The reporting for the weeks starts from midnight (UTC). The unit in the table in which the values for energy are given is megajoules (MJ).


<iframe src="https://metrics.hpc.csc.fi/grafana/d-solo/390b1d3d-0c70-4f32-8049-c1bf07b2c9ed/test-lumi-gpu-core-hour-weekly-avg-energy?orgId=1&from=1735689600000&to=1757931055845&timezone=utc&showCategory=Table&panelId=1&__feature.dashboardSceneSolo" width="510" height="300" frameborder="0"></iframe>


**Example**: One has run a job on `standard-g` partition on 4 nodes for 2 hours on 2nd August 2025, the energy consumption for one GPU-node-hour was 4.46 MJ. Approximate energy that the job consumed is:

```
4 nodes * 2 hours * 4.46 MJ / GPU-node-hour = ... MJ

```

**Example**: A project started on 1.8.2025. On first calendar week (28.7-3.8.2025) they run several jobs on LUMI-G. 

One can check e.g. with `sacct` how many GPU-node-hours the jobs of this project have used on weekly basis:

```
sacct ... project=project_... 
```

used 18 GPU-node-hours. The average energy for this utilization is:

```
18 * 4.46 MJ = ... MJ
```





<iframe src="https://metrics.hpc.csc.fi/grafana/d-solo/390b1d3d-0c70-4f32-8049-c1bf07b2c9ed/test-lumi-gpu-core-hour-weekly-avg-energy?orgId=1&from=1735689600000&to=1757931055845&timezone=utc&showCategory=Table&panelId=2&__feature.dashboardSceneSolo" width="510" height="300" frameborder="0"></iframe>


Example: One has run a job on `small` partition reserving 128 cores (the full node), and the job run for 3 days 1.9-3.9.2025, the approximate energy that the job used is:

```
1 node * 3 * 24 hours * 1.99 MJ / cpu-node-hour = ... MJ
```

Example:


## From Slurm counters for your specific jobs

### For individual jobs

With the following commands one can check _an estimate_ for the _energy consumption_ of their individual jobs:

For finished jobs:
```bash
sacct -j [jobID] -o ConsumedEnergy
```

For running jobs:
```bash
sstat -j [jobID] -o ConsumedEnergy
```

Please keep in mind that the results that one gets with these commands are not precise measures for the energy of your jobs, and only give some information of what the compute nodes consume when the jobs are run.

Firstly, the results only make sense for jobs that utilize a full node as it is not possible on LUMI to measure the power consumption of individual cores. Note that if you ask for an exclusive node (which is the default in the standard and standard-g partitions) but use only some of the cores, memory and/or GPUs, the other cores, memory and GPUs are still consuming some energy which will be included in the reported number.

Secondly, running the same job twice on different nodes might give different results, because of variability between chips which is significant on modern machines as chips aren't binned as much anynmore for power consumption and clock speeds as they used to be. Even the temperature of the cooling water entering the machine can influence power consumption.

Note also that it is not possible to measure the energy consumption of the Slingshot network or the storage operations. This is shared infrastructure and it is not possible to track how much each job contributes to their energy consumption. It is far from negligible though at the scale of a supercomputer.

### For the whole project

Getting the energy consumption for the whole project, is a bit more tricky. One can in priciple process the output of the `sacct` command with an `awk` command to sum up the reported energy consumption of all jobs that the project has run. In some cases the reported number for some jobs might be incorrect though, which has happened sometimes, and this might result the total energy consumption to be something way bigger than it really is. So you'll have to check manually if the numbers make sense and process manually if they don't.

An example of a sacct command that sums up the results for job energies starting from 24th October 2023, taking account all users that have run jobs in the example project 465000001 and gives the result in Joules:

```bash
echo "Energy consumed by project: $(sacct -S2023-10-24 -Aproject_465000001 --allusers -X -oConsumedEnergyRaw | awk '{sum+=$1;} END{print sum;}') Joules"
```

Please see, if the result makes sense. If you get something in the scale of 10^20 Joules, the result is clearly wrong. <!--The jobs after 16.6.2025 shouldn't anymore have results for energy that are absurdly huge. It's possible to still see results of zero for the energies of individual jobs for some LUMI-G nodes. --> It's possible (and more common) to also see results of zero for the energies of individual jobs for some LUMI-G nodes, which isn't a correct result either, and which is caused by problems with part of the LUMI-G nodes what it comes to correctly reporting the energy of jobs.



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

Please note again that these results are not very trustworthy and even irrelevant if nodes are not properly filled (and certainly irrelevant on shared nodes). You shouldn't be surprised if you see a 20% or 30% variation running the job again on a different day on a different set of nodes, even when using full nodes, because of the very nature of modern semiconductors and computers. Energy results only make sense when making proper statistics over a large number of similar runs. The energy consumption of a job is in no way a deterministic number and the full energy consumption cannot even be measured due to the shared interconnect and storage.
