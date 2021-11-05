---
hide:
  - navigation
---

# Get Started with LUMI

[terms-of-use]: https://www.lumi-supercomputer.eu/lumi-general-terms-of-use_1-0/
[support-account]: https://lumi-supercomputer.eu/user-support/need-help/account/
[myaccessid-profile]: https://mms.myaccessid.org/profile/
[puttygen]: https://www.puttygen.com/#How_to_use_PuTTYgen
[support]: https://lumi-supercomputer.eu/user-support/need-help/
[registration]: ../accounts/registration.md
[sample-ssh-keygen-output]: sample-ssh-keygen-output.md

Please read through all of this carefully before you start running on LUMI. Here
we describe a few sets of basic rules and the important information that you
need to get started.

## Setting up SSH key pair

**You can only log in to LUMI using SSH keys**. There are no passwords. In order for this to work, you need to register your SSH key with MyAccessID, from where LUMI will fetch it.

LUMI Countries have different kinds of portals managing user access to the system. Please contact your local HPC organization to find which URL to go to. The portals will lead you to MyAccessID registration age, where you have to accept the Acceptable Use Policy and LUMI Terms of Use 
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
[LUMI Terms of Use][terms-of-use] you must use your organizational email address.

The authentication in the portal is done with home organization identity provider,
which can be selected from the list. In case that is not possible please 
[contact the support team][support-account] with the error message, and you may also
contact your identity provider directly.

You also need to be a member of a project. The project's PI will create a project 
and invite members based on email addresses. Resource allocators of each country will 
accept the project. When the project is accepted, the user accounts will be 
created in LUMI. You will receive email from CSC's Identity management system 
informing you of your project ID and user account name.

### Generate your SSH keys

After registration, you need to register a **public** key (**Note! Key must be RSA
4K bits or elliptic curve**). In order to do that
you need to generate an SSH key pair.

=== "From a terminal (all OS)"

    This section is intended for users that are not familiar with details of SSH
    usage. If you already know how SSH works, feel free to be able to modify
    An SSH key pair can be generated in the Linux, macOS, Windows PowerShell and 
    MobaXterm terminal. It is important to create a long enough key length. For
    example, you can use the following command to generate a 4096 bits RSA key:

    ```bash
     bash -c '
    mkdir $HOME/.ssh/ && chmod 700 $HOME/.ssh
    ssh-keygen -t rsa -b 4096  -f $HOME/.ssh/id_rsa_lumi
    ls -l  $HOME/.ssh/id_rsa_lumi $HOME/.ssh/id_rsa_lumi.pub
    echo Copy everything between the =+=+=+=+=+=+=+=, not inclusive of these lines
    echo =+=+=+=+=+=+=+= START OF Your public key:
    ( cat  $HOME/.ssh/id_rsa_lumi.pub | ( read algo key comment ; echo "$algo $key" ) )
    echo =+=+=+=+=+=+=+= END OF Your public key.
      '
    ```
    After running the above, your terminal should look something like this [keygen output][sample-ssh-keygen-output].
    
    Between the =+=+=+=+=+=+=+= is one line of ASCII output, which will likely
    show up on your terminal as multiple lines. If you are later cutting and pasting
    it into MyAccessId.org, make sure there are no NewLines or Spaces in the
    resulting pasted text.

    Next, you will be asked for a passphrase. Please choose a secure
    passphrase. It should be at least 8 characters long and should contain
    numbers, letters and special characters. If you prefer not to use special characters,
    make sure that the passphrase is at least 19 characters long.
    **Do not leave the passphrase empty**.
    **Write down this passphrase to a secure place.**
    **This passphrase will be needed later to log in.**
    **Do not give this passphrase to anyone.**
    **Do not include this passphrase in any support requests.** (There is no legitimate
    use of this passphrase by any support personnel, at any time. Report anyone asking
    you to give them your passphrase or password, immediately please.)

    After that a SSH key pair is created. You should have files named
    `id_rsa_lumi` and `id_rsa_lumi.pub` in your `$HOME/.ssh` directory.

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
 
Now that you have generated your key pair, you need to set up your **public** key
in your [user profile][myaccessid-profile]. From there, the public key will be 
copied to LUMI with some delay according to the synchronization schedule.

To register your key, click on the *Settings* item of the menu on the left
as shown in the figure below. Then select *Ssh keys*. From here you can add a new public key
or remove an old one. **Note:** SSH key structure is *algorithm, key, comment*. Please EXCLUDE *comment* from your copy/paste.

<figure>
  <img 
    src="../../assets/images/MyAccessID_ssh-key.png" 
    width="480"
    alt="Screenshot of user profile settings to setup ssh public key"
  >
  <figcaption>MyAccessID Own profile information to add ssh public key.</figcaption>
</figure>

After registering the key, there can be a about 15 minutes delay until it is synchronized.
After that your new SSH key should be recognized and accepted by LUMI login nodes.

## How to log in

Connect using a ssh client:

```
ssh username@lumi.csc.fi
```

where you need to replace `username` with your own username, which you received
via email during the registration. If you cannot get a connection at all, your 
IP number range might be blocked from login. Please contact the
[support][support-account]. If you can get a connection but LUMI is not logging
you in, please contact the [support][support-account] , pasting into request the
output of the following commands:
`ssh-keygen -y -f /path/to/private.key.generated.above`
`ssh -vvv -i /path/to/private.key.generated.above  _your_username_@lumi.csc.fi`

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

LUMI comes with multiple programming environments: Cray, GNU, and AOCC. 
In addition, the most common libraries used in an HPC environment tuned for LUMI
are also available. Parallel debugger and profiling tools are also at one's 
disposal.

- [Learn more about the programming environments](../development/compiling/prgenv.md)
- [Learn more about debugging](../development/debugging/gdb4hpc.md)
- [Learn more about profiling](../development/profiling/index.md)

## Getting Help

The LUMI User Support Team is here to help if you have any questions or problems
regarding your usage of LUMI. You can contact the support team [here][support].
