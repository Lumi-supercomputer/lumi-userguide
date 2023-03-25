---
template: home.html
hide:
  - navigation
  - toc
---

<div class="card" markdown>

- **Welcome**

    ---

    Welcome to the LUMI supercomper user guide. In order to navigate this guide
    select a category from the navigation bar at the top of the page or use 
    the search function.

    You have not connected to LUMI yet? Please visit the first steps section to
    learn how to setup an SSH key in order to be able to connect.

    [:octicons-arrow-right-24: First steps](firststeps/getstarted.md)

</div>

<div class="grid cards" markdown>

-   **Discover the LUMI Hardware**

    ---

    [:octicons-arrow-right-24: CPU partition](hardware/compute/lumig.md)<br>
    [:octicons-arrow-right-24: GPU partition](hardware/compute/lumic.md)<br>
    [:octicons-arrow-right-24: Visualization partition](hardware/compute/lumid.md)

-   **Submitting a Job**

    ---

    [:octicons-arrow-right-24: Available Slurm partitions](runjobs/scheduled-jobs/partitions.md)<br>
    [:octicons-arrow-right-24: Example GPU jobs](runjobs/scheduled-jobs/lumig-job.md)<br>
    [:octicons-arrow-right-24: Example CPU jobs](runjobs/scheduled-jobs/lumic-job.md)

-   **Storage**

    ---

    [:octicons-arrow-right-24: Data storage options](runjobs/lumi_env/storing-data.md)<br>
    [:octicons-arrow-right-24: Using Lustre efficiently](hardware/storage/lumip.md)<br>
    [:octicons-arrow-right-24: Object storage](#)

-   **Softwares**

    ---

    [:octicons-arrow-right-24: The software stacks](#)<br>
    [:octicons-arrow-right-24: Installing software using EasyBuild](#)<br>
    [:octicons-arrow-right-24: Spack on LUMI](#)

-   **Programming Environments**

    ---

    [:octicons-arrow-right-24: Cray programming environment](development/compiling/prgenv.md)<br>
    [:octicons-arrow-right-24: Cray libraries](development/libraries/cray-libraries.md)<br>

-   **Debugging and Profiling**

    ---

    [:octicons-arrow-right-24: Cray performance analysis tool](http://127.0.0.1:8000/development/profiling/perftools.md)<br>
    [:octicons-arrow-right-24: Parallel debugging](development/debugging/gdb4hpc.md)

</div>