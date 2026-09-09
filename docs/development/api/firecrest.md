[firecrest-token]: https://my.csc.fi/firecrest-token
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
[api-upload]: https://api.lumi.csc.fi/v1/docs#/filesystem/post_upload_filesystem__system_name__transfer_upload_post
[api-download]: https://api.lumi.csc.fi/v1/docs#/filesystem/post_download_filesystem__system_name__transfer_download_post

# FirecREST HPC API

The FirecREST HPC API provides a standardized RESTful HTTP interface for accessing computing resources on LUMI. It offers APIs for managing jobs through Slurm scheduler, performing file system operations over personal and project data, and for transferring large amounts of data to or from the system.

It is an ideal solution for building automated access to computing resources, as well as for creating and running personal web-based client applications that consume computing resources.

## How to get access to the API?
!!! warning "Robot Accounts"
    In order to use the REST API for building more serious integrations, such as CI pipelines or building web applications, you can request a machine-to-machine robot account to be created for your project.
    These are not available yet.

All LUMI users can use the FirecREST HPC API using time-limited personal access tokens. This effectively allows using the REST API as an alternative to a direct SSH connection, as all API operations are executed on LUMI using your account identity and privileges.

Personal access tokens can be generated:

- via an App in the LUMI Webinterface (all users, pending)
- [https://my.csc.fi/firecrest-token][firecrest-token] (Finnish CSC account only)

## Connecting to LUMI FirecREST HPC API

!!! warning "Access tokens are secrets"
    Access tokens issued for FirecREST HPC API allow the token holder to interact with Slurm jobs, and read, manipulate and transfer data with your privileges. Don't share your access token with anyone.

LUMI FirecREST HPC API endpoints can be found under the URL [https://api.lumi.csc.fi][api-base]. The service uses versioned URL scheme, where the first element of the URL path represents the API generation. The current, latest API generation is `v1`. It is based on the latest release of FirecREST v2.

Possible major or breaking changes to the API will be released as new API generation. By default, a new release will not replace any existing APIs. Earlier generations will be maintained and kept available.

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

### Connecting with a personal access token

FirecREST HPC API can be used with personal access tokens, which allow access to the same computing resources and projects as your direct terminal access. Personal access tokens are useful for running desktop applications or automation utilities in interactive terminals, that integrate with HPC resources using [PyFirecREST][pyfirecrest] Python SDK, for example.

As the name suggests, personal access tokens are intended for personal use.

A personal access token can be retrieved from

- via an App in the LUMI Webinterface (all users, pending)
- Finnish CSC account only: From the [MyCSC portal][firecrest-token]. Note that there's no direct link from the portal itself yet. You can view and revoke your active tokens at [CSC IdP federated personal profile page][csc-idp-profile], under *Connected organizations* -> *Firecrest-access-tokens*.

Personal access tokens are valid for 24 hours at a time.

## Large file transfer using S3

FirecREST HPC API implements asynchronous large file transfer model using an S3 object storage as a staging medium. On LUMI, the S3 storage used is [LUMI-O][lumio]. FirecREST uses its own dedicated tenant with dynamically created user-specific buckets.

### How it works

Upon sending an API request to [upload][api-upload] or [download][api-download] task, FirecREST:

- Creates a user-specific bucket in its own LUMI-O tenant.
- Generates pre-signed S3 URLs for the data transfer, using multi-part model if necessitated by the given `fileSize`.
- Schedules a new Slurm DataTransferJob using `account` (your project) defined in the API request, to either transfer files from LUMI-O to LUMI after your upload is completed, or from LUMI to LUMI-O for you to download.
- Returns pre-signed URLs to API client for transferring the data.

### Examples

Various detailed examples for implementing S3 data transfer using bash, .NET and PyFirecREST can be found in [FirecREST v2 user guide][firecrest-v2-userguide].

## PyFirecREST

PyFirecREST is a Python SDK library for interacting with FirecREST API, and the HPC resources available via the API.

The package is available in [PyPI][pypi]. It can be installed with a simple `pip` call:

```bash
python3 -m pip install pyfirecrest
```

Please see the [PyFirecREST documentation from CSCS][pyfirecrest-docs] for tutorials and API reference. FirecREST HPC API on LUMI only supports [PyFirecREST API v2][pyfirecrest-api-v2].


### Using with personal access tokens

The PyFirecREST library ships with one built-in authorization class, `ClientCredentialsAuth`, which is suitable for use with robot accounts.

In order to use the library with personal access token, a separate Authorization object needs to be created for the `firecrest.v2.Firecrest` client. In this example, we create a "pass-through" authorization class which reads the token from environment variable `FIRECREST_TOKEN`, makes sure it has not expired, and then hands it over to the `firecrest.v2.Firecrest` client as-is:

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

### FirecREST CLI

PyFirecREST also ships with a handy command line utility `firecrest` for interacting with FirecREST APIs. It implements support for OIDC client credentials based authentication, which can be used with robot accounts, as well as support for getting or setting an access token with an arbitrary shell command starting from version `v3.8.0`.

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