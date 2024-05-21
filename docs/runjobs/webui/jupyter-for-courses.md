# Jupyter for courses

Jupyter for Courses is an app that makes using a custom
Python environment simple when hosting or participating in courses.

Python environments can be defined as modules in the project [persistent storage](../../storage/index.md#where-to-store-data).
Default resources for the course Python environment can also be defined in the same directory.

## Using the app

In the form for launching the application:

 - Select the project and reservation used for the course.
    The reservation field will only be visible if you have an active reservation you have access to use.
 - Select the course module
 - Launch the application

## Creating a course environment

The files for course environments (modules) can be created under `/projappl/project_<project-number>/www_lumi_modules`. 
The directories can be created if they do not exist.

The course environment is only visible for the project that it was created for.
Note that you may need to *Restart Web Server* in the *Help* menu in the web interface if the course
environment is not visible in the form after creating the files and selecting the correct project.

Two files are needed for the course modules to be visible in the web interface:

 - a `<course>.lua` file that defines the [module](../lumi_env/Lmod_modules.md) that sets up the Python environment.
    Only files containing the text `Jupyter` will be visible in the app.
    For more information about writing these module files, check the documentation for [creating and using your own modules](../lumi_env/Lmod_modules.md#creating-and-using-your-own-modules).
    This module file will be loaded using `module load` when launching Jupyter.
 - a `<course>-resources.yml` that defines the default resources used for Jupyter.
    If this file is omitted, the resources must explicitly be defined in the resource settings in the form.

### Examples
Module (`/projappl/project_1234567/www_lumi_modules/some-course.lua`):
```
-- Jupyter
depends_on("module1","module2")
prepend_path("PATH","/path/to/installation/bin")
setenv("_COURSE_BASE_NAME","FolderName")
-- Relative to the course dir
setenv("_COURSE_NOTEBOOK","notebooks/tutorial.ipynb")
setenv("_COURSE_GIT_REPO","https://github.com/VeryCoolCode/projectA.git")
-- Anything valid for checkout
setenv("_COURSE_GIT_REF","")
-- lab / notebook / empty (defaults to jupyter)
setenv("_COURSE_NOTEBOOK_TYPE","notebook")
```
Resources (`/projappl/project_1234567/www_lumi_modules/some-course-resources.yml`):
```
cores: 4
time: "02:00:00"
partition: "interactive"
mem: "16GB"
```

The Python environment for the course also needs to be created.
It is recommended that you use the [LUMI container wrapper](../../software/installing/container-wrapper.md) for creating the Python environment.
After creating the environment using the LUMI container wrapper, the full path to the `bin` directory needs to be added inside the `prepend_path` in the Lua file for the course above.
