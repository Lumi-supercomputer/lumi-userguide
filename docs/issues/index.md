---
hide:
  - navigation
---

# Known Issues

This page lists known issues on LUMI and any known workarounds.

## Job configuration rejected by Slurm

If you get an error message looking like these:

- `Requested node configuration is not available`
- `Memory specification can not be satisfied`

You need to specify the memory for your job: 

- if you submit your job to the `standard` partition or, for other partitions, 
  if you requested exclusive access to the node, then you can request all the
  memory on the node with `--mem=0`
- if you don't request exclusive access to the node set the value of `--mem`
  according to the needs of your job