# Additional SSH tips

[getstarted]: ../firststeps/getstarted.md
[account-support]: https://lumi-supercomputer.eu/user-support/need-help/account/

This page gives you more details on how to configure your machine to access 
LUMI. 
<!-- However, it does not cover the first necessary steps to connect to LUMI
like how to generate a key pair and setup your public SSH key on your MyAccessID
profile. Instruction on how to do that can be found [here][getstarted].  -->

## From the command line

Connecting to LUMI via the command line is possible from all major OS. Once you 
have generated your key pair and setup your public SSH key on your 
MyAccessID profile, you can connect with

```
ssh -i<path-to-private-key> <username>@lumi.csc.fi
```

where you have to replace `<path-to-private-key>` and `<username>` with the 
appropriate values. You should have received your user name via email. If not, 
please [contact the support][account-support].

You will be prompted for the passphrase of the SSH key 
which is the one you entered when you generated the key. When you connect for 
the first time, you will also be asked to check the host key fingerprint of the 
system and need to type `yes` in order to accept it. The fingerprint of the LUMI
login nodes are listed in the table below.

| Hash type | Fingerprint                                       |
|-----------|---------------------------------------------------|
| MD5       | `28:2a:38:71:b0:a6:6b:90:0e:1b:a1:9d:ca:ec:94:20` |
| SHA256    | `hY4mnRCYb8bRchTnVcFo7SqoHHHEsUh9Ym38F4sHN1Y`     |


### Add your key to your agent

If you chose a strong passphrase for your key, what you should have done, it 
might be painful to enter you passphrase for every connection. To avoid the 
pain, you can use an SSH agent to remember the passphrase for you. 

The first step in to ensure the SSH agent is running. For that run the command

```
eval "$(ssh-agent -s)"
```

The second step is to add your private key to your agent with the command

```
ssh-add <path-to-private-key>
```

 you will then be asked for your passphrase and now, you should no longer have
 to enter your passphrase every time you connect to LUMI.

### Add LUMI to your SSH configuration

In the previous section, we have discussed how to add your key to the agent and 
thus avoid having to enter your password. You can also create an SSH 
configuration for LUMI on your machine that will act as a shortcut. This is 
achieved by editing the `.ssh/config` file and by adding the following lines

```
Host lumi
  HostName lumi.csc.fi
  User <username>
  IdentityFile <path-to-private-key>
```

Once you added this line to your SSH configuration file, you can connect using 
the following command

```
ssh lumi
```

This configuration will also influence the behaviour of any program that uses 
SSH git, scp, and rsync.

### Troubleshooting

If you have trouble connecting to LUMI, you can run the SSH client with verbose
output enabled.

```
ssh -vvv -i<path-to-private-key> <username>@lumi.csc.fi
```

If you are unable to connect and you contact the support, we recommend that you
provide the output of this command.

