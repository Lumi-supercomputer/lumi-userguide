# How to check your utilized LUMI-O quota

Quota limits:

- The default allocated quota per LUMI project is 150 TB. 
- One project can have up to 1000 buckets
- One bucket can have up to 500 000 objects

If you need more storage space in LUMI-O, please contact the LUMI helpdesk. 


## LUMI web interface

Currently one can check the sizes of objects in a bucket, but the total sizes of buckets are not shown, or the total used quota. 

The number of lines/rows in a bucket is the same as the number of objects in the bucket.

The number of lines/rows for the list of buckets is the number of buckets.


## LUMI-O authentication web site 

The table on [auth.lumidata.eu](https://auth.lumidata.eu/) shows the allocated quota for your project, and the current used LUMI-O quota for your project. This information is updated with a delay. 


## Command line

When connected to LUMI-O, the used quotas can be checked e.g. with `rclone` or `s3cmd`:

### rclone

Replace 46YXXXXXX with your LUMI project number.

- Number of buckets:

    `rclone lsd lumi-46YXXXXXX-private: | wc -l`

- Number of objects in a bucket 'mybucket':

    `rclone lsd lumi-46YXXXXXX-private:mybucket | wc -l`

- Used quota by the project:

    `rclone size lumi-46YXXXXXX-private:`


### s3cmd

- Number of buckets:

    `s3cmd ls s3: | wc -l`

- Number of objects in a bucket 'mybucket':

    `s3cmd ls s3://mybucket | wc -l`

- Used quota by the project:

    `s3cmd du`

