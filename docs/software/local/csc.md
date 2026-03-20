# CSC installed software collection

!!! info "Note"
    Software installed under `/appl/local` are maintained by the respective
    local organizations.

Load the CSC module tree into use with:

```bash
module use /appl/local/csc/modulefiles
```

Alternatively, there is also a module that you can load to accomplish the
same:

```bash
module load Local-CSC
```
!!! Tip "Quick overview"
    To get a quick overview of the available modules and their versions, simply
    use 
    ```bash
    $ module avail
    ```
    after enabling the CSC modules, and the list will show a
    "Local software collection managed by CSC" section.


Available software and tools:

*   [Allas](https://docs.csc.fi/data/Allas/allas_lumi/)
    (only for the Finnish national system users)
*   [Amber](https://docs.csc.fi/apps/amber/#lumi)
*   [ANSYS](https://docs.csc.fi/apps/ansys/)
*   [CP2K](https://docs.csc.fi/apps/cp2k/#lumi_1)
*   [Elmer](https://docs.csc.fi/apps/elmer/#lumi)
*   [Geoconda](https://docs.csc.fi/apps/geoconda/)
*   [GRASS GIS](https://docs.csc.fi/apps/grass/) - Only indirectly via [QGIS](https://docs.csc.fi/apps/qgis/)
*   [GROMACS](https://docs.csc.fi/apps/gromacs/#lumi_1)
*   [HADDOCK3](https://docs.csc.fi/apps/haddock3/#lumi_1)
*   [HyperQueue](https://docs.csc.fi/apps/hyperqueue/)
*   [Julia](https://docs.csc.fi/apps/julia/#lumi)
*   [LAMMPS](https://docs.csc.fi/apps/lammps/#lumi)
*   [MATLAB](https://docs.csc.fi/apps/matlab/#lumi)
*   [NAMD](https://docs.csc.fi/apps/namd/#lumi-g-1-gcd)
*   [NMRLipids](https://docs.csc.fi/apps/nmrlipids/#lumi) data set
*   [Nextflow](https://docs.csc.fi/apps/nextflow/)
*   [OpenFOAM](https://docs.csc.fi/apps/openfoam/)
*   [PALM](https://docs.csc.fi/apps/palm/)
*   [PLUMED](https://docs.csc.fi/apps/plumed/) (Though LUMI is not mentioned on the page)
*   [PDAL](https://docs.csc.fi/apps/pdal/) - Only indirectly via [QGIS](https://docs.csc.fi/apps/qgis/)
*   [QGIS](https://docs.csc.fi/apps/qgis/)
*   [Quantum ESPRESSO](https://docs.csc.fi/apps/qe/#lumi-c)
*   [SAGA GIS](https://docs.csc.fi/apps/saga-gis/) - Only indirectly via [QGIS](https://docs.csc.fi/apps/qgis/)
*   [STAR-CCM+](https://docs.csc.fi/apps/starccm%2B/)

The following packages are no longer updated by CSC but will be managed by the
LUMI AI Factory and documented [on their pages](../../laif/software/ai-environment.md):

*   [JAX](https://docs.csc.fi/apps/jax/)
*   [PyTorch](https://docs.csc.fi/apps/pytorch/#lumi)
*   [TensorFlow](https://docs.csc.fi/apps/tensorflow/#lumi)

See also the [CSC list of software available on LUMI](https://docs.csc.fi/apps/by_availability/#lumi)
and the [CSC list of software available through the LUMI web interface](https://docs.csc.fi/apps/by_availability/#lumi-web-interface).

If you encounter any issues, don't hesitate to contact the
[LUMI User Support Team](https://lumi-supercomputer.eu/user-support/need-help/).
