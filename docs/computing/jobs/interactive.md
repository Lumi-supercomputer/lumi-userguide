# Interactive Job

Login nodes are not intendent for heavy computing if you want to do heavy
computing interactively, you can request a Slurm interactive session.

Interactive jobs allow a user to interact with applications on the compute 
nodes. With an interactive job, you request time and resources to work on a 
compute node directly, which is different to a batch job where you submit your 
job to a queue for later execution.

## Allocating Ressources

Allocation of ressource for an interactive job is done using the `salloc` 
command. For example, you can request 8 cores on 1 node for 1 hour.

```
srun --nodes=1 --cpus-per-task=8 --time=01:00:00 --pty bash
```