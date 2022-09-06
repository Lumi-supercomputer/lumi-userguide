# Overview

[software-overview]: ../software/index.md
[firststeps-loggingin]: ../firststeps/loggingin.md
[lumi-c]: ../computing/systems/lumic.md
[lumi-g]: ../computing/systems/lumig.md
[lumi-d]: ../computing/systems/lumid.md
[slurm-quickstart]: ../computing/jobs/slurm-quickstart.md
[module-environment]: ../computing/Lmod_modules.md
[software-stacks]: ../computing/softwarestacks.md
[data-storage-options]: ../storage/storing-data.md
[billing-policy]: ../computing/jobs/billing.md


---
Here you find general descriptions of how to run jobs on LUMI, i.e. how to run
your scientific software using the job scheduler on LUMI. If you are looking
for ways to install your software on LUMI or advice for runing a specific
application, consult the [software section][software-overview] instead.

---

When you [log in to LUMI][firststeps-loggingin], you get access to one of the
login nodes. These login nodes are shared by all users and are only intended
for simple management tasks, e.g.

- compiling software (but consider allocating a compute node for large build
  jobs)
- submitting and managing scheduled jobs
- moving data
- light pre- and postprocessing (a few cores / a few GB of memory)

All compute heavy tasks must be submitted through the job scheduler such that
they are run on the compute nodes in
[LUMI-G][lumi-g]/[LUMI-C][lumi-c]/[LUMI-D][lumi-d]. The job scheduler used on
LUMI is Slurm. To get started using Slurm on LUMI read the [Slurm quickstart
guide][slurm-quickstart]. Also, you may want to familiarize yourself with the
LUMI Environment, i.e. the [module environment][module-environment] and
[software stacks][software-stacks] as well as the [data storage
options][data-storage-options] and [billing policy][billing-policy].

!!! warning

    All tasks not adhering to the above fair use rules for the login nodes will
    be terminated without warning.
