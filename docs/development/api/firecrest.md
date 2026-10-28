[firecrest-auth-app]: https://www.lumi.csc.fi/pun/sys/dashboard/custom/firecrest_auth
[firecrest-token-mycsc]: https://my.csc.fi/firecrest-token
[api-base]: https://api.lumi.csc.fi
[api-openapi]: https://api.lumi.csc.fi/v1/openapi.json
[api-docs]: https://api.lumi.csc.fi/v1/docs
[pyfirecrest]: #pyfirecrest
[csc-idp-profile]: https://user-auth.csc.fi/idp/profile/userprofile
[firecrest-v2-userguide]: https://eth-cscs.github.io/firecrest-v2/user_guide/#using-s3-transfer-method
[pypi]: https://pypi.org/project/pyfirecrest/
[pyfirecrest-docs]: https://pyfirecrest.readthedocs.io/en/stable/index.html
[pyfirecrest-api-v2]: https://pyfirecrest.readthedocs.io/en/stable/reference_v2_index.html
[lumio]: ./../../storage/lumio/index.md
[api-ops-upload]: https://api.lumi.csc.fi/v1/docs#/filesystem/post_upload_filesystem__system_name__ops_upload_post
[api-ops-download]: https://api.lumi.csc.fi/v1/docs#/filesystem/get_download_filesystem__system_name__ops_download_get
[api-transfer-upload]: https://api.lumi.csc.fi/v1/docs#/filesystem/post_upload_filesystem__system_name__transfer_upload_post
[api-transfer-download]: https://api.lumi.csc.fi/v1/docs#/filesystem/post_download_filesystem__system_name__transfer_download_post

# FirecREST HPC API

The FirecREST HPC API provides a standardized RESTful HTTP interface for accessing computing resources on LUMI. It offers APIs for managing jobs through Slurm scheduler, performing file system operations over personal and project data, and for transferring large amounts of data to or from the system.

It is an ideal solution for building automated access to computing resources, as well as for creating and running personal web-based client applications that consume computing resources.

## How to get access to the API?

All LUMI users can access the FirecREST HPC API with time-limited personal access tokens. This effectively provides an alternative to a direct SSH connection, as all API operations are executed on LUMI using your account identity and privileges. Tokens give the same access as your SSH login and are meant for personal use, such as desktop applications or scripts using [PyFirecREST][pyfirecrest].

Personal access tokens are generated with the FirecREST authentication tool in the LUMI web interface. To open it, either:

- go directly to the [FirecREST authentication tool][firecrest-auth-app], or
- log in to the [LUMI web interface](../../runjobs/webui/index.md) and select *Tools* > *FirecREST authentication tool* from the top menu.

!!! note "Alternative for CSC users"
    Users with a Finnish CSC account can also generate tokens from the [MyCSC portal][firecrest-token-mycsc]. There is no direct link to this page from the portal itself.

Personal access tokens are valid for 24 hours at a time.

!!! warning "Access tokens are secrets"
    Access tokens issued for FirecREST HPC API allow the token holder to interact with Slurm jobs, and read, manipulate and transfer data with your privileges. Don't share your access token with anyone.

### Revoking access tokens

Revoke a token immediately if it may have been exposed, for example if it was committed to a public repository or pasted into a chat or email.

You can revoke your active tokens at the [CSC IdP personal profile page][csc-idp-profile]:

1. Open *Connected organizations*.
2. Expand the *LUMI FirecREST* section (tokens from the FirecREST authentication tool) or the *Firecrest-access-tokens* section (tokens from the MyCSC portal).
3. Click *Revoke now*.
4. Generate a new token if needed.

!!! warning "Robot Accounts"
    Machine-to-machine robot accounts for more serious integrations, such as CI pipelines or web applications, are not available on LUMI yet.

## Connecting to LUMI FirecREST HPC API

