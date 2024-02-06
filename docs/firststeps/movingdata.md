[data-storage-options]: ../storage/index.md

# Moving data to/from LUMI

For moving data to/from LUMI, we recommend the use of the `scp` and `rsync`
tools. See the [data storage options][data-storage-options] page for an
overview of where to store your data on LUMI.

## Copying files with `scp`

Copying files between different UNIX-like systems can be done with the `scp`
command. This command, which stands for *Secure Copy Protocol*, allows you to
transfer files between a local host and a remote host or between two remote
hosts. The basic syntax of the `scp` command is the following:

```bash
scp <origin-path> <destination-path>
scp <origin-path> [user@]host:<destination-path>
scp [user@]host:<origin-path> <destination-path>
```

where `<origin-path>` is the path to the file you want to copy to the 
destination defined by `<destination-path>`.

To copy a file from a local machine to LUMI, on the local machine run (with
`<username>` replaced by your username):

```bash
scp /path/to/file <username>@lumi.csc.fi:/path/to/destination/on/lumi
```

and, correspondingly, to copy files from LUMI to a local machine, on the local
machine run:

```bash
scp <username>@lumi.csc.fi:/path/to/file/on/lumi /path/to/local/destination
```

You may use the `-r` switch to recursively copy an entire directory, e.g.

```bash
scp -r <username>@lumi.csc.fi:/path/to/directory/on/lumi /path/to/local/destination
```

Also, if `scp` does not automatically find your private SSH key, you need to specify it manually using the `-i` switch:

```bash
scp -i <path-to-private-key> <username>@lumi.csc.fi:/path/to/file/on/lumi /path/to/local/destination
```

## Copying files with `rsync`

The `rsync` tool, which stands for *Remote Sync*, is a remote and local file
synchronization tool. It has the advantage of minimizing the amount of data
copied by only copying files that have changed. The advantages over `scp` are

- It allows for synchronization. `scp` always copies and transfers everything,
  while `rsync` will only copy and transfer files that have changed.
- Better for the transfer of large files as `rsync` can save progress.
  If the transfer is interrupted it can be resumed from the point of interruption.

The basic syntax of the `rsync` command is the following:

```bash
rsync <options> <origin-path> <destination-path>
rsync <options> <origin-path> [user@]host:<destination-path>
rsync <options> [user@]host:<origin-path> <destination-path>
```

Below are some useful options to use with `rsync`:

- archive mode with the `-a` or `--archive` option. This option tells `rsync`
  to syncs directories recursively, transfer special and block devices,
  preserve symbolic links, access permissions and time stamps
- compresses the data with the `-z` or `--compress` option. With this option
  `rsync` will compress the data as it is sent to the destination machine.
- to keep the partially transferred files, use the `--partial` option. It is
  useful when transferring large files over slow or unstable network
  connections.
- if your goal is to achieve mirroring use the `--delete` option. When this
  option is used, `rsync` deletes extraneous files from the destination
  location.
