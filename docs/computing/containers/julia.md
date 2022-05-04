# Running Julia within a container

Generic application containers can be easily run on the compute nodes. Here we use [Julia](http://julialang.org/) container, `julia` in the DockerHub, as an example of interactive run and batch submission. Julia can execute as both multithreaded and parallel application. It can be pulled with the command:
```bash
singularity pull docker://julia
```
Singularity file `julia_latest.sif` will be created. Julia can be executed interactively on a single LUMI-C node with N threads allocating N cpu cores:
```bash
srun --pty --nodes=1 --ntasks-per-node=1 --cpus-per-task=<N> --time=30 -p<partition> -A<account> singularity run --env JULIA_NUM_THREADS=<N> julia_latest.sif
```

Running with parallel (multiprocess) execution model requires specific Julia code, say in `my_parallel_script.jl` file. It can be executed with a batch submission on a single node with N parallel processes:
```bash
srun --nodes=1 --ntasks-per-node=<N> --cpus-per-task=1 --time=30 -p<partition> -A<account> singularity exec julia_latest.sif julia -p 20 my_parallel_script.jl
```
Both multithreading and multiprocessing can be combined with `--ntasks-per-node` (for a number o processes) and `--cpus-per-task` (for a number of threads) SLURM options.

Multinode, distributed execution would require custom "ClusterManager" plugin for integration with SLURM which will require specific version of the container. The same applies to GPU enabled execution on the LUMI-G compute nodes.
