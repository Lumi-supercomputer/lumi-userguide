# Common error messages


### HTTP status code 400

The file is too large.
```bash
EntityTooLarge
```
### HTTP status code 403

You have reached a quota limit. If you need more quota in LUMI-O, please contact LUMI helpdesk.  
Please specify your current quota usage and the current allocated quota for your project in the request:
```bash
QuotaExceeded
```

### HTTP status code 403

Your credentials are not allowed to view the bucket:
```bash
AccessDenied
```

### HTTP status code 404

The bucket does not exist:
```bash
NoSuchBucket
```

### HTTP status code 409 

A bucket with that name already exists:
```bash
Conflict
```








