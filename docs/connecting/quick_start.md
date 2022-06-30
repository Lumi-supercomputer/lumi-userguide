<!-- ---
hide:
  - navigation
--- -->

# Get Started with LUMI

[terms-of-use]: https://www.lumi-supercomputer.eu/lumi-general-terms-of-use_1-0/
[support-account]: https://lumi-supercomputer.eu/user-support/need-help/account/
[myaccessid-profile]: https://mms.myaccessid.org/profile/
[mycsc-profile]: https://my.csc.fi/
[puttygen]: https://www.puttygen.com/#How_to_use_PuTTYgen
[support]: https://lumi-supercomputer.eu/user-support/need-help/
[registration]: ../accounts/registration.md
[connecting]: ../computing/connecting.md
[website-getstarted]: https://lumi-supercomputer.eu/get-started/
[jump-ssh-key]: #setting-up-ssh-key-pair
[eidas-eduid]: https://puhuri.neic.no/user_guides/myaccessid_registration/

Please read through all of this carefully before you start running on LUMI. Here
we describe a few sets of basic rules and the important information that you
need to get started.

## Access to LUMI

!!! Warning "Users with Finnish allocation"
    This section does not apply for users with a Finnish allocation (via [MyCSC](https://my.csc.fi/welcome)).
    These users are invited to follow the instruction starting from the 
    [next section][jump-ssh-key]. See also [here how to create a Finnish LUMI project](https://docs.csc.fi/accounts/how-to-create-new-project/#creating-a-lumi-project-and-applying-for-resources).

To access LUMI, you need to be a member of a project. LUMI Countries have
different policies for LUMI access. An overview of the access policies is 
provided [here][website-getstarted].

Resource allocators of each country will create the project and invite the PI.
The project PI can then invite members based on email addresses. If you have
been granted access to LUMI but didn't receive an invitation to a project,
please contact your PI or local HPC center.

In order to access the portal, you need to register to MyAccessID. The procedure
depends on the country. The recommended authentication method is to use your 
home organization's identity provider. You should find it by typing your 
organization into the *Choose Your Identity Provider* search field. If you found
your organization, but you got an error, please
[contact the support team][support-account]. You may also contact your identity 
provider directly. Alternative  registration options are available for some 
countries. Please see [here][eidas-eduid] for information about these 
alternatives.

For the next step, you will be directed to the registration page, where you have
to accept the Acceptable Use Policy and LUMI Terms of Use document, which is
linked there. Please read it carefully! 

<figure>
  <img 
    src="../../assets/images/Puhuri_Registration_example.png" 
    width="480"
    alt="Screenshot of registration portal"
  >
  <figcaption>MyAccessID Registration portal</figcaption>
</figure>

You may also modify the email address, but according to [LUMI Terms of
Use][terms-of-use] you must use your institutional email address.

## Setting up SSH key pair

**You can only log in to LUMI using SSH keys**. There are no passwords. In order
for this to work, you need to register your SSH key with MyAccessID, from where
LUMI will fetch it. The portal is the only way to add an SSH key. If you have a
Finnish allocation, then, you have to add your key to your MyCSC profile.

### Generate your SSH keys

After registration, you need to register a **public** key (**Note! Key must be RSA
4K bits or ed25519**). In order to do that
you need to generate an SSH key pair.

=== "From a terminal (all OS)"

    An SSH key pair can be generated in the Linux, macOS, Windows PowerShell and 
    MobaXterm terminal. It is important to create a long enough key length. For
    example, you can use the following command to generate a 4096 bits RSA key:

    ```bash
    ssh-keygen -t rsa -b 4096
    ```

    or for a ed25519 key:

    ```bash
    ssh-keygen -t ed25519
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
 
=== "For regular users"

    Now that you have generated your key pair, you need to set up your **public** key
    in your [:material-account: **user profile**][myaccessid-profile]. From there, the public key will be 
    copied to LUMI with some delay according to the synchronization schedule.

    To register your key, click on the *Settings* item of the menu on the left
    as shown in the figure below. Then select *Ssh keys*. From here you can add a new public key
    or remove an old one. **Note:** SSH key structure is *algorithm, key, comment*. 

    <figure>
      <img src="../../assets/images/MyAccessID_ssh-key.png" width="480" alt="Screenshot of user profile settings to setup ssh public key">
      <figcaption>MyAccessID Own profile information to add ssh public key.</figcaption>
    </figure>

=== "For users with a Finnish allocation"

    Now that you have generated your key pair, you need to set up your 
    **public** key in your [:material-account: **user profile**][mycsc-profile]. From there, the 
    public key will be copied to LUMI with some delay according to the 
    synchronization schedule.

    To register your key with [MyCSC][mycsc-profile], click on *My Profile* item
    of the menu on the left as shown in the figure below. Then scroll to the end 
    and in the *SSH PUBLIC KEYS* panel click the *Modify* button. From here,
    click the *Add new* button and paste your new public key in the text area 
    and click *Add*.

    <figure>
      <img src="../../assets/images/csc-profile.png" width="700" alt="Screenshot of user profile settings to setup ssh public key">
      <figcaption>MyCSC profile information to add ssh public key.</figcaption>
    </figure>

After registering the key, there can be a couple of hours delay until it is
synchronized. **You will receive your username via email once your account is 
created**.

## How to log in

Connect using a ssh client:

```
ssh -i<path-to-private-key> <username>@lumi.csc.fi
```

where you need to replace `username` with your own username, which you received
via email when you account is created in the identity manager. There may be a
10-15 minute delay before your account is before your account is actually
created on LUMI, be patient. If after this delay you cannot connect, please
contact the [support][support-account].

- [More information on how to setup SSH for LUMI][connecting]

Your username can also be retrieved via the different portals, depending on 
your resource allocator:

- the Puhuri Portal by clicking on the **Remote accounts** in the left menu
- myCSC by clicking on **My Profile** in the left menu
- the SUPR portal under **Account > Existing Accounts**

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
| **Home**     | `/users/<username>`        | for user personal and configuration files                                              | 
| **Project**: | `/project/<project_name>`  | act as the project home directory                                                      |
| **Scratch**  | `/scratch/<project_name>`  | intended as temporary storage for input, output or checkpoint data of your application |
| **Flash**    | `/flash/<project_name>`    | fast scratch space based on flash storage                                              |

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
