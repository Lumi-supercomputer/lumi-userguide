# Python with boto3 library 


When use cases become sufficiently complex one might want to interact
with LUMI-O in a more programmatic fashion instead of using the 
command line tools. One such option is the AWS SDK for Python [boto3](https://pypi.org/project/boto3/)\*.

The script

```python
import boto3

session = boto3.session.Session(profile_name='lumi-465000001')
s3_client = session.client('s3')
buckets=s3_client.list_buckets()
```

Would fetch the buckets of project 465000001 and return the information as a python dictionary. 
For the full list of available functions, see the [aws s3 client documentation](https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/s3.html)


If a default profile has been configured `~/.aws/credentials`
the client creation can be shortened to:

```python
import boto3
s3_client = boto3.client('s3')
```

boto3 uses the same configuration files and respects the same environment variables as the `aws` cli.

!!! note 
	You will need a sufficiently new version of boto3 (e.g version 1.26, which is installed if using python3.6, is too old) for it
	to understand a default profile set in ~/.aws/credentials and corresponding config file, 
	otherwise the tool will always default to aws s3 endpoint and you will need to specify the
	profile/endpoint when constructing the client.

\*_If you prefer to work with some other language there are also options for e.g Java, GO and Javascript_


You can create a configuration format for boto3 in [auth.lumidata.eu](https://auth.lumidata.eu) to access LUMI-O directly with boto3 e.g. from your local machine. 

After creating an access key, click the active key, and select "boto3" from the configuration formats. 