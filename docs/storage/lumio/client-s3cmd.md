# s3cmd


The syntax of the `s3cmd` command:

```bash
s3cmd -options <command> parameters
```

The most commonly used _s3cmd_ commands:

| s3cmd command      | Function |
| :----------------- | :--------------------------- |
| mb                 | Create a bucket              |
| put                | Upload an object             |
| ls                 | List objects and buckets     |
| get                | Download objects and buckets |
| cp                 | Move object                  |
| del                | Remove objects or buckets    |
| md5sum             | Get the checksum             |
| info               | View metadata                |
| signurl            | Create a temporary URL       |
| put -P             | Make an object public        |
| setacl --acl-grant | Manage access rights         |


The table above lists only the most essential `s3cmd` commands. For more
complete list, visit the [s3cmd manual page](https://s3tools.org/usage) or type:

```text
s3cmd -h
```

If you need to make uploaded objects or buckets public you can add the `-P, --acl-public` flag
to `s3cmd put`. 

