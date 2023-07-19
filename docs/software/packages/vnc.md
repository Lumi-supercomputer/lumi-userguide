# VNC

VNC (Virtual Network Computing) is a type of client application that can be used for interacting with graphical applications. 

The lumi-VNC modules that are pre-installed on LUMI as EasyBuild recipes provide containerized versions of the [TurboVNC](https://turbovnc.org/About/Introduction) server. These can be used for remote graphics until the OpenOnDemand graphical user interface is available on LUMI.

Connecting with a VNC client such as [TigerVNC](https://tigervnc.org/) or TurboVNC (or via web browser) requires setting up ssh port forwarding from your laptop/desktop to LUMI. Instructions how to do this and which ports to use will be printed when starting the VNC server. 

Don't expect a full-featured desktop environment: The X server runs the fluxbox.org window manager but currently does not support any desktop environment.


## Available VNC modules on LUMI

See the versions of VNC available and more detailed information [on the page in the software library](https://lumi-supercomputer.github.io/LUMI-EasyBuild-docs/l/lumi-vnc/)

Check which modules are available on the system and get usage information with `module spider lumi-vnc`.
In a basic case, you do not need to load any modules prior to loading a `lumi-vnc` module. The lumi-vnc modules are pre-installed on the system, and available to load if the `init-lumi/0.2` module is loaded (as it is, by default). 


## Using lumi-VNC

After loading a VNC module, the `start-vnc` command is defined (as a shell function) and can be used to start the VNC server. That will print information on how to connect to the server either using a web browser or a VNC client, e.g., the TigerVNC client used in the output or the TurboVNC client.

See available command line options of the `start-vnc` command with:
```
start-vnc -h
```

After starting the server, the following additional commands become available in the shell where the VNC server was started:

 - `stop-vnc` : This will stop the VNC server and clean up the shell.

 - `vnc-info` : This prints the connection information to the VNC server, i.e., repeats the output already shown by the start-vnc command.

 - `vnc-status` : Returns exit code 0 if the VNC server is running, nonzero otherwise.

Note that exiting the shell from which you called `start-vnc` will shut down the VNC server and hence cause all applications using it to fail.

After starting the VNC server you can run any X11 GUI program in the shell from which you started the VNC server. The DISPLAY variable will be set up correctly to do so. If you want to do so from another shell on the same node, you'll have to set the `DISPLAY` variable first to the value indicated by `start-vnc` or `vnc-info`, e.g.,
```
export DISPLAY=:1
```

The TurboVNC server started by `start-vnc` will create a log file in $HOME/.vnc which can be useful for debugging problems.
