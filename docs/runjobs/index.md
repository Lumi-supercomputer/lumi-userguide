# Overview

[software-overview]: ../software/index.md
[firststeps-loggingin]: ../firststeps/loggingin.md
[lumi-c]: ../hardware/lumic.md
[lumi-g]: ../hardware/lumig.md
[lumi-d]: ../hardware/lumid.md
[slurm-quickstart]: ../runjobs/scheduled-jobs/slurm-quickstart.md
[module-environment]: ../runjobs/lumi_env/Lmod_modules.md
[software-stacks]: ../runjobs/lumi_env/softwarestacks.md
[data-storage-options]: ../storage/index.md
[billing-policy]: ../runjobs/lumi_env/billing.md

---

Here you find general descriptions of how to run jobs on LUMI, i.e. how to run your scientific software using the job scheduler on LUMI.
In this section, you also find general information about the LUMI environment, as well as the LUMI web interface that you can use to run your applications on LUMI instead of traditionally using a terminal.
If you are looking for ways to install your software on LUMI or advice for a specific application, consult the [software section][software-overview] instead.

---

When you log in to LUMI, you get access to one of the
login nodes. These login nodes are shared by all users and are only intended
for simple management tasks, e.g.

- compiling software (but consider allocating a compute node for large build
  jobs)
- submitting and managing scheduled jobs
- moving data
- light pre- and postprocessing (a few cores / a few GB of memory)

All compute heavy tasks must be submitted through the job scheduler such that
they are run on the compute nodes in
[LUMI-G][lumi-g]/[LUMI-C][lumi-c]/[LUMI-D][lumi-d].

The job scheduler used on LUMI is Slurm.
To get started using Slurm on LUMI, read the [Slurm quickstart guide][slurm-quickstart].

!!! warning

    All tasks not adhering to the above fair use rules for the login nodes will
    be terminated without warning.

Also, you may want to familiarize yourself with the LUMI environment:

- Read the [module environment][module-environment] page to learn more about
how to use the module system on LUMI to find already installed software and to
manage your own software installations.
- Read the [software stacks][software-stacks] page to learn more about the
  software is already centrally installed on LUMI.
- Read the [data storage options][data-storage-options] page to learn more
  about where to store your data.
- Read the [billing policy][billing-policy] page to learn more about how you
  are billed for your use of LUMI.
