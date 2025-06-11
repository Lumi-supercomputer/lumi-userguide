# rclone

[rclone-manual]: https://rclone.org/docs/


For `rclone`, the LUMI-O configuration provides two kinds of remote endpoints: 

- **lumi-<project_number\>-private**: A private endpoint. The buckets and objects uploaded to this
              endpoint will not be publicly accessible.
- **lumi-<project_number\>-public**: A public endpoint. The buckets and objects uploaded to this
                endpoint will be publicly accessible using the URL:
                ```
                https://<project_number>.lumidata.eu/<bucket_name>`
                ```
                Be careful to not upload data that cannot be public to this
                endpoint.


The basic syntax of the `rclone` command is:

```text
rclone <subcommand> <options> source:path dest:path 
```

The table below lists the most frequently used `rclone` subcommands:

[rc_copy]:    https://rclone.org/commands/rclone_copy/
[rc_sync]:    https://rclone.org/commands/rclone_sync/
[rc_move]:    https://rclone.org/commands/rclone_move/
[rc_delete]:  https://rclone.org/commands/rclone_delete/
[rc_mkdir]:   https://rclone.org/commands/rclone_mkdir/
[rc_rmdir]:   https://rclone.org/commands/rclone_rmdir/
[rc_check]:   https://rclone.org/commands/rclone_check/
[rc_ls]:      https://rclone.org/commands/rclone_ls/
[rc_lsd]:     https://rclone.org/commands/rclone_lsd/
[rc_lsl]:     https://rclone.org/commands/rclone_lsl/
[rc_lsf]:     https://rclone.org/commands/rclone_lsf/

| rclone subcommand   | Description                                                                      |
| ------------------- | -------------------------------------------------------------------------------- |
| [copy][rc_copy]     | Copy files from the source to the destination                                    |
| [sync][rc_sync]     | Make the source and destination identical, modifying only the destination        |
| [move][rc_move]     | Move files from the source to the destination                                    |
| [delete][rc_delete] | Remove the contents of a path                                                    |
| [mkdir][rc_mkdir]   | Create the path if it does not already exist                                     |
| [rmdir][rc_rmdir]   | Remove the path                                                                  |
| [check][rc_check]   | Check if the files in the source and destination match                           |
| [ls][rc_ls]         | List all objects in the path, including size and path                            |
| [lsd][rc_lsd]       | List all directories/containers/buckets in the path                              |
| [lsl][rc_lsl]       | List all objects in the path, including size, modification time and path         |
| [lsf][rc_lsf]       | List the objects using the virtual directory structure based on the object names |

A more extensive list can be found on the [Rclone manual pages][rclone-manual]
or by typing the command `rclone` in LUMI.





