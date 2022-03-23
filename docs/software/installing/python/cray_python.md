# Installing and using packages with Cray Python

The HPE Cray distribution provides Python 3 along with some of the most
common packages used for scientific computation and data analysis. These
include:

  - numpy and scipy - built using GCC against HPE Cray LibSci
  - mpi4py - built using GCC against HPE Cray MPICH
  - dask

The HPE Cray Python distribution can be loaded (either on the front-end
or in a submission script) using:

    module load LUMI/21.12  # First load the LUMI software stack
    module load cray-python # Python version depends on LUMI module loaded

!!! tip
    The HPE Cray Python distribution provides Python 3. There is no Python 2
    version as Python 2 is now deprecated.

!!! tip
    The HPE Cray Python distribution is built using GCC compilers. If you wish
    to compile your own Python, C/C++ or Fortran code to use with HPE Cray
    Python, you should ensure that you compile using `PrgEnv-gnu` to make sure
    they are compatible.

## Adding your own packages

If the packages you require are not included in the HPE Cray Python
distribution, further packages can be added using `pip`.  We recommend either
installing them globally for your user account, as described in this section,
or into virtual environments, see [next section](#setting-up-virtual-environments).

Installing packages for your user account is in principle as simple as calling
`pip`.  However, as the /home file systems are not available on the compute
nodes, you will need to modify the default install location that `pip` uses to
point to a location on the /work file systems (by default, `pip` installs into
`$HOME/.local`). To do this, you set the `PYTHONUSERBASE` environment variable
to point to a location on /work, for example:

    export PYTHONUSERBASE='/projappl/project_XXXX/.local'

You will also need to ensure that:

1. the location of commands installed by `pip` are available on the command
   line by modifying the `PATH` environment variable;
2. any packages you install are available to Python by modifying the
   `PYTHONPATH` environment variable.

You can do this in the following way (once you have set `PYTHONUSERBASE` as described
above):

    export PATH=$PYTHONUSERBASE/bin:$PATH
    export PYTHONPATH=$PYTHONUSERBASE/lib/python3.9/site-packages:$PYTHONPATH

Please check that the correct python version (e.g. python3.9) in the above
command is used.

We would recommend adding all three of these commands to your `$HOME/.bashrc`
file to ensure they are set by default when you log in to LUMI.

Once, you have done this, you can use `pip` to add packages on top of the HPE
Cray Python environment. This can be done using:

    module load LUMI/21.12 cray-python
    pip install --user <package_name>

This uses the `--user` flag to ensure the packages are installed in
the directory specified by `PYTHONUSERBASE`.

## Setting up virtual environments

Sometimes, you may need several different versions of the same package
installed, for example, due to dependency issues. Virtual environments allow
you to manage these conflicting requirements.  We recommend that you use `venv`
to manage your Python environments. A summary of how to get a virtual
environment set up is contained in the below, but for further information, see:

   - [Virtual environments with venv](https://docs.python.org/3/tutorial/venv.html)


To create a virtual environment, run
```
python -m venv --system-site-packages /projappl/project_XXXX/virtual-env
```
This will create the `virtual-env` directory if it doesn't exist and install a
copy of the python interpreter and various other files in there.  Instead of an
absolute file path (`/projappl/project_XXXX/virtual-env`), a relative path like
`venv` is also possible. This will create the virtual environment in the
current folder.

The `--system-site-packages` option allows the use of all system-wide installed
packages from inside the virtual environment. That on the one hand contradicts
the intention of virtual environments but allows you to you the specially
performance tuned CRAY package versions of for example `numpy`, `scipy` and
`mpi4py`.

Finally, you're ready to `activate` your environment. This is done by running
```
source /work/t01/t01/auser/<<name of your virtual environment>>/bin/activate
```
Once your environment is activated you will be able to install packages as
usual using `pip install <<package name>>`. These packages will only be
available within this environment. When running code that requires these
packages you must activate the environment, by adding the above `source ...
activate` line of code to any submission scripts.

In case a newer version than the one provided by CRAY is needed you can also
upgrade it with `pip install -U pandas`. But be aware that the new package
version will not contain any optimizations for LUMI. So this is only
recommended if the CRAY provided version is missing features or contains bugs
fixed in newer versions.

---

This page 'Installing and using packages with Cray Python' is a derivate of
'[Using Python](https://docs.archer2.ac.uk/user-guide/python/)' by
[ARCHER2](https://www.archer2.ac.uk/), used under [CC BY
4.0](https://creativecommons.org/licenses/by/4.0/).
