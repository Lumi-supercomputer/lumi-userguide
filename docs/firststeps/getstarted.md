---
hide:
  - navigation
---

# Get Started with LUMI

[terms-of-use]: https://www.lumi-supercomputer.eu/lumi-general-terms-of-use_1-0/
[support-account]: https://lumi-supercomputer.eu/user-support/need-help/account/
[myaccessid-profile]: https://mms.myaccessid.org/fed/gui/
[puttygen]: https://www.puttygen.com/#How_to_use_PuTTYgen
[support]: https://lumi-supercomputer.eu/user-support/need-help/
[registration]: ../accounts/registration.md

Please read through all of this carefully before you start running on LUMI. Here
we describe a few sets of basic rules and the important information that you
need to get started.

## Setting up SSH key pair

**You can only log in to LUMI using SSH keys**. There are no passwords. In order for this to work, you need to register your SSH key with MyAccessID, from where LUMI will fetch it.

LUMI Countries have different kinds of portals managing user access to the system. Please contact your local HPC organization to find which URL to go to. The portals will lead you to MyAccessID registration age, where you have to accept Acceptable Use Policy and LUMI Terms of Use 
document, which is linked there. Please read it carefully! 

<figure>
  <img 
    src="../../assets/images/Puhuri_Registration_example.png" 
    width="480"
    alt="Screenshot of registration portal"
  >
  <figcaption>MyAccessID Registration portal</figcaption>
</figure>

 
You may also modify the email address, but according to 
[LUMI Terms of Use][terms-of-use] you must your organizational email address.

The authentication in the portal is done with home organization identity provider,
which can be selected from the list. In case that is not possible please 
[contact the support team][support-account] with the error message and you may also
contact your identity provider directly.

You also need to be a member of a project. The project's PI will create a project 
and invite members based on email addresses. Resource allocators of each country will 
accept the project. When the project is accepted, the user accounts will be 
created in LUMI. You will receive email from CSC's Identity management system 
informing you of your project ID and user account name.

### Generate your SSH keys

After registration, you need to register a **public** key. In order to do that
you need to generate an SSH key pair.

=== "From a terminal (all OS)"

    An SSH key pair can be generated in the Linux, macOS, Windows PowerShell and 
    MobaXterm terminal. It is important to create a long enough key length. For
    example, you can use the following command to generate a 4096 bits RSA key:

    ```bash
    ssh-keygen -t rsa -b 4096
    ```

    You will be prompted for a file name and location where to save the
    key. Accept the defaults by pressing ++enter++. Alternatively, you can 
    choose a custom name and location. For example 
    `/home/username/.ssh/id_rsa_lumi`.

    Next, you will be asked for a passphrase. Please choose a secure
    passphrase. It should be at least 8 characters long and should contain
    numbers, letters and special characters. **Do not leave the passphrase 
    empty**.

    After that a SSH key pair is created. If you choose the name given as an
    example, you should have files named `id_rsa_lumi` and `id_rsa_lumi.pub` in
    your `.ssh` directory.

=== "With MobaXTerm or PuTTY (Windows)"

    An SSH key pair can be generated with the PuTTygen tool or with MobaXterm 
    (**Tools :octicons-arrow-right-16: MobaKeyGen**). Both tools are identical.
    
    In order to generate your key pairs for LUMI, choose the option RSA and
    set the number of bits to 4096. The, press the *Generate* button.

    <figure>
      <img src="../../assets/images/win-keygen-step1.png" width="400" alt="Create SSH key pair with windows - step 1">
    </figure>

    You will be requested to move the mouse in the Key area to generate some 
    entropy; do so until the green bar is completely filled.

    <figure>
      <img src="../../assets/images/win-keygen-step2.png" width="400" alt="Create SSH key pair with windows - step 2">
    </figure>

    After that, enter a comment in the Key comment field and a strong
    passphrase. Please choose a secure passphrase. It should be at least 8 
    characters long and should contain numbers, letters and special characters.
    **Do not leave the passphrase empty**.

    <figure>
      <img src="../../assets/images/win-keygen-step3.png" width="400" alt="Create SSH key pair with windows - step 3">
    </figure>

    The next step is to save your public and private key. Click on the *Save 
    public key* button and save it to the desired location (for example, with 
    `id_rsa_lumi.pub` as a name). Do the same with your private key by clicking
    on the *Save private key* button and save it to the desired location (for 
    example, with `id_rsa_lumi` as a name).

