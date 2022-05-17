# Arm Forge on LUMI

Arm Forge is installed on LUMI in project directory `/appl/lumi/SW/system/EB/ARMForge/22.0.1/`.

Add it to your current enviromnent with the following commands:
```
module load LUMI ARMForge
```

For the training it is recommended to use Forge with the desktop client that can be installed on a local computer. It can be downloaded 
from [here](https://developer.arm.com/tools-and-software/server-and-hpc/downloads/arm-forge) for Windows, Linux and MacOS.

Once the client is installed on a local computer you can use "Remote Launch" with the following configuration:

* Host Name: use name from you ssh config (for Linux) or Putty connection name (for Windows),
* Remote Installation Directory: the same as above.

Make sure if your connection is properly configured with "Test Remote Launch" button.

Note: If you use Windows you should first convert you public ssh key to format used by Putty ("ppk"), following the steps described 
[here](https://developer.arm.com/documentation/102735/2003/Procedure).

Set up parallel job execution with "File > Options" menu and select MPI/UPC Implementation as "SLURM (generic)" under "System" option setting. 

To run debugging DDT session directly from Forge GUI on computing nodes use MPI with "SLURM (generic)" mode and "srun arguments" set to 
`-p debug -A project_462000031`.

Other approach is to use "Reverse Connect" feature. It allows you to submit program with debugger wrapper directly on the system. The wrapper will connect
back to the GUI on your local computer. You need to enable remote connection to LUMI from the client GUI with "Remote Launch". Next execute the job directly
from the command line or from sbatch script, using `ddt --connect` before your actual `srun`. After your job starts it will signal client on your local computer 
and you will be asked to accept reverse connection. 

The process of reverse connection is described [here](https://developer.arm.com/documentation/101136/2112/Arm-Forge/Connecting-to-a-remote-system/Reverse-Connect).
