# Flash based Scratch Space

[lustre]: lustre.md

## Description

The LUMI flash based scratch [Lustre][lustre] file system has a storage capacity
of 7 PB and an aggregate bandwidth of 1 740 GB/s. It is composed of 2 MDSs 
(metadata servers) and 58 Object Storage Targets (OSTs).

## Usage

The flash storage is located at `/flash/project_<project-number>`

## Billing and Quota

The quota is enforced on a per project basis. The default quota is 1 TB and 1 
million files. If you need more space, this quota can be pushed up to 100 TB 
upon request. However, if you are limited by the quota on the number of files, 
we invite you to reconsider your data workflow. Having a large number of small
files can creates contention at the metadata servers and may limit the 
performance due to limited striping (more explanation is provided on the 
[Lustre][lustre] page).

!!! warning "Flash if billed at a 10x rate"

    The flash storage is billed at the 10x rate. This means that if you consume
    1 TB of flash storage for 1 hour, you will consume 10 TB-hours of your 
    storage allocation.

## Purge Policy

!!! failure "Data rentention policies not active"

    Scratch automatic cleaning is not active at the moment. Please remove the 
    files that are no longer needed by your project on a regular basis if you 
    don't want to run out of TB-hours.

You are not supposed to use the scratch space a long-term storage. The 
scratch file system is a temporary storage space. Files that have not been
accessed will be **purged after 30 days**.

Deliberately modifying file access time to bypass the purge is prohibited. It's 
an anti-social behaviour that may impact other users negatively.