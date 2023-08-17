# Installing Python packages

Including as much as possible from <https://github.com/Lumi-supercomputer/lumi-userguide/pull/24>

## Which installation method to use?

A comparison of options below. Including details from <https://github.com/DeiC-HPC/cotainr/issues/3>

### Generally recommended

*Use a container to handle (multiple) full python environment(s):*

- use an existing container, e.g. from a registry
- build an apptainer/singularity container locally
- build a container with a conda environment on LUMI using cotainr

### Conditionally recommended

*Only with very few extra packages:*

- cray-python module + pip virtual env on Lustre
- existing apptainer/singularity container + pip virtual env on Lustre

*A single full environment relying only on a single binary/script:*

- Tykky installation wrap of conda environment
- Tykky installation wrap of pip virtual env

*Use local organizations Python libraries:*

- Local CSC stack

### Not recommended

*Full installs directly to the Lustre file systems:*

- conda/pip environments
- OS python + pip virtual env
- Easybuild installs
- Spack installs
