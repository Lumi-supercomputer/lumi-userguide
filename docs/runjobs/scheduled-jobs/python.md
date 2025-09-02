[container-jobs]: ../../runjobs/scheduled-jobs/container-jobs.md
[python-install]: ../../software/installing/python.md
[job-arrays]: ../../runjobs/scheduled-jobs/throughput.md

# Python scheduled jobs

Here we present examples of running scheduled
[Python](http://python.org/) jobs.

As we describe in [Installing Python packages][python-install], there are various recommended ways to install Python packages, and the SLURM batch script will depend on the installed environment.

## Cray Python serial job
Below is an example job script for a serial application using the cray-python EasyBuild installation. We assume here that the venv `your-venv` is located in the current working directory and that it is small in terms of number of files.

```bash
#!/bin/bash -l
#SBATCH --job-name=examplejob   # Job name
#SBATCH --output=examplejob.o%j # Name of stdout output file
#SBATCH --error=examplejob.e%j  # Name of stderr error file
#SBATCH --partition=small       # Partition name
#SBATCH --ntasks=1              # One task (process)
#SBATCH --time=00:15:00         # Run time (hh:mm:ss)
#SBATCH --account=project_<id>  # Project for billing

module load cray-python
# source your-venv/bin/activate

python3 your_application.py
```

## Container Python MPI job
Running MPI jobs in Python can quickly run out of hand because all MPI processes executes all the imports and simultaneously load related files from memory. This tends to cause huge loads on the LUMI filesystem. In the below example job script, we have mitigated these issues by using a pre-built container with python and mpi4py. Note that extending such containers with your own venv requires care to ensure the venv is installed inside the container, see e.g. [python-install] for more information.

```
#!/bin/bash -l
#SBATCH --job-name=examplejob   # Job name
#SBATCH --output=examplejob.o%j # Name of stdout output file
#SBATCH --error=examplejob.e%j  # Name of stderr error file
#SBATCH --partition=standard    # partition name
#SBATCH --nodes=2               # Total number of nodes 
#SBATCH --ntasks=256            # Total number of mpi tasks
#SBATCH --mem=224G              # Allocate 224GB memory on each node
#SBATCH --time=1-12:00:00       # Run time (d-hh:mm:ss)
#SBATCH --account=project_<id>  # Project for billing

# All commands must follow the #SBATCH directives
export CONTAINER=/appl/local/containers/sif-images/lumi-mpi4py-rocm-6.2.0-python-3.12-mpi4py-3.1.6.sif

# Launch MPI code 
srun singularity exec $CONTAINER python3 your_application.py # Use srun instead of mpirun or mpiexec
```

## Python Array job
Job arrays have already been described in details in [Job array][job-arrays], and this is particularly useful here since Python is often used to post-process data. In the example job script below, we submit an array of 10 jobs corresponding to 10 data files `data*.json` stored in arbitrary folder structure such as a structured tree

```
data/
├── partition1
│   └── data.json
├── partition2
│   └── data.json
...
```

or a flat structure

```
data/
├── data1.json
├── data2.json
...
```

The resulting output is stored next to the `data*.json`, where the star '\*' denoted a wildcard string of characters.

```bash
#!/bin/bash -l
#SBATCH --job-name=examplejob   # Job name
#SBATCH --partition=small       # Partition name
#SBATCH --ntasks=1              # One task (process)
#SBATCH --time=00:15:00         # Run time (hh:mm:ss)
#SBATCH --account=project_<id>  # Project for billing
#SBATCH --array=1-10            # Array tasks

module load cray-python

DATA=$(find "$PWD"/data -name "data*.json" | \
awk -v var=$SLURM_ARRAY_TASK_ID 'NR==var {print $1}')

N_DATA=$(find "$PWD"/data -name "data*.json" | wc -l)
echo "Submitting $SLURM_ARRAY_TASK_COUNT jobs out of $N_DATA data files"
FOLDER=$(dirname "$DATA")

srun --output="$FOLDER"/slurm-%j_$SLURM_ARRAY_TASK_ID.out \
     --error="$FOLDER"/slurm-%j_$SLURM_ARRAY_TASK_ID.err \
     python3 your_application.py $DATA
```

In this example we attempt to submit 10 jobs in the array, however this might not correspond to all of the eligible `data*.json` present. If less array jobs are requested than `data*.json` then they will be submitted in alphabetical order and others will be missing. On the other hand if more array jobs are requested than possible, and error will be produced.

In this example `your_application.py` takes the folder string as input, however an alternative approach would be to run `cd $FOLDER` before the `srun` command, and putting `your_application.py` next to the `data*.json`.
