# restic


`restic` is a slightly different from `rclone` and `s3cmd` and is mainly used
for doing backups. 

**Set up the restic repository**

```bash
$ export AWS_ACCESS_KEY_ID=<MY_ACCESS_KEY>
$ export AWS_SECRET_ACCESS_KEY=<MY_SECRET_ACCESS_KEY>
$ restic -r s3:https://lumidata.eu/<bucket> init
```

After this we can run commands like `restic restore` and `restic backup`. the
`-r` flag with the correct bucket and the KEY environment variables are always
needed when running `restic` commands.

For more information, see the [Restic documentation](https://restic.readthedocs.io/en/stable/index.html)



