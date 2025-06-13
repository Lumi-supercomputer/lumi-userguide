# Using LUMI-O without connecting to LUMI

!!!Warning
    This example is for Linux and MacOS. For Windows machines this might not work similarily.



This example is with `rclone`. The same works similarily with e.g `s3cmd` and other clients. (Notice that for s3cmd the default path under home directory is `~/.s3cfg`.)

By setting a file called `rclone.conf` in the default path `~/.config/rclone/rclone.conf` (e.g. in your own laptop) with the correct configuration setting and valid access keys, it is possible to use rclone to access LUMI-O from anywhere across internet, e.g. from your own laptop. Connection to LUMI is not needed. 

## Example: Create rclone config file and connect to LUMI-O directly from your laptop

You can get a valid rclone configuration from [auth.lumidata.eu](https://auth.lumidata.eu). 

**1)** Click a valid 'Access key' (or if you don't have one, create a new key first for your project)

**2)** Select `rclone` from the Configuration templates and click 'Generate'

**3)** Copy the created text block to a file (on your laptop) that you name 'rclone.conf'. It's simplest to place it in the default path for rclone `~/.config/rclone/rclone.conf`

**4)** Notice that you should have rclone installed for this to work. If you don't have rclone installed, follow the directions e.g. [on rclone website](https://rclone.org/install/) to install rclone on your laptop.

**5)** Now you can access LUMI-O with rclone. Type e.g. 
```
rclone lsd lumi-465000XXX-private:
```
to see the content of your project 465000XXX in LUMI-O. (Replace 465000XXX with your actual LUMI project number.)



The connection with this rclone config-file works as long as your access key is valid. 
You can extend the validity of the key in [auth.lumidata.eu](https://auth.lumidata.eu)
You can also create a new key and a new config file for it, if the key expires.
