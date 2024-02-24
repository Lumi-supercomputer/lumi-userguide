# Array Jobs

Slurm job arrays provide a way to submit a large number of independent jobs.
When a job array script is submitted, a specified number of array tasks are
created from the batch script. A batch script for such an array job may look
like this:

``` bash
#!/bin/bash
#SBATCH --array=1-16
#SBATCH --output=array_%A_%a.out
#SBATCH --error=array_%A_%a.err
#SBATCH --time=01:00:00
#SBATCH --ntasks=1
#SBATCH --mem=4G

# Print the task index.
echo "My SLURM_ARRAY_TASK_ID: " $SLURM_ARRAY_TASK_ID

srun ./myapp --input input_data_${SLURM_ARRAY_TASK_ID}.inp
```

In this example 16 array tasks will be launched (`--array=1-16`). These tasks
will be copies of the batch script: in our example, each array task will be
allocated one task and 4 Gb of memory. The `SLURM_ARRAY_TASK_ID` environment
variable identifies each array task uniquely. In the example, we use this
variable to provide different input files for each of the array tasks.

If you want to reuse the same batch script for different array ranges, you can
omit the `--array` directive in the batch script and instead specify the range
when you submit your job.

```bash
$ sbatch --array=1-16 job.script
```

## Defining the array range

There are several ways to define the range of the index values for a job array:

```bash
# Job array with tasks index values from 0 to 15
#SBATCH --array=0-15

# Job array with tasks index values 1, 2, 9, 22 and 31
#SBATCH --array=1,2,9,22,31

# Job array with tasks index values 1, 3, 5 and 7
#SBATCH --array=1-7:2

# Job array with tasks index values 1, 3, 5, 7 and 20
#SBATCH --array=1-7:2,20
```

You can also specify the maximum number of simultaneously running tasks using
the `%` sign, e.g.

```bash
#SBATCH --array=0-15%4
```

In this example, the maximum number of array tasks running simultaneously will
be limited to 4.

## Managing job array tasks

Use the `squeue` command to examine the state of your job array. The still
pending array tasks are shown as one entry while the running ones are shown as
individual entries with their job IDs taking the form `<jobid>_<arrayindex>`.

```bash
$ squeue --me
  JOBID   PARTITION     NAME     USER  ST       TIME  NODES NODELIST(REASON)
123456_[3-16] small  example lumi_usr  PD       0:00      1 (Resources)
123456_1      small  example lumi_usr   R       0:17      1 node-0124
123456_2      small  example lumi_usr   R       0:23      1 node-0125
```

If you wish to cancel some of the array tasks of a job array, you can use the
`scancel` command as with any other job. For example, to cancel array tasks
with indexes from 1 to 3 from job array 2021, use the following command

```bash
$ scancel 2021_[1-3]
```

which is equivalent to

```bash
$ scancel 2021_1 2021_2 2021_3
```

On the other hand, if you want to cancel the whole job array, only specifying
the job ID suffice.

```bash
$ scancel 2021
```

## Environment variables

In addition to the `SLURM_ARRAY_TASK_ID` variable discussed above, Slurm will
set additional environment variables that describe the job array. These
variables are summarized in the table below.

| Variable                 | Description                            |
|--------------------------|----------------------------------------|
| `SLURM_ARRAY_TASK_ID`    | Job array index value                  |
| `SLURM_ARRAY_TASK_COUNT` | Number of array tasks in the job array |
| `SLURM_ARRAY_TASK_MIN`   | Value of the highest job array index   |
| `SLURM_ARRAY_TASK_MAX`   | Value of the lowest job array index    |

## Full array job example

In this section, we give a full example of running the same program with 1000
different command line arguments, submitted as an array job.

The parameters to use may be stored in a file, 1000 lines long and named
`args.txt`. Each line in this file contains two parameters to be passed
to our program as command-line arguments. As an example, the first 4 lines of
this file may be

```bash
$ head -n 4 args.txt
  0.025 25.8
  0.125 30.8
  0.489 14.4
  0.861 78.7
```

In the context of a job array, we can extract the parameters for each of the
array tasks with the help of the `SLURM_ARRAY_TASK_ID` variable.
For example, the first parameter can be obtained as

```bash
param_a=$(cat args.txt | \
awk -v var=$SLURM_ARRAY_TASK_ID 'NR==var {print $1}')
```

where we use `awk` to extract the line corresponding to the index of the task
in the job array and extract the first field. The same can be done for the
second parameter by replacing `print $1` by `print $2`.

The complete batch script is presented below. We create a job array of 1000
tasks that uses 2 cores and 2 GB of memory per core (4 GB/task).

```bash
#!/bin/bash
#SBATCH --time=00:30:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=2G
#SBATCH --array=1-1000

# Will use 2 threads
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

# Get first argument
param_a=$(cat args.txt | \
awk -v var=$SLURM_ARRAY_TASK_ID 'NR==var {print $1}')

# Get second argument
param_b=$(cat args.txt | \
awk -v var=$SLURM_ARRAY_TASK_ID 'NR==var {print $2}')

./myapp -a $param_a -b $param_b \
        -i input_dir/input.inp \
        -o output_dir/output_${SLURM_ARRAY_TASK_ID}.out
```
