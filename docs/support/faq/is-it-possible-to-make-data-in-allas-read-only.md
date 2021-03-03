# Is it possible to make data in Allas read-only?

## Inside a project  
Inside a project there is currently no _read-only_ mode in Allas. Each project member has full access to the data, which causes a risk: one can accidentally overwrite or delete data.


## Between projects 
You can give another project read-only access to your bucket with Swift{target="_blank"} or
s3cmd{target="_blank"}.


## Sharing URL
In addition, it is possible to make a bucket public, which makes the content available for viewing ('_read-only_') via URLs. The URL to an object in a public bucket is in form of <i>https://bucket_name.a3s.fi/object_name</i> or <i>https://a3s.fi/swift/v1/AUTH_PROJECT_ID/bucket_name/object_name</i> where <i>PROJECT_ID</i> is your computing project's identifier in UUID{target="_blank"} format.

## Additional guidance for setting the bucket public

* Web client{target="_blank"}
* Swift client{target="_blank"}
* S3 client{target="_blank"}
* a-commands{target="_blank"}
