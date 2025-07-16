# LUMI-O Access and Authentication

[auth.lumidata.eu]: https://auth.lumidata.eu
[lumi-o-tools]: https://github.com/Lumi-supercomputer/LUMI-O-tools


This page describes how to create credentials and how to connect to LUMI-O.


## Gaining access

To be able to use LUMI-O, you need to be a member of a LUMI project. 


## Create LUMI-O credentials

[auth.lumidata.eu]: https://auth.lumidata.eu


To connect to LUMI-O, one needs to create access credentials. These access credentials are valid for a pre-defined period of time. 
Note that if you are using the LUMI web interface, you can also create the access credentials directly in the web interface as described [here](../../runjobs/webui/index.md#accessing-lumi-o). 


Go to [LUMI-O credentials management service page][auth.lumidata.eu]. And click
on "-> Go to login".

<figure>
  <img src="../../../assets/images/auth.lumidata.eu-landingpage.png"     
       width="720" alt="Screenshot of auth.lumidata.eu landing page"
  >
  <figcaption>auth.lumidata.eu landing page</figcaption>
</figure>

Choose the correct authentication provider which for most LUMI users is "MyAccessID" (users with a Finnish allocation can also use "CSC" or "HAKA"), and follow the authentication procedure.

<figure>
  <img
    src="../../../assets/images/auth.lumidata.eu-authentication-provider.png"
    width="720" alt="Screenshot of auth.lumidata.eu authentication providers"
  >
  <figcaption>Authentication provider selection</figcaption>
</figure>

This page displays all the projects that are associated with your account.
It shows the project number, project description, set storage quota for
a specific project, and how much of the quota is used.
Additionally, this page allows creating the necessary authentication keys,
which are required for accessing the object storage.

<figure>
  <img 
    src="../../../assets/images/auth.lumidata.eu-main-page.png" 
    width="720" 
    alt="Screenshot of auth.lumidata.eu main page"
  >
  <figcaption>LUMI-O credential management main page</figcaption>
</figure>


<!--
!!! warning
	The **Usage** column does not display correct data as the feature is still being implemented 
-->


To create an authentication access key pair, open up the side menu from the
rightward pointing arrow. In this example, we are opening the side menu for
project 462000008, for which we will create the authentication key pair.

<figure>
  <img
    src="../../../assets/images/auth.lumidata.eu-main-page-select-project.png"
    width="720"
    alt="Screenshot of auth.lumidata.eu side menu arrow"
  >
  <figcaption>Open the side menu</figcaption>
</figure>

The side menu allows for the creation of access keys. To generate an access key
"Duration (hours)*" and "Key description*" fields must be filled out.

!!! tip
    With batch jobs, it's a good practice is to set the authentication key pair duration such that it covers the job
    walltime. This lets the job move the necessary data from LUMI-O to the
    scratch filesystem, perform the necessary calculations, and after finishing
    move the data back to LUMI-O.

<figure>
  <img
    src="../../../assets/images/auth.lumidata.eu-create-the-first-key.png"
    width="720" alt="Screenshot of auth.lumidata.eu side menu content"
  >
  <figcaption>Side menu</figcaption>
</figure>

The duration of the keys can also be extended later, as long as the key is still valid.


!!! tip
    The key description should be something relevant to the task it is meant for,
    as that way it is easier to manage the created keys, should there be more than
    a few at the same time.

<figure>
  <img 
    src="../../../assets/images/auth.lumisade.eu-key-duration-and-hours.png"
    width="720"
    alt="Screenshot of auth.lumidata.eu setting duration and description"
  >
  <figcaption>Filling out the required fields</figcaption>
</figure>

After the necessary fields are created, click on "Generate key".
The generated key will appear in the side menu under "Available keys".
The previously mentioned key description field is visible there,
which makes it easy to distinguish between several keys.

<figure>
  <img 
    src="../../../assets/images/auth.lumidata.eu-first-access-key.png"
    width="720" alt="Screenshot of auth.lumidata.eu available keys"
  >
  <figcaption>Available keys</figcaption>
</figure>

Click on the newly generated Access key. This opens up the key's content. It
provides the necessary "Access key" and "Secret key". You can also see the key
description, which project said key is related to, owner of the key and finally
Creation and Expiry dates.

From this side menu, it is also possible to extend the duration of the key.

!!! info
	When you initially create the key, the initial allowed maximum lifetime is 168h = 7 days.
	This can then be extended by one hour for every hour from key creation,
    i.e., you are always able to extend the duration of the key to now + 7 days.

It's also possible to download a configuration template for different object storage clients like
shell, boto3, rclone, s3cmd and aws. After selecting the desired object storage client and clicking "Generate" opens the output in a new browser tab.

Finally, by scrolling down in the menu this side menu allows you to delete the
key. After deletion of a key, a new one needs to be created to resume
utilizing LUMI-O for a certain project. Keys are non-recoverable, but a new one
can be created in its place.

<figure>
  <img 
    src="../../../assets/images/auth.lumisade.eu-first-key-content.png"
    width="720" alt="Screenshot of auth.lumidata.eu access key details"
  >
  <figcaption>Access key details</figcaption>
</figure>


## Connecting

You can access LUMI-O from any machine or server that is connected to internet. This can be a laptop, supercomputer, virtual machine in cloud or even your phone. 



### Using the LUMI web interface

[LUMI web interface](../../runjobs/webui/index.md#accessing-lumi-o) can be used to connect to LUMI-O. 



### On LUMI via terminal

With terminal, once logged in to LUMI, start by loading the `lumio` module which provides configuration and data transfer tools:

```
module load lumio
```

To configure a connection to LUMI-O, run the command:
```text
lumio-conf
```

This command asks you to connect with your browser to the [LUMI-O credentials
management service](#create-lumi-o-credentials), create credentials and the copy
the project number and keys for the setup tool. The setup process will create configuration files for `s3cmd`
and `rclone`.

Read the [step-by-step description](#create-lumi-o-credentials) above for creating LUMI-O
credentials.

Using the LUMI-O credentials management service, you can
also generate configuration for different [object storage clients](./clients-general.md) like shell,
boto3, rclone, s3cmd and aws. This is useful for using LUMI-O from somewhere
else than LUMI, where the `lumio-conf` command is not available (The tool can be
downloaded from the [LUMI-O repository][lumi-o-tools], but we only officially
support the tool on LUMI) 


### Other ways to access LUMI-O


In [auth.lumidata.eu](https://auth.lumidata.eu) one can create configuration files associated to valid keys. These configuration files specify the details that are needed to access LUMI-O, and connecting to LUMI is actually not needed at all. 

To connect to LUMI-O directly e.g. from your own laptop, you need to set a configuration file in your home directory (in your laptop) to a specified location, with valid LUMI-O access keys. See [an example with rclone](./connect-local.md).




## Advanced: Credentials & Configuration

This advanced topic is for people, who wish to modify where the client software used with LUMI-O read the authentication credentials. 
As a basic user, you don't need to care about this topic.

### Configuration files

The data moving tools (client software) have default locations for config files under home directory.
In some cases it might be required to read
credentials from some other location than the default 
locations under home. This can be achieved using environment variables or command line flags.


|      | rclone        | s3cmd                  | aws                                         |
|------|---------------|------------------------|---------------------------------------------|
| DEFAULT | `~/.config/rclone/rclone.conf`   | `~/.s3cfg`  | `~/.aws/credentials` and `~/.aws/config`|
| ENV  | `RCLONE_CONFIG` | `S3CMD_CONFIG`           | `AWS_SHARED_CREDENTIALS_FILE` and `AWS_CONFIG_FILE` |
| FLAG | `--config FILE` | `-c FILE`, `--config=FILE` |                                             |

The `aws` cli additionally has the concept of [profiles](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html), and you can specify 
which one to use using the `--profile <name>` flag or the `AWS_PROFILE` environment variable.

### Environment variables

Most programs will use the environment variables `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`
when trying to authenticate. So these can be set if one does not wish to save the credentials on disk.
The environment variables do not always take precedence over values set in configuration files, as
is the case for `s3cmd` and `rclone`. This means that invalid credentials in config files will
lead to an access denied even if there are valid credentials in the environment. The `aws` command
will use the environment variables instead of `~/.aws/credentials` if they are set. 
`rclone` will additionally require `RCLONE_S3_ENV_AUTH=true` in the environment or `env_auth = true`
in the config file.


Unless you have properly configured the s3 tools to use LUMI-O, they will usually default to using amazon aws s3. This is also the case for most other programs
so if you wish to use LUMI-O with other software, you usually have to find some configuration option or environment variable to set a non-default
host name. The correct hostname to use for LUMI-O is `https://lumidata.eu`