!!! warning "Note"
    The private key should never be shared with anyone, not even with
    LUMI staff. It should also be stored only in the local computer (public key
    can be safely stored in cloud services). Protect it with a good password! Otherwise, anyone with access to the file system can steal your SSH key.

### Upload your public key 
 
Nox that you have generated your key pair, you need to set up your **public** key
in your [user profile][myaccessid-profile]. From there, the public key will be 
copied to LUMI with some delay according to the synchronization schedule.

To register your key, click in the *Authentication* tab and then on the green 
button next to *Public ssh Key*. Then, copy/paste the content of your **public**
key file in the field. **Note:** SSH key structure is <algorithm> <key> <comment>. Please EXCLUDE <comment> from your copy/paste

<figure>
  <img 
    src="../../assets/images/myaccessid_own_profile.png" 
    width="480"
    alt="Screenshot of user profile settings to setup ssh public key"
  >
  <figcaption>MyAccessID Own profile information to add ssh public key.</figcaption>
</figure>

After registering the key, there can be a couple of hours delay until it is synchronized.

## How to log in

Connect using a ssh client:

```
ssh username@lumi.csc.fi
```

where you need to replace `username` with your own username, which you received
via email during the registration. If you cannot get a connection at all, your 
IP number range might be blocked from login. Please contact the
[support][support-account].

## Running

When you log in to LUMI, you end up on one of the login nodes. These login nodes
are shared by all users and they are not intended for heavy computing.

The login nodes should be used only for:

- compiling (but consider allocating a compute for large build jobs)
- managing batch jobs
- moving data
- light pre- and postprocessing (a few cores / a few GB of memory)

All the other tasks should be done on the compute nodes either as normal batch
jobs or as interactive batch jobs. Programs not adhering to these rules will be
terminated without warning.

Compute intensive jobs must be submitted to the job scheduling system. LUMI uses
Slurm as the job scheduler. In order to run, you need a project allocation. 
You need to specify your project ID in your job script (or via the command line
when submitting your job) in order for your job to be submitted to the queue. 

!!! missing

    Commands to gather information about the project and quota are not
    available yet. However, you can use the `groups` command to retrieve your 
    project ID when connected to LUMI: you should see that you are part of a 
    group named `project_xxxxxxxxx`.

Here is a typical batch script for Slurm. This script runs an application
on 2 compute nodes with 16 MPI ranks on each node (32 total) and 8 OpenMP 
threads per rank.

```
$ cat batch_script.slurm
#!/bin/bash -l
#SBATCH --job-name=test-job
#SBATCH --account=<project_xxxxxxxxx>
#SBATCH --time=01:00:00
#SBATCH --nodes=2
#SBATCH --ntasks=32
#SBATCH --ntasks-per-node=16
#SBATCH --cpus-per-task=8
#SBATCH --partition=standard

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
srun ./application
```

- [More information about running jobs on LUMI](../computing/index.md)

## Where to store data

On LUMI, there are several disk areas: home, projects, scratch (LUMI-P) and fast 
flash-backed scratch (LUMI-F). Please familiarize yourself with the areas and 
their specific purposes.

|              | Path                       | Description                                                                            |
|--------------|----------------------------|----------------------------------------------------------------------------------------|
| **Home**     | `/users/<username>`        | for user configuration files and source code                                           | 
| **Project**: | `/projappl/<project_name>` | act as the project home directory                                                      |
| **Scratch**  | `/scratch/<project_name>`  | intended as temporary storage for input, output or checkpoint data of your application |

- [Learn more about the LUMI storage](../storage/index.md)

## Compiling and Developing your Code

LUMI comes with the multiple programming environments: Cray, GNU and AOCC. 
In addition, the most common libraries used in an HPC environment tuned for LUMI
are also available. Parallel debugger and profiling tools are also at one's 
disposal.

- [Learn more about the programming environments](../development/compiling/prgenv.md)
- [Learn more about debugging](../development/debugging/gdb4hpc.md)
- [Learn more about profiling](../development/profiling/index.md)

## Getting Help

The LUMI User Support Team is here to help if you have any question or problem
regarding your usage of LUMI. You can contact the support team [here][support].
