# ParaView

!!! warning

    ParaView should be part of the central software stack when the data
    analytics and visualization partition (LUMI-D) is available. For the
    time being, this partition is not available and ParaView is only available
    as a user-installable EasyBuild recipe. Due to the LUMI-D unavailability
    only software (CPU) rendering is available.

ParaView is an open-source, multi-platform data analysis and visualization
application. ParaView users can quickly build visualizations to analyze their
data using qualitative and quantitative techniques. The data exploration can be
done interactively in 3D or programmatically using ParaView’s batch processing
capabilities.

ParaView was developed to analyze extremely large datasets using distributed
memory computing resources. It can be run on supercomputers to analyze datasets
of petascale size as well as on laptops for smaller data, has become an integral
tool in many national laboratories, universities and industry, and has won
several awards related to high performance computation.

- [ParaView website](https://www.paraview.org/)
- [ParaView tutorials](https://www.paraview.org/tutorials/)
- [ParaView documentation](https://docs.paraview.org/en/v5.10.1/index.html)

## Installation

ParaView is available as a user-installable EasyBuild recipe. This recipe will 
only compile the server components (`pvserver`, `pvbatch`, `pvpython`, ...).

Compilation of ParaView takes a long time. We present two options: 

- using 32 cores, on the login node, the entire compilation process takes more
  or less 1 hour 10 minutes but will not consume billing units
- using 128 cores, on a compute node is slightly faster, the entire compilation 
  process takes more or less 45 minutes but will use billing units 
  (96 core-hours).

=== "On a login node"

    To compile on the login node, first prepare your environment:

    ```bash
    module load LUMI/22.08
    module purge
    module load partition/C
    module load EasyBuild-user
    ```

    This setup, prepare your environment to compile a ParaView installation
    optimized for the compute node (`partition/C`). By default, ParaView will be
    installed in `$HOME/EasyBuild` and will only be accessible by you. If you 
    want to do an installation available to all the members of your project, set 
    the `EBU_USER_PREFIX` environment variable:

    ```bash
    export EBU_USER_PREFIX=/project/project_46XXXXXXX/EasyBuild
    module load EasyBuild-user
    ```

    where you have to change the `project_46XXXXXXX` value to your actual 
    project number. 
    
    The last step is to install ParaView with the command:

    ```bash
    eb --parallel=32 -r ParaView-5.10.1-cpeGNU-22.08.eb
    ```

=== "On the compute node"
    
    Below is a script to compile ParaView on a compute node. Copy the content of
    this script in a file named `build-paraview.sh`.

    ```bash title="build-paraview.sh"
    #!/bin/bash

    # !!! CHANGE ME !!!
    project=project_46XXXXXXX
    
    # Un-comment this export to install in your project directory
    # By default installation is done in $HOME/EasyBuild
    #export EBU_USER_PREFIX=/project/${project}/EasyBuild

    module load LUMI/22.08
    module purge
    module load partition/C
    module load EasyBuild-user

    # Compute nodes do not have internet access
    # As a consequence we first download all the
    # sources on the login node
    eb --stop=fetch -r ParaView-5.10.1-cpeGNU-22.08.eb

    echo "Submitting job"

    sbatch <<EOF
    #!/bin/bash
    #SBATCH --partition=small
    #SBATCH --account=${project}
    #SBATCH --job-name=paraview-build
    #SBATCH --time=01:00:00
    #SBATCH --nodes=1
    #SBATCH --mem=0
    #SBATCH --cpus-per-task=128

    module load LUMI/22.08
    module purge
    module load partition/C
    module load EasyBuild-user

    eb --parallel \${SLURM_CPUS_PER_TASK} -r \
      ParaView-5.10.1-cpeGNU-22.08.eb

    EOF

    echo "Done"
    ```

    Next, make the script executable and execute it.

    ```
    chmod +x ./build-paraview.sh
    ./build-paraview.sh
    ```

    A job will be submitted to a compute node. ParaView will be usable after 
    this job successfully complete.

!!! note

    The instruction presented above load the `partition/C` module to generate
    ParaView binaries optimized for the compute node. These binaries should run
    without any problem on the login nodes. The default partition module on the 
    login nodes is `partition/L` so, loading ParaView module from a login node
    is done by loading the following modules:

    ```
    module load LUMI/22.08
    module load partition/C
    module load ParaView
    ```

    while, from the compute node where `partition/C` is the default this is done
    by loading

    ```
    module load LUMI/22.08
    module load ParaView
    ```

## Usage

The intended usage of ParaView on LUMI is in a client-server configuration:

- the server runs on a login or a compute node on LUMI
- a matching client (same version) runs on your local machine
- all data processing and rendering are handled by the server

### Download and install the client

The first step is to install the ParaView client with the same version as the
server on your local machine. How to install the client is beyond the scope of 
this documentation. Generally speaking, it boils down to running the installer 
that you can download here:

- [MacOS (M1)](https://www.paraview.org/paraview-downloads/download.php?submit=Download&version=v5.10&type=binary&os=macOS&downloadFile=ParaView-5.10.1-MPI-OSX11.0-Python3.9-arm64.pkg)
- [MacOS (Intel)](https://www.paraview.org/paraview-downloads/download.php?submit=Download&version=v5.10&type=binary&os=macOS&downloadFile=ParaView-5.10.1-MPI-OSX10.13-Python3.9-x86_64.pkg)
- [Windows](https://www.paraview.org/paraview-downloads/download.php?submit=Download&version=v5.10&type=binary&os=Windows&downloadFile=ParaView-5.10.1-Windows-Python3.9-msvc2017-AMD64.exe)
- [Linux](https://www.paraview.org/paraview-downloads/download.php?submit=Download&version=v5.10&type=binary&os=Linux&downloadFile=ParaView-5.10.1-MPI-Linux-Python3.9-x86_64.tar.gz)

### Start the server on LUMI

!!! failure "Occasional failure on the small partition"

    When submitting a job to the small partition, the MPI initialization may
    fail with a "*Adress already in use*" message. Workaround is to exclude 
    the bad node when submitting the job with the `--exclude=nid00XXXX` option, 
    where `nid00XXXX` is the node where the failure occurs. You can exclude
    multiple nodes with commas separated a list: `--exclude=nid00XXXX, nid00YYYY`.

=== "On a compute node"

    One option to start a ParaView server on a compute node is use an 
    interactive session:

    ```
    module load LUMI/22.08
    module load partition/C
    module load ParaView

    srun --partition=small --account=project_46XXXXXXX \
         --ntasks=8 --mem=16G --time=01:00:00 \
         --pty pvserver
    ```

    Here we start a server on 8 processes and 16GB of memory. Don't forget to
    change the value `project_46XXXXXXX` to your project number. 
    
    Another option is to start the server in a batch job. Here is an example
    job script:

    ```bash title="start-pvserver.job"
    #!/bin/bash
    #SBATCH --job-name=paraview-server
    #SBATCH --account=project_46XXXXXXX
    #SBATCH --partition=small
    #SBATCH --ntasks=8 
    #SBATCH --mem=16G
    #SBATCH --time=01:00:00

    module load LUMI/22.08
    module load ParaView

    srun --unbuffered pvserver
    ```

    You can start the batch job by submitting it with `sbatch`

    ```
     $ sbatch start-pvserver.job
    Submitted batch job 123456
    ```

    Then in order to gather the information necessary to create the SSH tunnel
    (see nect section) we look at the content of the output file.

    ```
     $ squeue --me
      JOBID PARTITION     NAME     USER ST  TIME  NODES NODELIST(REASON)
     123456     small paraview  lumiusr  R  0:10      1 nid002092
     $ cat slurm-123456.out
    Waiting for client...
    Connection URL: cs://nid002092:11111
    Accepting connection(s): nid002092:11111
    ```

=== "On a login node"

    The ParaView server (`pvserver`) can be run on the login node but you will be
    limited to only one process: running the server on the login node **is only 
    suitable for small dataset**.

    ```
    module load LUMI/22.08
    module load partition/C
    module load ParaView

    pvserver --no-mpi
    ```

    Once the server has started you will see a message looking like this:

    ```
    Waiting for client...
    Connection URL: cs://uan02:11111
    Accepting connection(s): uan02:11111
    ```

    This message is important because it provide the information necessary to
    create the SSH tunnel as described in the next section.

### Setup the SSH tunnel

Once the server is started, we need to create an SSH tunnel from your local 
machine to the node where the server is running. Here we assume you have an
entry for LUMI in your `.ssh/config` named `lumi`.

To create the tunnel, you have to run a command **on your local machine** that 
looks like:

```
ssh -N -L <port>:<host>:<port> lumi
```

where `<host>` is the node on which the server is running, i.e., `uanXX` if you 
started the server on a login node or `nid00XXXX` if it runs on a compute node.
For example, if at server startup the output was

```
Waiting for client...
Connection URL: cs://nid002211:11111
Accepting connection(s): nid002211:11111
```

then, the value of `<port>` is `11111` and the value of `<host>` is `nid002211`
so that the command to create the SSH tunnel will be

```
ssh -N -L 11111:nid002211:11111 lumi
```

### Connect to the server

!!! failure "Potential connection failure"

    Sometimes connection to the server fails when the server is executed from a
    login node. See the information 
    [at the end of this section](#login-node-workaround)
    for more information and a workaround.

The last step is to connect the client running on your local machine to the 
server running on LUMI. To this end, select *File* &#x2192; *Connect...*. You 
should already have a configuration suitable configuration by default, i.e.,
a configuration to connect to a server at address `cs://localhost:11111`. If 
indeed this is the case, and that `11111` is the port you use, select this 
configuration and click *Connect*. The instruction that follow are here in case
you need to create a new configuration.

First, go to *File* &#x2192; *Connect...* and click *Add Server*.

<figure>
  <img 
    src="../../../assets/images/paraview-step1.png"
    width="900"
    alt="ParaView connection step 1"
  >
</figure>

Choose a name for the configuration, for example, *LUMI*, then:

- for the server type choose *Client/Server*
- for the host *localhost*
- for the port, use the value provided at server startup. 

Next, click *Configure*. In the next dialog box, choose *Manual* for the startup
type then click *Save*.

<figure>
  <img 
    src="../../../assets/images/paraview-step2.png"
    width="450"
    alt="ParaView connection step 2"
  >
</figure>

To connect, select the newly created configuration and click *Connect*.

<figure>
  <img 
    src="../../../assets/images/paraview-step3.png"
    width="450"
    alt="ParaView connection step 3"
  >
</figure>

The client should now be connected to the server and the server should print 
*Client connected*. Another way to check if the connection is successful is 
to look at the connection information visible from the menu *Help* &#x2192; 
*About* and selecting the *Connection Information* tab.

<figure>
  <img 
    src="../../../assets/images/paraview-connect-info.png"
    width="450"
    alt="ParaView connection information"
  >
</figure>

Now that the server is connected, all data processing and rendering are handled
by the server instead of the local client.

Disconnecting the client from the server is done via *File* &#x2192; 
*Disconnect...*. The server will exit when you disconnect, i.e., if you 
submitted a job, it should end. However, we recommended you to check that this
is indeed the case to avoid wasting your cpu-hours allocation. 

<span id="login-node-workaround"></span>

!!! failure "Potential connection failure"
    
    When running the server on the login node, the client may fail to connect
    with the following error message:
    
    ```
    Connection failed during handshake. vtkSocketCommunicator::GetVersion()
    returns different values on the two connecting processes
    (Current value: 100).
    ```

    Contrary to what this message seems to indicate, it is not a version 
    mismatch problem. The problem is that the host name is not fully qualified 
    domain name (FQDN) of the login node. A workaround is to use a FQDN of the
    login node instead of `uanXX` when creating the SSH tunnel. The FQDN can be
    obtained with the `hostname -A` command. For example, for a server running 
    on `uan01`

    ```
     $ hostname -A
    ln01-nmn nid50823968 nid50823968 uan01.can
    ```

    then, create the SSH tunnel using

    ```
    ssh -N -L 11111:nid50823968:11111 lumi
    ```