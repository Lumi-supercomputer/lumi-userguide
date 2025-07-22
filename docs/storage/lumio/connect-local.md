# Using LUMI-O from your local computer

!!!Warning
    This example is for Linux and MacOS. For Windows machines this might not work similarily.



This example uses `rclone`. The same works similarly with e.g. `s3cmd` and other clients. (for the s3cmd the default path under home directory is `~/.s3cfg`.)

By setting the file `rclone.conf` (default config path is `~/.config/rclone/rclone.conf`) on your local system with the correct configuration setting and valid access key, rclone opens LUMI-O session from anywhere across internet, e.g. from your own laptop. Connection to LUMI is not needed. 

Note you should have rclone installed locally for this example to work. Follow the directions e.g. [on rclone website](https://rclone.org/install/) to install rclone on your local computer.

From auth.lumidata.eu you can get a valid rclone configuration for LUMI-O that is assosiated to (valid) access keys/tokens for a specific LUMI project. 


## Example: Create rclone config file and access LUMI-O directly from your laptop

**1)** Go to [auth.lumidata.eu](https://auth.lumidata.eu) 

**2)** Click the valid 'Access key' for your project (or if you don't have one, create a new key first for your project)

**3)** Select `rclone` from the Configuration templates and click 'Generate'

**4)** Copy the created text block to a file (on your laptop) that you name 'rclone.conf' (or add it to an existing rclone.conf file). It's simplest to place it in the default path for rclone `~/.config/rclone/rclone.conf` 

**5)** Now you can access LUMI-O with rclone. Type e.g. 
```
rclone lsd lumi-46500XXXX-private:
```
to see the buckets of your project 46500XXXX in LUMI-O. (_Replace 46500XXXX with your actual LUMI project number_.)


The access with this rclone config file works as long as your access credentials for the LUMI-O endpoint are valid. 
You can extend the validity of the access keys in [auth.lumidata.eu](https://auth.lumidata.eu)
You can also create new keys (and update the config file for them), if the keys expire.
