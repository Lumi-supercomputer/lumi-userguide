# Running Python jobs via Slurm

[python_gil]: https://wiki.python.org/moin/GlobalInterpreterLock
[embarrassingly_parallel]: https://en.wikipedia.org/wiki/Embarrassingly_parallel
[oversubscription]: https://scikit-learn.org/stable/computing/parallelism.html#oversubscription-spawning-too-many-threads
[dask]: https://dask.org/
[ray]: https://www.ray.io/
[mpi4py]: https://mpi4py.readthedocs.io/en/stable/

[slurm_quickstart]: ../../computing/jobs/slurm-quickstart.md
[batch_job-common_slurm_options]: ../../computing/jobs/batch-job.md#common-slurm-options
[high_throughput-slurm_job_arrays]: ../../computing/jobs/throughput.md#slurm-job-arrays
[lumi_c]: ../../computing/systems/lumic.md
[python_installation]: ../installing/python.md


In order to run a Python job on the compute nodes, you must submit the your job using the Slurm scheduler on LUMI. If you are unfamiliar with Slurm, we recommend that you read the [Slurm quickstart guide][slurm_quickstart] before reading the rest of this page. The following sections provide examples of Slurm batch scripts for simple serial and parallel Python jobs aimed at the [LUMI CPU partition][lumi_c]. In all of these examples, we assume that you are using an Apptainer/Singularity container that has `python "$@"` as its `%runscript`. If you are using one of the other [recommended ways to get access to Python on LUMI][python_installation], you must adjust the `srun` commands in the examples below accordingly.

## Serial Python jobs
To run a serial Python job, you must request one node with one task. That way Slurm will spawn one Python process on one compute node. An example of a Slurm batch script for a serial Python job that only makes use of one CPU core is:

```bash
#!/bin/bash
#SBATCH --job-name=<name_of_this_job>
#SBATCH --account=project_<your_project_number>
#SBATCH --partition=small
#SBATCH --time=00:10:00
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=1

PROJECT_DIR=/project/project_<your_project_number>
CONTAINER=$PROJECT_DIR/<your_project_container.sif>
PY_SCRIPT=$PROJECT_DIR/<your_python_script.py>

srun singularity run --bind $PROJECT_DIR $CONTAINER $PY_SCRIPT
```

??? warning "Remember to adjust the above example to your needs"
    - You must replace `<name_of_this_job>`, `<your_project_number>`, `<your_project_container.sif>`, and `<your_python_script.py>` with appropriate values.
    - Adjust the remaining `#SBATCH` options as needed.

??? info "Consider making your resource request more specific"
    Many options exist for making your Slurm resource request more specfic, e.g. by requesting a specific amount of memory. See the [lists of common Slurm options that are relevant for LUMI][BATCH_JOB-common_slurm_options] for more details.

