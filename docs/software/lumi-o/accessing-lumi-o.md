# Using Lumi-O from LUMI supercomputer


At the moment the tools for using object storage services are not by default installed in LUMI.
In this document we describe how you can install commonly used object storage clients
to LUMI and how to configure connection to LUMI-O object storage services.

## Installing Object Storage tools for Lumi-O

In this example we do the installation to the _/project_ area in Lumi so that
all project members can utilize these tools. In this example we use example project _462000008_.
Please use your own project number when installing these tools for your own use.

Once you have logged in to Lumi, move to the _/project_ disk area and make there a directory called _lumi-o_.

```text
cd /project/project_462000008
mkdir lumi-o
cd lumi-o
```
Then, clone _lumio-cli-utils_ repository to this location and continue to the cloned directory:

```text
git clone https://github.com/CSCfi/lumio-cli-utils  
cd lumio-cli-utils
```

Lumio-cli-utils has a list of software dependencies that needs to be be installed. We use here the
_lumi-container-wrapper_ tool to install most of them (s3cmd,
zstdmt and crypt4gh). The installation is done with commands:

```text
module load LUMI lumi-container-wrapper
conda-containerize new --prefix /project/project_462000008/lumi-o lumio-dependencies.yaml
```
The command above will install the dependencies to a singularity container and make command-like
execution scripts to a _bin_ directory that locates in the directory defined with the _--prefix_ option.
(in this case _/project/project_462000008/lumi-o/bin_).

Finally we need to modify _lo_env_conf_ file a bit so that _lo-tools_ works smoothly.
Open the file:
```text
nano lo_env_conf
```

In this file do following modifications (remember to use your own project number instead of
462000008)

```text
local_host=”lumi”
lumio_conf_path="/project/project_462000008/lumi-o/lumio-cli-utils/lumio_conf"
tmp_root="/scratch/project_462000008"
```

Next move to the lumio directory and create a set up file _lumio_setup.sh_
which will be use to simplify the setup process of LUMO-O cli tools

```text
cd /project/project_462000008/lumi-o
nano lumi-o_setup.sh
```
In the setup file will be used to add the installation directories to lo-tools and object storage software
your command path . In addition you create alias 'lumio-conf' that runs source command for the
connection setup script _lumio_conf_. (remember here too to replace the project number with your own project)


```text
export PATH=/project/project_462000008/lumi-o/lumio-cli-utils:/project/project_462000008/lumi-o/bin:$PATH
alias lumio-conf="source /project/project_462000008/lumi-o/lumio-cli-utils/lumio_conf"
```

Now the installation is ready. In the future you and your group members need to only
run the setup commands described below, to enable object storage tools and to open connection to Lumi-O

## Using Lumi-O

Once the object storage tools have been installed to the project directory as described above, then
opening connection to Lumi-O requires first setting up the environment with command:

```text
source /project/project_462000008/lumi-o/lumio_setup.sh
```

After this commands like _lumio-conf_, _rclone_ or _lo-put_ should work in the same way as in Puhti and Mahti.

Running command _lumio-conf_ starts normal configuration process for a swift based connetion to LUMI-O. Read every configuration step carefully.

If you want to configure connetion Lumi-O, run command:
```text
lumio-conf
```
This command asks you to connect with your browser to Lumi-O configuration sever, create credentials there and the copy the project nunber
and keys for the setup tool, for authentication use **MyAccessID**. The setup process for Lumi-O will create environment variables needed for _S3_ command and confuguration files for _s3cmd_ and _rclone_. In addition you can define that _lo-commands_ will use by default Lumi-O storage server. After that commands like _lo-list_, _lo-put_ or _lo-get_ will use your Lumi-O storage.

For _rclone_,  Lumi-o configuration provides two _rclone remotes_: _lumi-o:_ and _lumi-pub:_ . The buckets used by _lumi-pub_ will be publicly visible in URL: https://_project-number_.lumidata.eu/_bucket_name_.

Note, that you can have active connection to both Lumi-O and other object storage systms like Allas in the same time.
