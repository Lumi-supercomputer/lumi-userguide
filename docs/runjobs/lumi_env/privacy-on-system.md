# Privacy of jobs and data on LUMI

These pages gives you information about privacy settings on LUMI, i.e., who else can see your data and activity on LUMI. This page is not meant to be a comprehensive security guide, and may not succeed in listing all relevant items and points. This page simply aims for users to understand better what implications working in a shared HPC system like LUMI has on privacy, and is more of a list of things that you may want to consider when working on LUMI. For the legal documents of data processing on LUMI, see the [LUMI Terms and Policies documents](https://lumi-supercomputer.eu/termsandpolicies/).

This page is strictly about LUMI itself. LUMI-O (object storage system) and LUMI-K (small Kubernetes services cloud) have a different security model. Please visit the pages for [LUMI-K](https://docs.lumi-supercomputer.eu/runjobs/lumi-k/security_guide/) and [LUMI-O](../../storage/lumio/index.md#security-aspects) for additional information. 

Regardless of what usage information we are talking about, the system administrators can view all information on LUMI. 
LUMI User Support Team members are not part of the system administrators' team though and do not have full access 
to all information.


## User account and project information

Account and project information is visible for LUMI operative and support personnel.

What other users can see about your account information:   

  - All users in the system can see your first name, last name, username, and associated project numbers.
  - All users in the system can see your username and userid when you submit jobs.
  - All users can see the last time you logged in on any login node with the `last` command.
  - Users who share a project with you can see your first name, last name, and username with that project's information.

What information is visible about your project:   

  - All project members can see the project information. This contains the project name and title, short description of the project, list of project members, project owner, allocated and used billing units, project open and closed dates, etc. 
  - All users in the system can see your project number (associated with project members names and usernames), but not, e.g., the project title. 
  - LUMI personnel can monitor your resource usage (billing units, storage, etc.)
  


## Contents in home directory, project directories and temporary locations

The project directories in this context are all directories associated to a project, so the project-specific subdirectories in 
`/project`, `/scratch` and `/flash`.

- The contents of a home directory is only visible for the owner of that directory. 

- The contents of project directories is by default visible and accessible for all members of the project.

- The temporary location `/tmp` on login nodes (separate on each login node) is personal, and other users can't see the contents in there.

- The temporary location `/local/tmp` on login nodes (separate on each login node) is shared by everyone on the same login node (all users in the system). 


The command `ls -l` shows you the permissions of contents in the current directory.

!!! warning  
    The permissions for directories and files work in a similar manner to a regular UNIX file system. If you give permissions to some content for the group 'others', depending on the content location on LUMI, the content may be accessible for all other LUMI users.




## Commands you run 

The commands you run on shared nodes are visible for the other users on the same node. If the command launches a process that stays running, other users can see the details of the running process, e.g., your username, the command that launched the process including command line arguments, and details about resource usage of that command. 

It's a good guideline to keep in mind that many regular UNIX system logic also applies to the LUMI nodes. Other users on the same node can observe your processes. 

Shared nodes in this context are all the LUMI login nodes, and the nodes on the shared computing partitions (including the login node shell in LUMI web interface). 

The commands you run on the exclusive compute nodes (partitions `standard` and `standard-g`) are only visible for you/your job.



## Batch jobs

Other users can see information about your batch jobs submitted to the system, e.g., with the slurm command `squeue`.

Visible for all is your username, project number, name of the job, state of the job, what kind of resources you have requested (number of nodes, partition, walltime), which exact nodes your job is using, and, e.g., the submit command that you used to launch the job including any command line arguments that you used, and names of directory paths from where the job was launched or where it writes output to.

Other users can also see information of your past jobs (e.g. with `sacct`).

## Compute nodes

On the exclusive partitions `standard` and `standard-g`, where you can only reserve full nodes, you are the only user on the node. This is true also if you reserve a full node from the shared partitions with the `--exclusive` flag. In these cases, there are no other users who could observe your processes or read your commands on the node, but as for all jobs on LUMI, other users can still see the job activity as described in [Batch jobs](#batch-jobs).  
The temporary directory `/tmp` that resides in node memory is cleaned after each job. 

On shared partitions (`small`, `small-g`, `dev-g`, `debug`, `largemem`, `lumid`) you should pay attention that there could be other users on these nodes that can observe the processes that are run on that node. (In the same way as [Commands you run](#commands-you-run).) 
On shared compute nodes all users on that node share the same `/tmp` location of the node. Everyone on the node can see the file names (and what kind of permission restrictions they have) in the shared `/tmp`. It then depends on the permissions of your files, if other users on the same node can access these files or not. After the job is finished, please consider deleting anything explicitly created by the job on `/tmp`. There is an automatic cleanup procedure to remove any leftover files of the job from `/tmp`, but this cleanup fails sometimes, so you shouldn't explicitly trust it.



## Environment variables 

The environment variables you set are only visible for yourself in the current session you have.



## What you can do to reduce information visibility


- Pay attention to naming: What are your jobs called, and how are the working directories are named.

- When using exclusive nodes, it's possible to hide the exact path of your input data from other users, by only moving into your data directory inside your job script. Other users can see about your job the directory path from where the job was submitted, but they can't see the actions that you take inside your job script or the processes when you are running the job. (On shared nodes, the processes are visible.)

- Pay attention to the command line arguments that you use: As the command line arguments can in many cases be viewed by other users in the system, don't give command line arguments that shouldn't be seen by other users.  







