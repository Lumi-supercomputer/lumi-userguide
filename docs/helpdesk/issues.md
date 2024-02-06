<!-- ---
hide:
  - navigation
--- -->

# Known Issues

This page lists known issues on LUMI and any known workarounds.

## Job get stuck in `CG` state

The issue is linked to a missing component in the management software stack. 
We contacted HPE and are waiting for the problem to be fixed.

## Fortran MPI program fails to start

If Fortran based program with MPI fails to start with large number of nodes
(such as 512 nodes), add `export PMI_NO_PREINITIALIZE=y` to your batch script.     

## MPI job fails with `PMI ERROR`

To avoid job startup failures with `[unset]:_pmi_set_af_in_use:PMI ERROR`, add 
`export PMI_SHARED_SECRET=""` line to your batch script.

## Job out-of-memory issues in `standard` partition

Some nodes of standard partition are leaking memory over time. A fix to detect these nodes (to restart/clean them) is on its way, but meanwhile one can use a workaround to specify the memory required per node to something that should be available. Use e.g. `--mem=225G` in your slurm script.

## Job crashes because of a faulty node

_When you run into an issue that a job crash on LUMI could have caused by a faulty node, please remember first to question your code and the libraries that it uses.
 Out-of-memory messages do not always result from a system error. Also, note that segmentation violations are usually application or library errors that will not be solved by rebooting a node.

If you suspect that the job has crashed because of a faulty node:

- Check whether the node health check procedure has caught the crash and drained the node with the command:
  ```
  sinfo -R --nodes=$(sacct -n -j <jobid> --format=nodelist --json | jq -r ".jobs[0].steps[1].nodes.list | .[]" | paste -sd ',')
  ```
  Example:
  ```
  sinfo -R --nodes=$(sacct -n -j 123456 --format=nodelist --json | jq -r ".jobs[0].steps[1].nodes.list | .[]"  | paste -sd ',')
  ```

- Send a ticket to [LUMI service desk](https://lumi-supercomputer.eu/user-support/need-help/running/) identifying the job id, the error you got, and any other information you could provide to help find the source of the fault.

- If you want to re-run a job and have a list of nodes to exclude, check the health status of these nodes to see if you could include them again, rather than having an ever-increasing list of nodes to exclude.
  The command to check health of the nodes on your exclude list is:
  ```
  sinfo -R --nodes=<list_of_nodes>
  ```
  Example:
  ```
  sinfo -R --nodes=nid[005038,005270]
  ```
  Another example:
  ```
  sinfo -R --nodes=nid005038,nid005270
  ```

- You might also want to check if a node has been booted since the last time it gave an error. Command to do this is:
  ```
  scontrol show node <list_of_nodes> | grep "NodeName\|BootTime" | awk '{print $1}'
  ```

- Also, note that all errors are not due to problems with nodes as such, but might have to do with network issues.









 

