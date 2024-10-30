[terms-of-use]: https://www.lumi-supercomputer.eu/lumi-general-terms-of-use_1-0/
[support-account]: https://lumi-supercomputer.eu/user-support/need-help/account/
[myaccessid-profile]: https://mms.myaccessid.org/profile/
[mycsc-profile]: https://my.csc.fi/
[puttygen]: https://www.puttygen.com/#How_to_use_PuTTYgen
[support]: https://lumi-supercomputer.eu/user-support/need-help/
[registration]: ../accounts/registration.md
[connecting]: ../connecting/connecting_.md
[website-getstarted]: https://lumi-supercomputer.eu/get-started/
[jump-register-keys]: #register-your-public-key
[eidas-eduid]: https://puhuri.neic.no/user_guides/myaccessid_registration/

# Setting up SSH keypair

If you want to use LUMI from a terminal, you need to register an SSH key pair. The SSH keys are the only way to connect to LUMI when using a Linux, macOS or Windows PowerShell terminal, or MobaXterm or PuTTY from Windows. There is no option for using passwords. 

LUMI only accepts SSH keys based on the RSA (4096 bit) or ed25519 algorithms.
If possible, we recommend using ed25519.

## Generate your SSH keys

If you already have an appropriate SSH key pair that you want to use with LUMI,
you may skip to [registering your public key][jump-register-keys]. If not,
start by generating an SSH key pair as detailed below.

=== "From a terminal (all OS)"

    An SSH key pair can be generated using a Linux, macOS, Windows PowerShell
    terminal. For example, you can use the following command to generate
    an ed25519 key:

    ```bash
    ssh-keygen -t ed25519
    ```

    or, alternative, use the following command to generate a 4096 bit RSA key:

    ```bash
    ssh-keygen -t rsa -b 4096
    ```

    You will be prompted for a file name and location where to save the
    key. Accept the defaults by pressing ++enter++. Alternatively, you can 
    choose a custom name and location and add it interactively or as a
    command line argument with for example `-f /home/username/.ssh/id_rsa_lumi`.

    Next, you will be asked for a passphrase. Please choose a secure
    passphrase. It should be at least 8 (preferably 12) characters long and
    should contain numbers, letters and special characters. **Do not leave the
    passphrase empty**.

    After that an SSH key pair is created, i.e. a pair of files containing
    the public and private keys, e.g. files named `id_rsa_lumi`
    (the **private** key) and `id_rsa_lumi.pub` (the **public** key) in your
    `/home/username/.ssh/` directory.

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
    (preferably 12) characters long and should contain numbers, letters and
    special characters. **Do not leave the passphrase empty**.

    <figure>
      <img src="../../assets/images/win-keygen-step3.png" width="400" alt="Create SSH key pair with windows - step 3">
    </figure>

    The next step is to save your public and private key. Click on the *Save 
    public key* button and save it to the desired location (for example, with 
    `id_rsa_lumi.pub` as a name). Do the same with your private key by clicking
    on the *Save private key* button and save it to the desired location (for 
    example, with `id_rsa_lumi` as a name).

    !!! note "Key format"

        To use your key, you may need two different key formats. The
        instructions above generate a private key in PuTTY format (PPK), which
        can be used with PuTTY and in a MobaXTerm SSH session created via the
        MobaXTerm GUI.
                
        However, if you are using the OpenSSH client (the ssh command in a
        MobaXTerm terminal), you will need a key in the OpenSSH format. To
        convert your key, go to the **Conversions :octicons-arrow-right-16:
        Export OpenSSH key** menu in the key generator tool and save it in the
        OpenSSH format.

        You can convert between these two key formats at any time using the key
        generator tool. Load a key by using the **Conversions :octicons-arrow-right-16:
        Import key** menu, then save it in the desired format: 
        
          - OpenSSH to PPK: load a OpenSSH key, then save it with the **Save
            private key** button
          - PPK to OpenSSH: load a PPK key, then save it via the **Conversions
            :octicons-arrow-right-16: Export OpenSSH key** menu

!!! warning
    The private key should never be shared with anyone, not even
    with LUMI staff. It should also be stored only on your local computer
    (public key can be safely stored in cloud services). Protect it with a good
    password! Otherwise, anyone with access to the file system can steal your
    SSH key.

## Register your public key

=== "For regular users (with a non-Finnish allocation)"

    Now that you have generated your key pair, you need to register your **public** key
    in your [:material-account: **MyAccessID user profile**][myaccessid-profile]. From there, the public key will be 
    copied to LUMI.

    To register your key, click on the *Settings* item of the menu on the left
    as shown in the figure below. Then select *SSH keys* and click the *New key* button. Now copy and paste the content of your **public** key file in the text area and click the *Add SSH key* button.

    <figure>
      <img src="../../assets/images/MyAccessID_ssh-key.png" width="480" alt="Screenshot of user profile settings to setup ssh public key">
      <figcaption>MyAccessID Own profile information to add ssh public key.</figcaption>
    </figure>

=== "With a Finnish allocation"

    Now that you have generated your key pair, you need to register your
    **public** key in your MyCSC [:material-account: **user profile**][mycsc-profile].

    To register your key with [MyCSC][mycsc-profile], click on the *Profile* item of the menu on the left side of the screen. If your browser window is narrow, the navigation might be hidden, in which case you need to open it from the top-right button. In the lower right corner of the *Profile* page there is a box which reads *SSH PUBLIC KEYS*. Click the *Add key* button (you may need to re-login). Paste the content of your **public** key in the text area which reads *Key*. Omit the ending of the key file that has your local username and the name of your computer. It should look like

    ```bash
    ssh-ed25519 AAAAC3NzaC1lZDI....I3J
    ```

    Add a title, e.g., *lumi*, and then click *Add*. 


After registering your SSH key, there can be a couple of hours delay until it
is synchronized to LUMI and your account is created. **You will receive your
username via email once your account has been created**.
