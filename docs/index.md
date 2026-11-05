---
template: home.html
title: Welcome
hide:
  - navigation
  - toc
  - footer
---

<div class="grid cards" markdown>

-   **Welcome to the LUMI supercomputer user guide**

    ---

    To navigate this guide, select a category from the navigation bar at the top of the page or use the search function.

    !!! tip "You have not connected to LUMI yet?"
        Please visit the first steps section to get started. 

        [:octicons-arrow-right-24: First steps](firststeps/index.md)

</div>

<style scoped>
  .md-typeset .lumi-links {
    padding: .1rem;

    >ul {
      display: flex;
      justify-content: center;
      list-style: none;
    }
  }
</style>
<div markdown class="lumi-links">

- [:octicons-link-24: LUMI helpdesk](https://lumi-supercomputer.eu/user-support/need-help/){ .md-button }
- [:octicons-link-24: LUMI status](https://status.lumi.csc.fi/){ .md-button }
- [:octicons-link-24: LUMI events](https://lumi-supercomputer.eu/events/){ .md-button }
- [:octicons-link-24: LUMI training materials](https://lumi-supercomputer.github.io/LUMI-training-materials/){ .md-button }

</div>

<div class="grid cards" markdown>

-   **Discover the LUMI Hardware**

    ---

    [:octicons-arrow-right-24: GPU partition](hardware/lumig.md)

    [:octicons-arrow-right-24: CPU partition](hardware/lumic.md)

    [:octicons-arrow-right-24: Visualization partition](hardware/lumid.md)

-   **Submitting a Job**

    ---

    [:octicons-arrow-right-24: Available Slurm partitions](runjobs/scheduled-jobs/partitions.md)

    [:octicons-arrow-right-24: Example GPU jobs](runjobs/scheduled-jobs/lumig-job.md)

    [:octicons-arrow-right-24: Example CPU jobs](runjobs/scheduled-jobs/lumic-job.md)

-   **Storage**

    ---

    [:octicons-arrow-right-24: Data storage options](storage/index.md)

    [:octicons-arrow-right-24: Using Lustre efficiently](storage/parallel-filesystems/lustre.md)

    [:octicons-arrow-right-24: Object storage](storage/lumio/index.md)

-   **Software**

    ---

    [:octicons-arrow-right-24: The software stacks](runjobs/lumi_env/softwarestacks.md)

    [:octicons-arrow-right-24: Installing software using EasyBuild](software/installing/easybuild.md)

    [:octicons-arrow-right-24: Spack on LUMI](software/installing/spack.md)

-   **Programming Environments**

    ---

    [:octicons-arrow-right-24: Cray programming environment](development/compiling/prgenv.md)

    [:octicons-arrow-right-24: Cray libraries](development/libraries/cray-libraries.md)


-   **Debugging and Profiling**

    ---

    [:octicons-arrow-right-24: Cray performance analysis tool](development/profiling/perftools.md)

    [:octicons-arrow-right-24: Parallel debugging](development/debugging/gdb4hpc.md)

</div>
