[terms-of-use]: https://www.lumi-supercomputer.eu/lumi-general-terms-of-use_1-0/
[support-account]: https://lumi-supercomputer.eu/user-support/need-help/account/
[myaccessid-profile]: https://mms.myaccessid.org/profile/
[mycsc-profile]: https://my.csc.fi/
[puttygen]: https://www.puttygen.com/#How_to_use_PuTTYgen
[support]: https://lumi-supercomputer.eu/user-support/need-help/
[registration]: ../accounts/registration.md
[connecting]: ../connecting/connecting_.md
[website-getstarted]: https://lumi-supercomputer.eu/get-started/
[jump-ssh-key]: #setting-up-ssh-key-pair
[eidas-eduid]: https://puhuri.neic.no/user_guides/myaccessid_registration/


# Setting up SSH key pair

Before connecting to LUMI, you need to generate an SSH key pair. **You can only log in to LUMI using SSH keys**. There are no passwords. 

 - If you have a Finnish allocation, then, you have to add your public key to your MyCSC profile.

 - For regular users (other allocations), you need to register your public key to MyAccessID, from where LUMI will fetch it. The portal is the only way to add an SSH key. 

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