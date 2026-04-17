[EESSI_main]: https://eessi-hpc.org/
[EESSI_regular_docs]: https://www.eessi.io/docs/
[EESSI_training]: https://www.eessi.io/docs/training-events/
[EESSI_happy_hour]: https://www.eessi.io/docs/training-events/happy-hours-sessions/
[EESSI_software_catalog]: https://www.eessi.io/docs/available_software/

[EFP_main]: https://my-eurohpc.eu
[EFP_helpdesk]: https://docs.my-eurohpc.eu/support/
[EFP_docs]: https://docs.my-eurohpc.eu/
[EFP_docs_lumi]: https://docs.my-eurohpc.eu/software-catalog/system-specific/lumi/
[EFP_software_catalog]: https://my-eurohpc.eu/software-catalog
[EFP_adding_software]: https://docs.my-eurohpc.eu/software-catalog/adding-software/


# EESSI software stack

[EESSI][EESSI_regular_docs] is the software stack of the 
[EuroHPC Federation Platform (EFP)][EFP_main] and documented in the
[EFP documentation][EFP_docs] with
[specific instructions for running on LUMI](https://docs.my-eurohpc.eu/software-catalog/system-specific/lumi/).
[That page][EFP_docs_lumi] also mentions specific restrictions for LUMI that will
change over time.

[EESSI][EESSI_main] is also a broader project with the software stack
available on many non-EuroHPC systems. You can even run it on most Linux
workstations, Windows systems with WSL2 and macOS systems with a Linux VM/container
solution, but the machine needs to be connected to the internet when running the
software.
On LUMI however, we have to deploy EESSI in a special way (avoiding the CernVM-FS
filesytem usually used for EESSI)
due to the architecture of the LUMI machine and measures taken to limit OS jitter,
so not everything in the [regular EESSI documentation][EESSI_regular_docs]
may apply to LUMI.

Support is only offered through [the **EFP helpdesk**][EFP_helpdesk].
LUST cannot forward these requests.

EESSI also has its own [training events][EESSI_training]
and a weekly [EESSI happy hour session][EESSI_happy_hour].
You'll find materials from past training events there also.

The EESSI software stack is currently not offered through modules. Access is also different on 
the login nodes and on the compute nodes. For the expert: EESSI on LUMI is currently not offered
through CernVM-FS but through SquashFS files that are synchronised with the main EESSI repository
daily. On the login nodes, you can use EESSI through a container while on the compute nodes it
is fuse-mounted when a job requests it.

The [EFP software catalog][EFP_software_catalog] requires logging in with an EFP account, but a 
[second version of the EESSI software catalog is available in the EESSI documentation][EESSI_software_catalog].

It is possible to install [additional software on top of the EESSI stack](https://docs.my-eurohpc.eu/software-catalog/adding-software/).
In fact, many EasyBuild recipes for the foss toolchain and its subtoolchains should work.
These are regular EasyBuild recipes and should be supported by the EasyBuild community, not by LUST.
LUST also does not plan to do any development on top of EESSI and will continue to work on its own
software environment built on top of the HPE Cray Programming Environment for which we have full 
vendor support, and using Cray MPICH rather than Open MPI 
as Cray MPICH is guaranteed to work well on the LUMI interconnect and integrates
properly with the scheduler.

## Most important links

-   [EFP documentation][EFP_docs]
-   [Running EESSI on LUMI][EFP_docs_lumi]
-   [EFP helpdesk][EFP_helpdesk] for all your issues with EESSI on LUMI
-   [EESSI training events][EESSI_training]
