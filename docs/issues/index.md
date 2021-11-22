---
hide:
  - navigation
---

# Known Issues

This page lists known issues on LUMI and any known workarounds.

## Missing `/flash`

The fast scratch (`/flash`) is not visible from the login nodes. However it can
be accessed from the compute nodes. If you need to access data located on the 
flash from the login nodes you can do so via `/pfs/lustref1/flash/`.

## Job get stuck in `CG` state

The issue is linked to a missing component in the management software stack. 
We contacted HPE and are waiting for the problem to be fixed.