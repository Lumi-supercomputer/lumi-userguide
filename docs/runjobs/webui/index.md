# The LUMI web interface


## Intro

The web interface for LUMI at [www.lumi.csc.fi](https://www.lumi.csc.fi) can be used to access the supercomputer using only a web browser.

Features available in the web interface:

- View, download and upload files
- Open a shell on the login node
- Open a persistent shell on a compute node
- View running batch jobs
- Launch interactive apps and connect to them directly from the browser:
    - Desktop with support for GPU acceleration
    - Julia-Jupyter
    - Jupyter
    - Jupyter for courses: An interactive Jupyter session specifically for courses
    - TensorBoard
    - Visual Studio Code
 
!!! info
	The web interface is still under development so expect 
	additional features and further polishing. 

## Connecting

See the section in [First steps](../../firststeps/loggingin-webui.md) for how to connect to LUMI using the web interface. 

After connecting, you can browse your files on the supercomputer, start a shell, view running jobs or start one of the many available applications. The dashboard also contains some important system information.

## Available features

### Shell

The shell apps can be found under Pinned apps or on the top navbar under the _Tools_ section.
There are two different shells.

The _Login node shell_ launches a normal Linux shell on one of the login nodes.
Any command that is running when the login shell browser tab is closed will stop.
Note that the same rules apply here as during a normal ssh session from a terminal.
**Login nodes are only for light pre/postprocessing**. 

![Interactive login shell](../../assets/images/wwwLumiShell.png)

The _Compute node shell_ launches a persistent shell on a compute node for heavier commands that should not be run on login nodes.
The persistent shell will keep running even if you close your browser or lose internet connection.

### Files

The file browser can be opened using the _Files_ section on the top navbar (this displays a list of all project disk areas), or using 
the shortcut to the home folder on the front page. In the file browser
you can upload/download files, create new files and directories, or open a shell in the current directory. 

!!! note
    Uploaded files will overwrite existing files with the same name without prompting.
    Currently the maximum size for individual file uploads is 10GB


![File browser view](../../assets/images/wwwLumiFiles.png)

Clicking on a file will open it in a view-only mode. For more options like editing, renaming and deleting, use the button with three dots next to the filename.   

The file browser comes with a basic text editor. Some important notes on that:

- If no changes have been made, the _save_ button is grayed out.
- There is no _save-as_ feature, so read-only files can not be edited.

LUMI-O can also be accessed if you have [configured the connection](../../storage/lumio/#configuring-the-lumi-o-connection)
using the _lumio-conf_ tool.
After running the configuration tool, you may need to restart the web server using the _Restart the webserver_ link in the _Help_ menu in the top navbar.
Shortcuts to the project storage spaces in LUMI-O that have valid authentication credentials will be visible in the file browser.


### Active Jobs

The _Active Jobs_ app can be found under the _Jobs_ section in the top navbar.
In the app you will be able to see your currently running and recently completed Slurm jobs.
By expanding the row for the job using the arrow on the left side more details about the job will be visible.


### Interactive applications

For instructions on how interactive applications work,
see the [generic instructions on interactive applications](./interactive-apps.md),
or the applications specific instructions:

- [Desktop](./desktop.md)
- [Julia-Jupyter](./julia-jupyter.md)
- [Jupyter](./jupyter.md)
- [Jupyter for courses](./jupyter-for-courses.md)
- [TensorBoard](./tensorboard.md)
- [Visual Studio Code](./vscode.md)
