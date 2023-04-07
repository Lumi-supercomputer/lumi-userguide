[lumi-c]: ../../hardware/lumic.md
[container-jobs]: ../../runjobs/scheduled-jobs/container-jobs.md

# Julia scheduled jobs

Here we present examples of running scheduled
[Julia](http://julialang.org/) jobs as a [container jobs][container-jobs].

Assuming you have a Julia Singularity image file `julia_latest.sif` (e.g.
created using `singularity pull docker://julia`), Julia can be executed
interactively on a single [LUMI-C][lumi-c] node with N threads by allocating N
CPU cores:

```bash
srun --pty --nodes=1 --ntasks-per-node=1 \
     --cpus-per-task=<N> --time=30 \
     --partition=<partition> --account=<account> \
      singularity run --env JULIA_NUM_THREADS=<N> julia_latest.sif
```

Running a parallel (multi process) Julia script, e.g. `my_parallel_script.jl`,
can be done on a single node with N parallel processes using:

```bash
srun --nodes=1 --ntasks-per-node=<N> \
     --cpus-per-task=1 --time=30 \
     --partition=<partition> --account=<account> \
     singularity exec julia_latest.sif julia -p <N> my_parallel_script.jl
```

Both multithreading and multiprocessing can be combined in the Slurm job
submission using the `--ntasks-per-node` (for a number of processes) and
`--cpus-per-task` (for a number of threads) options.

Multi node distributed execution requires a custom "ClusterManager" plugin for
integration with Slurm which requires a specific version of the Julia
container. The same applies to GPU enabled execution on the LUMI-G compute
nodes.
