<!-- ---
hide:
  - navigation
--- -->

# Known Issues

This page lists known issues on LUMI and any known workarounds.

## Job get stuck in `CG` state

The issue is linked to a missing component in the management software stack. 
We contacted HPE and are waiting for the problem to be fixed.

## Fortan MPI program fails to start

If Fortran based program with MPI fails to start with large number of node (512 
nodes for instance), add `export PMI_NO_PREINITIALIZE=y` to your batch script.     

## MPI job fails with `PMI ERROR`

To avoid job startup failures with `[unset]:_pmi_set_af_in_use:PMI ERROR`, add 
`export PMI_SHARED_SECRET=""` line to your batch script.

## Job out-of-memory issues in `standard` partition

Some nodes of standard partition are losing memory over time. A fix to detect these nodes (to restart/clean them) is on its way, but meanwhile one can use a workaround to specify the memory required per node to something that should be available. Use e.g. `--mem=225G` in your slurm script.


