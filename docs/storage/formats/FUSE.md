[singularity_mounts]: https://docs.sylabs.io/guides/3.7/user-guide/bind_paths_and_mounts.html
[fuse]: https://docs.kernel.org/filesystems/fuse.html
[squashfs]: https://docs.kernel.org/filesystems/squashfs.html

# FUSE

[FUSE (Filesystem in Userspace)][fuse] is a software interface for Unix-like computer operating systems that allows non-privileged users to create their own file systems without editing kernel code. It consists of a kernel module (`fuse.ko`), a userspace library (`libfuse.*`), and a mount utility (`fusermount`). This framework offers flexibility by enabling the mounting of filesystems in userspace.

## Squashfs

[Squashfs][squashfs] is a compressed read-only filesystem for Linux, optimized for archival and constrained environments. On HPC systems like LUMI, it reduces the load on parallel filesystems like Lustre by packaging numerous small files into a single, compressed file.

### Creating a Squashfs Filesystem

The `mksquashfs` utility creates Squashfs filesystems. For instance, to compress a directory `data` into a Squashfs filesystem named `data.sqsh`:

```bash
$ mksquashfs data data.sqsh -processors 4
```

### Squashfs with Containers

The easiest way to use squashfs filesystems is [mounting them on Singularity containers][singularity_mounts]. Using the `data.sqsh` we just created, it can be made available in the container as shown below.

```bash
# Run Singularity, mounting my data to '/input-data' in the container.
$ singularity run -B data.sqsh:/input-data:image-src=/ mycontainer.sif
Singularity> ls /input-data/
1  2  3  4  5  6  7  8  9
```

## Squashfs and FUSE


Through FUSE, Squashfs filesystems can also be mounted in the userspace with the command `squashfuse_ll` (lower level, faster version of `squashfuse`), which is also available on LUMI. This can be useful in cases where container use is unwanted. However, this process is slightly more complicated. The FUSE-mounted filesystem is only visible on the node on which you run the FUSE mount command. Even if you mount a FUSE-based filesystem inside shared filesystem (like Lustre that LUMI uses), that FUSE mount is local to the node where you ran `squashfuse_ll` and won't be visible on other client nodes. Additionally, in order to avoid broken mount endpoints, filesystems mounted via `squashfuse_ll` have to be explicitly unmounted with `umount`. If this is not done, 'Transport endpoint is not connected' errors can appear when using the same node and mountpoint going forward.

Below is a script `mount.sh` that mounts the squashfs filesystem `data.sqsh` onto a directory `$MOUNT_DIR`. This is done on only one process (local rank 0 in this case) of each node using the environment variable `$SLURM_LOCALID` that Slurm provides. The first process on each node mounts the filesystem, then all processes execute the code, and finally the first process also unmounts the filesystem.

In your batch script, if you would usually call your code like `srun ./my-program`, then in this case it would be replaced by `srun ./mount.sh` in which your code would also be called.

```bash
#!/bin/bash
MOUNT_DIR='/scratch/project_xxxxxxxxx/mountpoint'

if [ "$SLURM_LOCALID" -eq 0 ]; then
    if mountpoint -q "$MOUNT_DIR"; then
        umount "$MOUNT_DIR"
    elif [ -d "$MOUNT_DIR" ]; then
        rm -rf "$MOUNT_DIR"
    fi
    sleep 1

    mkdir -p "$MOUNT_DIR"
    sleep 1

    if squashfuse_ll data.sqsh "$MOUNT_DIR"; then
        echo "SquashFS mounted successfully."
    else
        echo "Error: Failed to mount SquashFS." >&2
        exit 1
    fi
fi
sleep 5

./my-program

sleep 10
if [ "$SLURM_LOCALID" -eq 0 ] && mountpoint -q "$MOUNT_DIR"; then
    umount "$MOUNT_DIR"
    echo "Unmounted"
fi
```
