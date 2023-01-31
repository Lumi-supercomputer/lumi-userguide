<!-- [terms-of-use]: https://www.lumi-supercomputer.eu/lumi-general-terms-of-use_1-0/
[support-account]: https://lumi-supercomputer.eu/user-support/need-help/account/
[myaccessid-profile]: https://mms.myaccessid.org/profile/
[mycsc-profile]: https://my.csc.fi/
[puttygen]: https://www.puttygen.com/#How_to_use_PuTTYgen
[support]: https://lumi-supercomputer.eu/user-support/need-help/
[registration]: ../accounts/registration.md
[connecting]: ../connecting/connecting_.md
[website-getstarted]: https://lumi-supercomputer.eu/get-started/
[jump-ssh-key]: #logging-in
[eidas-eduid]: https://puhuri.neic.no/user_guides/myaccessid_registration/ -->

[helpdesk]: ../helpdesk/index.md
[setup-ssh-key]: ../firststeps/SSH-keys.md

# Logging in (with SSH client)


Connecting to LUMI via the command line is possible from all major OS. Once you
have completed the steps to [setting up an SSH key pair][setup-ssh-key] and
everything has synchronized, you can connect using an ssh client:

```bash
ssh -i <path-to-private-key> <username>@lumi.csc.fi
```

where you need to replace `<path-to-private-key>` with the path to the file
which contains your **private** key and `<username>` with with your own
username.

You should have received your username via email when your account was created.
There may be a delay of up to a couple of hours from registering your SSH key
until your account is created on LUMI, please be patient. If you are still not
able to connect, please contact the [user support team][helpdesk].

You will be prompted for the passphrase of the SSH key which is the one you
entered when you generated the key. When you connect for the first time, you
will also be asked to check the host key fingerprint of the system and need to
type `yes` in order to accept it. The fingerprint of the LUMI login nodes are
listed in the table below. Please make sure that the host key fingerprint
matches one of these.

| Key type   | Fingerprint                                              |
|--------- --|----------------------------------------------------------|
| ED25519    | `SHA256:qCFZThjRw8nf0CiZ9rU7b6Zirjq8slAIl5r0xWaVoD0`     |
| RSA        | `SHA256:ypbqdMWtk9ZdXEROkeEpv+3PCEXWjPLGI79IXGHe9ac`     |

## Troubleshooting

If you have trouble connecting to LUMI, you can run the SSH client with verbose
output enabled to get more information about what happens when you try to connect:

```bash
ssh -vvv -i <path-to-private-key> <username>@lumi.csc.fi
```

If you are unable to connect and you contact the [user support team][helpdesk],
we recommend that you provide the output of this command as part of your
support request.

In case you have forgotten your username, it can be retrieved via the different
portals, depending on your resource allocator:

- the Puhuri Portal by clicking on the **Remote accounts** in the left menu
- myCSC by clicking on **My Profile** in the left menu
- the SUPR portal under **Account > Existing Accounts**