## Scaling out Python jobs
Due to the [CPython Global Interpreter Lock (GIL)][python_gil], running parallel Python jobs usually entails running a combination of multiple Python processes and C-level threads, e.g. OpenMP threads. Here we provide examples of Slurm batch scripts for running [embarrassingly parallel][embarrassingly_parallel] Python jobs using multiple Python processes on one or more compute nodes. When using a combination of Python processes and C-level threads, care must be taken to [avoid oversubscription](#avoiding-oversubscription) as discussed below.

### Parallel Python on a single node
One way to run an embarrassingly parallel Python job utilizing multiple processes via Slurm is by letting Slurm spawn a single Python process with `--nodes=1` and `--tasks-per-node=1`, and have that process fork using tools from the Python standard library, e.g. the `concurrent.futures.ProcessPoolExecutor`. One may then use the environment variable `SLURM_CPUS_PER_TASK` to get the requested `--cpus-per-task` to determine the number of processes to launch from within Python. Building on the [serial Python example above](#serial-python-jobs), the only needed change to the batch script is to specify the required `--cpus-per-task`:

```bash
#!/bin/bash
#SBATCH --job-name=<name_of_this_job>
#SBATCH --account=project_<your_project_number>
#SBATCH --partition=small
#SBATCH --time=00:10:00
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=4

PROJECT_DIR=/project/project_<your_project_number>
CONTAINER=$PROJECT_DIR/<your_project_container.sif>
PY_SCRIPT=$PROJECT_DIR/<your_python_script.py>

srun singularity run --bind $PROJECT_DIR $CONTAINER $PY_SCRIPT
```

Then `<your_python_script.py>` may use the `SLURM_CPUS_PER_TASK` environment variable to control the number of spawned Python processes, e.g. something like:

```python
from concurrent.futures import ProcessPoolExecutor
import os


def add_ab(a, b):
    return a + b


# 1. Get the number of processes to launch
num_processors = int(os.environ['SLURM_CPUS_PER_TASK'])

# 2. Launch processes and do computations
with ProcessPoolExecutor(max_workers=num_processors) as pool:
    sums = pool.map(add_ab, range(10), range(10, 20))

print([s for s in sums])
```

### Parallel Python on multiple nodes
One way to run an embarrassingly parallel Python job on multiple compute nodes via Slurm is by leveraging [Slurm job arrays][high_throughput-slurm_job_arrays]. When the job is launched as a job array with `--nodes=1` and `--tasks-per-node=1`, Slurm spawns a Python process on separate compute nodes for each array index in the resource request submitted to Slurm. Each of these array tasks have access to the `SLURM_ARRAY_TASK_ID` environment variable that may be used to select the work to be done as part of that task. Building on the [single node parallel Python example above](#parallel-python-on-a-single-node), the only needed change to the batch script is to specify the `--array` option:

```bash
#!/bin/bash
#SBATCH --job-name=<name_of_this_job>
#SBATCH --account=project_<your_project_number>
#SBATCH --partition=small
#SBATCH --time=00:10:00
#SBATCH --array=0-4
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=128

PROJECT_DIR=/project/project_<your_project_number>
CONTAINER=$PROJECT_DIR/<your_project_container.sif>
PY_SCRIPT=$PROJECT_DIR/<your_python_script.py>

srun singularity run --bind $PROJECT_DIR $CONTAINER $PY_SCRIPT
```

Then `<your_python_script.py>` may use the `SLURM_ARRAY_TASK_ID` environment variable to select the part of the job to run on a given compute node, e.g. something like:

```python
import os

import numpy as np

# 1. Select the part of the job to run in this array task
jobs_N = {  # Map SLURM_ARRAY_TASK_ID to N
    '0': 1024,
    '1': 2048,
    '2': 4096,
    '3': 8192,
    '4': 16384
}
N = jobs_N[os.environ['SLURM_ARRAY_TASK_ID']]

# 2. Do the computations
rng = np.random.default_rng(seed=6021)
A = rng.normal(size=(N, N))
B = rng.normal(size=(N, N))
C = A @ B

print(C.shape)
```

In the example above, five matrix multiplications of different sizes are computed in separate array tasks, i.e. on different compute nodes. The matrix multiplication is parallelized to use all 128 CPU cores (note the`--cpus-per-task=128`) on each node using C-level threads (assuming `numpy` has been compiled to use C-level threads for parallelizing matrix multiplications).

The job array approach to scaling to multiple nodes may be combined with the [single node parallel Python example above](#parallel-python-on-a-single-node) to control scaling using Python processes both across multiple nodes and multiple CPU cores within each node.

### Avoiding oversubscription
In general, one should avoid spawning more Python processes and C-level threads than the number of CPU cores requested for the Slurm job. Spawning more Python processes and C-level threads than the number of available CPU cores is referred to as [oversubscription][oversubscription] which usually results in a significant performance penalty. Thus, oversubscription should be avoided.

Most Python packages attempt to infer the number of available CPU cores and use this as the default  when spawning Python processes or C-level threads, e.g. on the [LUMI CPU partition][lumi_c], the Python standard library `multiprocessing.cpu_count()` reports 256 (the number of SMT hardware threads per node) independently of the CPU core request to Slurm. Thus, if for instance one uses a `concurrent.futures.ProcessPoolExecutor`, as in the [single node parallel Python example above](#parallel-python-on-a-single-node), only with its default number of workers/processes, and use this process pool to compute a large set of matrix multiplications similarly to the [multi node parallel Python example above](#parallel-python-on-multiple-nodes), it will likely result in 256 Python processes each running 256 C-level threads competing for the 128 CPU cores, leading to massive oversubscription. Thus, the number of Python processes and C-level threads should always be specified manually.

The [single node parallel Python example above](#parallel-python-on-a-single-node) covers an example of how to specify the number of Python processes. The number of C-level threads may usually be specified by setting the `OMP_NUM_THREADS` environment variable in the Slurm batch script, e.g. something like:

```bash
#!/bin/bash
#SBATCH --job-name=<name_of_this_job>
#SBATCH --account=project_<your_project_number>
#SBATCH --partition=small
#SBATCH --time=00:10:00
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=128

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

PROJECT_DIR=/project/project_<your_project_number>
CONTAINER=$PROJECT_DIR/<your_project_container.sif>
PY_SCRIPT=$PROJECT_DIR/<your_python_script.py>

srun singularity run --bind $PROJECT_DIR $CONTAINER $PY_SCRIPT
```

In the above example it is assumed that only one Python process is spawned on the node. If for instance 4 Python processes are used, `OMP_NUM_THREADS` should be reduced by a factor of 4 to avoid oversubscription.

### Alternative solutions
The above examples have covered simple embarrassingly parallel Python jobs. For advanced jobs, in particular jobs requiring inter-process communication, we recommend that you look into [Dask][dask], [Ray][ray], or [mpi4py][mpi4py].