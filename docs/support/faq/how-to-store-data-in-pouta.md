# How to store data on Pouta?

Pouta provides two choices which are not backed up by CSC:

*   Temporary storage via local disks attached to virtual machines. OpenStack calls this ephemeral (meaning "lasting for a very short time") storage.
*   Longer term storage via Volumes. Volumes appear as raw disks attached to virtual machines. See:
    *   What are volumes? How to use them?

Alternatives:

Users are free to use any other storage outside of Pouta, either directly or by coping data it to ephemeral storage of volumes. It's possible to use other CSC storage in this way. See:

*   Allas object storage
*   How do I access the CSC archive service?
