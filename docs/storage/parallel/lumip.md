# Scratch Space

[lustre]: lustre.md

## Description

The LUMI scratch is composed of 4 independent [Lustre][lustre] file systems each
with a storage capacity of 20 PB (80 PB total). The aggregate bandwidth of 960 
GB/s, 240 GB/s per filesystem. Each of these file systems are is composed of 1 
MDS (metadata server) and 32 Object Storage Targets (OSTs).

## Usage

The scratch storage is located at `/scratch/project_<project-number>`

## Billing and Quota

The quota is enforced on a per project basis. The default quota is 50 TB and 2 
million files. If you need more space, this quota can be pushed up to 500 TB 
upon request. However, if you are limited by the quota on the number of files, 
we invite you to reconsider your data workflow. Having a large number of small
files can creates contention at the metadata servers and may limit the 
performance due to limited striping (more explanation is provided on the 
[Lustre][lustre] page).

Scratch storage is billed by volume as well as time. The billing units are 
TB-hours. In practice, 1TB that stays for 1 hour on the filesystem will consume
1TB-hour of your storage allocation.

## Purge Policy

!!! failure "Data rentention policies not active"

    Scratch automatic cleaning is not active at the moment. Please remove the 
    files that are no longer needed by your project on a regular basis if you 
    don't want to run out of TB-hours.

You are not supposed to use the scratch space a long-term storage. The 
scratch file system is a temporary storage space. Files that have not been
accessed will be **purged after 90 days**.

Deliberately modifying file access time to bypass the purge is prohibited. It's 
an anti-social behaviour that may impact other users negatively.