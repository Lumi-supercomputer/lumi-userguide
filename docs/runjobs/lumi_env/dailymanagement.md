# Daily management


On LUMI, the following commands are available to check information of your project allocations and quota:


## lumi-workspaces

This is the premier command to check the status of your quota and allocations.
Quota information is obtained directly from Lustre and is almost real-time, while
the information about your allocations is is gathered in the background on the 
system on a periodic basis and is not instantaneous.
The command also shows which filesystems house your account and projects.
The command does not take any command line options. 

Usage:
```
lumi-workspaces
```

The command basically combines the tasks of the next two commands, `lumi-quota` and
`lumi-allocations`, in a single command.


## lumi-quota

Shows quota of your projects. The information is obtained directly from Lustre, and is almost real-time.


Usage:

Information of all your projects: 
```
lumi-quota
```
Information of a specific project:
```
lumi-quota --project project_46XXXXXXX
```
Detailed output, including soft and hard quota (columns Quota and Limit respectively):
```
lumi-quota -v
```


## lumi-allocations

Shows active allocations and remaining billing units of your projects. The information from this command is gathered in the background on the system on a periodic basis and is not instantaneous.  

Usage:

  Information of all your projects: 
  ```
  lumi-allocations
  ``` 

  Information of a specific project: 
  ```
  lumi-allocations --project project_46XXXXXXX
  ```


## lumi-check-quota

Running this command shows warnings when running out of quota or allocations.
If none of your projects is about to run out of quota or allocations, no output is shown.

Usage:
```
lumi-check-quota
```

It is not really meant to be used directly, but it is used to show warnings at login.


## lumi-ldap-userinfo

Shows your user information kept in the LDAP directory.

This command also gives more information about the projects' quota,
but it is not as up to date as the information from `lumi-quota` command,
as the information for this command is only gathered in the background on a periodic basis. 

Usage:
```
lumi-ldap-userinfo
```


## lumi-ldap-projectinfo

Shows information of your projects kept in the LDAP directory, including allocations and quota. The information for this command is only gathered in the background on a periodic basis, and is not as up to date as the information from `lumi-workspaces` and `lumi-quota` commands.

Usage:
Information of all your projects:
```
lumi-ldap-projectinfo 
```
Information of a specific project:
```
lumi-ldap-projectinfo --project project_46XXXXXXX
```
