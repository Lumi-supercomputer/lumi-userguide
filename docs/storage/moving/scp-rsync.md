# Data movement

## Copying files with `scp`

Copying files between different UNIX-like systems can be done with the `scp` 
command. This command which stands for *Secure Copy Protocol*, allows you to 
transfer files between a local host and a remote host or between two remote 
hosts. The basic syntax of the `scp` command is the following

```
scp <origin-path> <destination-path>
scp <origin-path> [user@]host:<destination-path>
scp [user@]host:<origin-path> <destination-path>
```

where `<origin-path>` is the path to the file you want to copy to the 
destination defined by `<destination-path>`.


The command to copy a file from a  local machine to a remote host is

```
scp /path/to/file [user@]host:/path/to/remote/destination
```

and correspondingly the syntax to copy files from a remote machine to a local
machine is

```
scp [user@]host:/path/to/file /path/to/local/destination
```

## Copying files with `rsync`

The `rsync` tool, which stands for *Remote Sync*, is a remote and local file 
synchronization tool. It has the advantage of minimizing the amount of data 
copied by only moving the portions of files that have changed. The advantages 
over `scp` are

- it allows synchronization, `scp` would copy and transfer everything, while 
  `rsync` will only copy and transfer the modifications
- better for the transfer of large files as `rsync` will save progress, so if 
  the transfer is interrupted it can be resumed at the same point

The basic syntax of the `rsync` command is the following

```
rsync <options> <origin-path> <destination-path>
rsync <options> <origin-path> [user@]host:<destination-path>
rsync <options> [user@]host:<origin-path> <destination-path>
```

Below are some useful options to use with `rsync`:

- archive mode with the `-a` or `--archive` option. This option tells `rsync` to 
  syncs directories recursively, transfer special and block devices, preserve 
  symbolic links, access permissions and time stamps
- compresses the data with the `-z` or `--compress` option. With this option 
  `rsync` will compress the data as it is sent to the destination machine.
- to keep the partially transferred files, use the `--partial` option. It is
  useful when transferring large files over slow or unstable network
  connections.
- if your goal is to achieve mirroring use the `--delete` option. When this
  option is used, `rsync` deletes extraneous files from the destination 
  location.