LUMI FirecREST HPC API endpoints can be found under the URL [https://api.lumi.csc.fi][api-base]. The service uses versioned URL scheme, where the first element of the URL path represents the API generation. The current API generation is `v1`. It is based on FirecREST v2.

Possible major or breaking changes to the API will be released as new API generation. By default, a new release will not replace any existing APIs. Earlier generations will be maintained and kept available.

On LUMI, the API exposes a single system named `lumi`, which covers all partitions. The system name is part of the endpoint paths, for example `/v1/compute/lumi/jobs`.

### API documentation

Up-to-date API specification for `v1` is available in OpenAPI format at [https://api.lumi.csc.fi/v1/openapi.json][api-openapi] and it can be viewed through FirecREST's Swagger UI at [https://api.lumi.csc.fi/v1/docs][api-docs].

### Connecting to the API

FirecREST HPC API uses JWT bearer tokens as authorization method. Accepted tokens are issued by CSC authentication and authorization infrastructure (AAI) identity provider (IdP). Only those tokens that have been specifically issued to be used with FirecREST HPC API (indicated by `aud` member in the JWT) are accepted by the API.

In order to connect to an API endpoint, tokens are sent to FirecREST using standard `Authorization` header, example:

```bash
access_token="<JWT>"
curl -X GET https://api.lumi.csc.fi/v1/compute/lumi/jobs \
  -H "Authorization: Bearer ${access_token}"
```

Authorization header must be present in every API request sent to FirecREST. Token validity is verified on server-side for each request. An attempt to use invalid access token will result in a `HTTP 401 Unauthorized` return code, with a specific error message recorded in a JSON document in the response body.

All requests sent to the API are executed on LUMI using the same user account that was used to retrieve the access token. For example, with a personal access token, all commands run via FirecREST are executed as you on the target system.

## Uploading and downloading files

Which endpoints you use depends on the file size:

- **Files up to 32 MiB:** use [`/filesystem/lumi/ops/upload`][api-ops-upload] and [`/filesystem/lumi/ops/download`][api-ops-download]. The file is sent directly with the request.
- **Larger files:** use [`/filesystem/lumi/transfer/upload`][api-transfer-upload] and [`/filesystem/lumi/transfer/download`][api-transfer-download]. The file passes through [LUMI-O][lumio], which acts as a temporary drop-off point.

FirecREST doesn't choose the endpoints for you; your client does. PyFirecREST chooses automatically, but with a lower default limit (see [File transfers with PyFirecREST](#file-transfers-with-pyfirecrest)).

For transfers through LUMI-O:

- **Upload:** you put the file on LUMI-O, and FirecREST moves it to LUMI.
- **Download:** FirecREST puts the file on LUMI-O, and you fetch it from there.

FirecREST tells you where to upload or download the file, so you don't need your own LUMI-O account or credentials. Files on LUMI-O are deleted automatically after a while, so download them soon after the transfer and don't use LUMI-O to store them.

The temporary storage is free. The step that moves the file between LUMI-O and LUMI runs as a Slurm job, which is billed to the project you give as `account` in the request, for example `project_465000000`.

??? note "How it works in detail"
    When you request an upload or download, FirecREST:

    1. Creates a user-specific bucket in its own LUMI-O storage area.
    2. Generates pre-signed S3 URLs for the transfer. For uploads, large files are split into multiple parts, based on the `fileSize` you give in the request.
    3. Schedules a Slurm data transfer job under your `account`. The job moves the file from LUMI-O to LUMI after an upload, or from LUMI to LUMI-O for a download.
    4. Returns the pre-signed URLs to your client.

    The URLs need no S3 credentials. To upload, `PUT` each part, then send the "complete multipart upload" request. To download, wait for the transfer job to finish, then `GET` the file. PyFirecREST does this for you.

For examples using bash, .NET and PyFirecREST, see the [FirecREST v2 user guide][firecrest-v2-userguide].

## PyFirecREST

PyFirecREST is a Python SDK library for interacting with FirecREST API, and the HPC resources available via the API.

The package is available in [PyPI][pypi]. It can be installed with a simple `pip` call:

```bash
python3 -m pip install pyfirecrest
```

Please see the [PyFirecREST documentation from CSCS][pyfirecrest-docs] for tutorials and API reference. FirecREST HPC API on LUMI only supports [PyFirecREST API v2][pyfirecrest-api-v2].

### Using with personal access tokens

To use PyFirecREST with a personal access token, you need to create an authorization object for the `firecrest.v2.Firecrest` client. In this example, we create a "pass-through" authorization class which reads the token from environment variable `FIRECREST_TOKEN`, makes sure it has not expired, and then hands it over to the `firecrest.v2.Firecrest` client as-is:

```python
import os
import time
import jwt

class TokenAuth:
    def __init__(self):
        pass

    # Use PyJWT to decode the token and verify expiration time.
    # Return False if decoding fails (input is not valid JWT) or if the token has expired
    def _is_token_valid(self, token: str) -> bool:
        try:
            payload = jwt.decode(token, options={"verify_signature": False, "verify_exp": False, "verify_aud": False})
            return time.time() <= payload["exp"]
        except Exception:
            return False

    # A PyFirecREST Authorization object is required to have method get_access_token(),
    # which, when called, will return a valid JWT access token.
    def get_access_token(self):
        token = os.getenv('FIRECREST_TOKEN', None)
        if not token:
            raise RuntimeError("Environment variable FIRECREST_TOKEN is not defined.")
        if not self._is_token_valid(token):
            raise RuntimeError("Token is invalid or has expired.")
        return token

import firecrest as fc
firecrest = fc.v2.Firecrest(firecrest_url="https://api.lumi.csc.fi/v1", authorization=TokenAuth())

# Example: Call the userinfo endpoint on LUMI to verify FirecREST API connection
try:
    userinfo = firecrest.userinfo(system_name="lumi")
    print(f"Userinfo endpoint returned:\n{userinfo}")
except fc.FirecrestException as e:
    print(f"FirecREST error: {e}")
except Exception as e:
    print(f"System error: {e}")

```

PyFirecREST also ships with a built-in authorization class, `ClientCredentialsAuth`, for robot accounts. Robot accounts are not yet available on LUMI.

### File transfers with PyFirecREST

The `upload()` and `download()` methods of `firecrest.v2.Firecrest` choose the transfer method automatically based on file size. Files smaller than `MAX_DIRECT_UPLOAD_SIZE` are transferred directly, and larger files go through [LUMI-O](#uploading-and-downloading-files).

By default, `MAX_DIRECT_UPLOAD_SIZE` is 1 MiB, which is lower than the 32 MiB limit on LUMI. To transfer files up to 32 MiB directly, without staging them on LUMI-O and running a Slurm job, raise the limit on your client:

```python
import firecrest as fc

# Or reuse the client from the example above
firecrest = fc.v2.Firecrest(firecrest_url="https://api.lumi.csc.fi/v1", authorization=TokenAuth())
firecrest.MAX_DIRECT_UPLOAD_SIZE = 33554432  # 32 MiB, LUMI's limit for direct transfers
```

For files that go through LUMI-O, pass your project as `account`, for example `firecrest.upload(..., account="project_465000000")`. The Slurm job that moves the file is billed to this project.

### FirecREST CLI

PyFirecREST also ships with a handy command line utility `firecrest` for interacting with FirecREST APIs. It implements support for OIDC client credentials based authentication, which can be used with robot accounts (not yet available on LUMI), as well as support for getting or setting an access token with an arbitrary shell command starting from version `v3.8.0`.

#### Using CLI with personal access token

We can use the `--token-command` (env `FIRECREST_TOKEN_COMMAND`) option of `firecrest` CLI to supply the personal access token to the utility:

```bash
# Copied and pasted access token
access_token="<JWT>"

# Set up URL and token command using environment variables.
export FIRECREST_URL=https://api.lumi.csc.fi/v1
export FIRECREST_TOKEN_COMMAND="echo ${access_token}"

# Example: query the userinfo endpoint on LUMI
firecrest id -s lumi
```