[singularityce]: https://docs.sylabs.io/guides/latest/user-guide/
[apptainer]: http://apptainer.org/docs/user/main/index.html
[mpich-abi]: https://www.mpich.org/abi/
[permedcoe-mpi]: https://permedcoe.github.io/mpi-in-container
[easybuild-install]: ../../software/installing/easybuild.md
[containers-install]: ../../software/containers/singularity.md
[data-storage-options]: ../../storage/index.md

# Container jobs

LUMI provides access to a `singularity` runtime for running applications in
software containers. Currently, there are two major providers of the
`singularity` runtime, namely [Singularity CE][singularityce] and
[Apptainer][apptainer], with the latter being a fork of the former. For most
cases, these should be fully compatible. LUMI provides the `singularity` runtime
included in the HPE Cray Operating System (a SUSE Linux based OS) running on
LUMI - no modules need to be loaded to use `singularity` on LUMI. You can
always check the version of singularity using the command `singularity
--version`.

See the [Apptainer/Singularity containers install page][containers-install] for
details about creating LUMI compatible software containers.

## The basics of running a container on LUMI

Applications in a container may be run by combining Slurm commands with
Singularity commands, e.g., to get the version of Ubuntu running in a container
stored as "ubuntu_22.04.sif", we may use `srun` to execute the `singularity`
container

```bash
$ srun --partition=<partition> --account=<account> singularity exec ubuntu_21.04.sif cat /etc/os-release
```

which prints something along the lines of

```text
PRETTY_NAME="Ubuntu 22.04.1 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.1 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=jammy
```

### Binding network file systems in the container

By default, the [network file system partitions][data-storage-options], such as
`/scratch` or `/project` are not accessible from the within the container. To
make them available, they need to be explicitly bound by passing the
`-B/--bind` command line option to `singularity exec/run`. For instance

```bash
$ srun --partition=<partition> --account=<project_name> singularity exec -B /scratch/<project_name> ubuntu_21.04.sif ls /scratch/<account>
```

!!! warning
    Since project folder paths like `/scratch/<project_name>` and
    `/project/<project_name>` are symlinks on LUMI, you must bind these full
    paths to make them available in the container. Simply binding `/scratch` or
    `/project` will not work.

## Running containerized MPI applications

Running MPI applications in a container requires that you either bind the host
MPI (the MPI stack provided as part of the software stack available on the
compute node) or install a LUMI compatible MPI stack in the container.

!!! warning
    For MPI-enabled containers, the application inside the container must be
    dynamically linked to an MPI version that is [ABI-compatible][mpich-abi]
    with the host MPI.

### Using the host MPI

To properly make use of LUMI's high-speed network, it is necessary to
mount a few host system directories inside the container and set
`LD_LIBRARY_PATH` so that the necessary dynamic libraries are available at run
time. This way, the host's MPI stack replaces the MPI installed in the container image.

All the necessary components are available in a module that can be installed
by the user via [EasyBuild][easybuild-install]

```bash
$ module load LUMI partition/<lumi-partition> EasyBuild-user
$ eb singularity-bindings-system-cpeGNU-<toolchain-version>.eb -r
```

Running e.g. the [OSU point-to-point bandwidth test
container](../../software/containers/singularity.md#building-containers-on-local-hardware)
can then be done using

```bash
$ module load singularity-bindings
$ srun --partition=<partition> --account=<account> --nodes=2 singularity run mpi_osu.sif
```

which gives the bandwidth measured for different message sizes, i.e., something
along the lines of

```text
# OSU MPI Bandwidth Test v5.3.2
# Size      Bandwidth (MB/s)
1                       3.00
2                       6.01
4                      12.26
8                      24.53
16                     49.83
32                     97.97
64                    192.37
128                   379.80
256                   716.64
512                  1386.52
1024                 2615.18
2048                 4605.69
4096                 6897.21
8192                 9447.54
16384               10694.19
32768               11419.39
65536               11802.31
131072              11997.96
262144              12100.20
524288              12162.28
1048576             12207.27
2097152             12230.66
4194304             12242.46
```

### Using the container MPI

MPI applications can also be run using an MPI stack installed in the container.
To do so, Slurm needs to be instructed to use the PMI-2 process management
interface by passing `--mpi=pmi2` to `srun`, e.g.

```bash
$ srun --partition=<partition> --account=<account> --mpi=pmi2 --nodes=2 singularity run mpi_osu.sif
```

which produces an output along the lines of

```text
# OSU MPI Bandwidth Test v5.3.2
# Size      Bandwidth (MB/s)
1                       0.50
2                       1.61
4                       3.57
8                       6.54
16                      9.65
32                     18.04
64                     35.27
128                    67.76
256                    91.12
512                   221.09
1024                  278.88
2048                  471.54
4096                  917.02
8192                 1160.74
16384                1223.41
32768                1397.97
65536                1452.23
131072               2373.07
262144               2104.56
524288               2316.71
1048576              2478.30
2097152              2481.68
4194304              2380.51
```

Note that this approach gives lower bandwidths, especially for the larger
message sizes, than is the case when using the host MPI. In general, the
performance obtained from using the container MPI might be quite low compared
to the results obtained when using the host's MPI. For a more in-depth
discussion about MPI in containers, we suggest that you read this
[introduction to MPI in containers][permedcoe-mpi].
