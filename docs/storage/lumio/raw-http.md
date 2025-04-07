# Raw HTTP request


The LUMI-O object storage can be used by issuing HTTP request.

!!! warning

    We don't recommend using the HTTP API unless there is a specific need. The 
    other listed tools are easier to use. This section only serve as a reference
    on how to provide the credentials to the HTTP API. 

    See [Common error messages](error-messages.md) for explanations on some of
    the HTTP return codes. 

The example below upload the file `README.md` to the bucket `my-nice-bucket`
using `curl`:

```bash
export S3_ACCESS_KEY_ID=<MY_ACCESS_KEY>
export S3_SECRET_ACCESS_KEY=<MY_SECRET_ACCESS_KEY>

file=README.md
bucket=my-nice-bucket
resource="/${bucket}/${file}"
contentType="text/plain"
dateValue=`date -R`
stringToSign="PUT\n\n${contentType}\n${dateValue}\n${resource}"
s3Key=$S3_ACCESS_KEY_ID
s3Secret=$S3_SECRET_ACCESS_KEY
signature=`echo -en ${stringToSign} | openssl sha1 -hmac ${s3Secret} -binary | base64`
curl -X PUT -T "${file}" \
     -H "Host: https://lumidata.eu/" \
     -H "Date: ${dateValue}" \
     -H "Content-Type: ${contentType}" \
     -H "Authorization: AWS ${s3Key}:${signature}" \
      https://lumidata.eu/${bucket}/${file}
```


