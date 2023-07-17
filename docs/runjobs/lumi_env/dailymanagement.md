# Daily management

On LUMI there are available following commands to check information of your project allocations and quota:


## lumi-workspaces

Shows quota and allocations of your projects as obtained directly from Lustre. The command does not take any command line options. 

Usage:
```
lumi-workspaces
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
    

## lumi-quota

Shows quota of your projects. The information is obtained directly from Lustre. 

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


