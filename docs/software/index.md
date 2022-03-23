---
title: Software - Overview
---

[easybuild]: ./installing/easybuild.md
[python_installation]: ./installing/python.md
[contwrapper]: ./installing/python/container_wrapper.md


## Learn more about installing software on LUMI

On LUMI we support various ways to install software

 - [EasyBuild][easybuild] is our primary tool to manage the central software
   stack and we made it easy to install additional software in your home or
   project directory that extends that stack.
 - Container are supported through singularity. You can bring your own (with
   `singularity pull ...`) or use our [wrapper tool](contwrapper) to wrap a
   (python/conda) installation into a container.
 - Spack (documentation will follow)
 - [Python][python_installation] can be loaded and packages can be installed
   using different approaches, all with their advantages and disadvantages.
 <!-- - [Container wrapper][contwrapper] is a set of tools which wrap installations -->
 <!--   inside a Apptainer/Singularity container. These tools are recommended to --> 
 <!--   install Conda and pip packages on LUMI. -->


## Learn more about the LUMI software Policy

If you want to learn more about the LUMI software policy, you can watch this
recording from the last Easybuild User Meeting.

<iframe width="620" height="348" style="display: block; margin: 50px auto;"
src="https://www.youtube.com/embed/hZezVG6lJNk">
</iframe>

