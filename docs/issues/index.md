---
hide:
  - navigation
---

# Known Issues

This page lists known issues on LUMI and any known workarounds.

## Job get stuck in `CG` state

The issue is linked to a missing component in the management software stack. 
We contacted HPE and are waiting for the problem to be fixed.

## Fortan MPI program fails to start

If Fortran based program with MPI fails to start on large partition of the system 
(512 nodes for instance) then add `export PMI_NO_PREINITIALIZE=y` line to jour 
batch script.      
