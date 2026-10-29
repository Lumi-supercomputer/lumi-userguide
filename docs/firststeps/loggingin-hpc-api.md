# REST HPC API (Advanced Users)

!!! info
	This mode of access is meant for advanced users. To get started please connect to LUMI using an [ssh client](loggingin.md) or the [webinterface](loggingin-webui.md).

LUMI offers REST API access through the FirecREST HPC API, which provides a standardized RESTful HTTP interface for accessing computing resources on LUMI.
It offers APIs for managing jobs through Slurm scheduler, performing file system operations over personal and project data, and for transferring large amounts of data to or from the system.

It is an ideal solution for building automated access to computing resources, as well as for creating and running personal web-based client applications that consume computing resources.

Access is authorized with personal access tokens, which you can generate with the [FirecREST authentication tool](https://www.lumi.csc.fi/pun/sys/dashboard/custom/firecrest_auth) (in the [web interface](loggingin-webui.md) under *Tools* > *FirecREST authentication tool*).

Read more in the [FirecREST documentation](./../development/api/firecrest.md).