---
title: Computing - Overview
---

[connecting]: ./connecting.md
[modules]: modules.md
[Lmod_modules]: ./Lmod_modules.md
[softwarestacks]: ./softwarestacks.md
[lumic]: systems/lumic.md
[lumid]: systems/lumid.md
[slurm_quickstart]: jobs/slurm-quickstart.md
[partitions]: ./jobs/partitions.md
[batch_jobs]: ./jobs/batch-job.md
[binding]: ./jobs/distribution-binding.md
[throughput]: ./jobs/throughput.md
[interactive]: ./jobs/interactive.md
[storage]: ../storage/index.md
[getstarted]: ../firststeps/getstarted.md

## Connecting

Before connecting to LUMI, you need to generate an SSH key pair and upload your
public key to MyAccessID.

- [Follow the get started guide][getstarted]

You can do additional setup, like adding your key to an agent or setting
up a shortcut for LUMI in your SSH configuration.

- [Setup SSH for LUMI][connecting]

## Learn more about the hardware

In the first phase of the LUMI installation, LUMI-C, the CPU partition and
LUMI-D, the data analytics partition are installed. LUMI-C consists of 1536
compute nodes fitted with two last generation AMD EPYC "Milan" 64-core CPUs and 256 GiB of memory.

- [Learn more about the CPU nodes][lumic]

LUMI-D consists of 12 nodes either with a large memory or NVDIA RTX GPUs as well
as on node storage.

- [Learn more about the data analytics nodes][lumid]

## Setup your Environment

Software on LUMI can be accessed through modules. With the help of the `module`
command, you will be able to load and unload the desired compilers, tools and
libraries.

- [Read more about the module command][modules]
- [Read more about Lmod modules][Lmod_modules], relevant if you use the
  LUMI software stack from the next bullet.
- [Read more about the software stacks][softwarestacks]

## Running your Jobs

To get started with running your application on LUMI, you need to write a batch
jobs script and submit it to the scheduler and resource manager. LUMI uses Slurm
as the batch job system.

- [Get familiar with Slurm with the quick start guide][slurm_quickstart]
- [Learn more about the available Slurm queues][partitions]
- [Check out some example batch scripts][batch_jobs]
- [See how to run a job interactively][interactive]
- [See how to submit a large number of independent jobs][throughput]

## Storage

Please note that only the data analytics nodes have local storage, when running on the compute nodes in LUMI-C, the input and output data of your application must be stored in the scratch spaces of the parallel file systems.

- [Go to the storage overview][storage]
