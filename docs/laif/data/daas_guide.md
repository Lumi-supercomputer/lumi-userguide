# Dataset-as-a-Service User Guide

## What is Dataset-as-a-Service?

Dataset-as-a-Service (DaaS) offers curated high-quality datasets close to
high-performance computing resources, enabling researchers, innovators, and
industry users to focus on research and development rather than data
acquisition and infrastructure management. The datasets are usually accessible
through a front-end portal and application programming interfaces (APIs).

The data and storage management is the core of Dataset-as-a-Service (DaaS). To
ingest, organize, store, and maintain the datasets, the DaaS platform shall
include a solution for handling databases, data lakes and provide data
lifecycle management for controlling data retention and eventually deletion.
The platform shall allow users to discover available datasets, monitor dataset
usage and availability, etc.

Dataset-as-a-Service (DaaS) shall support a consistent way for applications to
access the DaaS platform. That shall include API access. To make the DaaS
platform interoperable, it will be developed to adhere to industry standards,
and to use APIs, protocols and connectors to external storage systems, and to
use industry standard data formats such as CSV, JSON, etc.

The Dataset-as-a-Service platform shall support reliable identity and access
management (IAM) and role-based access control (RBAC) to enforce granular
access control over which users and groups have access to which datasets.

Dataset-as-a-Service is not intended for archival or digital preservation
purposes.

## Service Development

Dataset-as-a-Service is currently a Minimum Viable Product (MVP). MVP is the
simplest version of a product that includes only the core features necessary
to deliver value to early users and validate the product concept. The goal of
an MVP is to test assumptions quickly and with minimal resources, to gather
user feedback, and to use that feedback to guide further development.

## Who can use Dataset-as-a-Service? What can they use it for?

Dataset-as-a-Service is developed for two central user roles, data users and
data providers.

**Data users** are those individual users who utilize the datasets in their
research or development work. They can
* search or browse the public data catalogue to find datasets
* apply to access a dataset
* use the dataset in their research (when given access to the dataset)
* combine datasets with their own data, if needed, and delete the data they've
  uploaded for their own use

**Data providers** are the organizations that make their datasets available
via Dataset-as-a-Service. They can
* make large, widely interesting and high-quality datasets (and associated
  metadata) available for data users
* limit the use and level of publicity of the dataset

## Do I have to pay to use the datasets?

The Dataset-as-a-Service (DaaS) datasets can be accessed and utilized
free-of-charge, but to access the LUMI supercomputer and to run jobs with LUMI
using the DaaS datasets, you need to be a member of a project that has been
granted resources on LUMI.

The LUMI consortium countries have different policies for accessing LUMI. An
overview of the access policies is provided on the
[LUMI Supercomputer Get Started](https://lumi-supercomputer.eu/get-started/)
page.

## I'd like to offer a dataset to be used via Dataset-as-a-Service. What can I do?

We'd be happy to hear from you! Please contact us to tell us about your
dataset. Dataset-as-a-Service is still under development, but we warmly
welcome pilot datasets to offer through the service.

## Searching for Datasets

The currently available datasets are listed in the
[**data catalogue**](https://django-route-test-rahti.2.rahtiapp.fi/remote/).
Take a look – you don't need have an account to browse it.

Dataset-as-a-Service data catalogue:
[https://django-route-test-rahti.2.rahtiapp.fi/remote/](https://django-route-test-rahti.2.rahtiapp.fi/remote/)

You can search for datasets by using
* access type (open/restricted)
* year
* field of science
* keywords

To access a dataset and to use it in your project you will need an account:
[https://docs.lumi-supercomputer.eu/firststeps/accessLUMI/](https://docs.lumi-supercomputer.eu/firststeps/accessLUMI/)

## Accessing a dataset

1. Search for a dataset from the Dataset-as-Service data catalogue:
   https://django-route-test-rahti.2.rahtiapp.fi/remote/
2. Apply to access a dataset
    1. Currently you can apply by sending an e-mail to the LUMI AI Factory
       support
3. You will receive a notification by e-mail about permission to access the
   dataset
    1. If the permission process for the dataset is automated (a
       non-restricted dataset), you will receive the notification quickly
    2. If the data provider makes the decisions on date permit manually (a
       restricted dataset), receiving the notification will take longer
    3. If you have questions about the data content or the terms of
       permission, contact the data provider directly
4. Make use of the dataset in your research or RDI project
    1. You need to be a member of a project that has been granted resources on
       LUMI. The LUMI consortium countries have different policies for
       accessing LUMI. An overview of the access policies is provided on the
       [LUMI Supercomputer Get Started](https://lumi-supercomputer.eu/get-started/)
       page.
5. Evaluate the usability of Dataset-as-a-Service and give feedback
1. We are building a new service and would be happy to hear about your
   experiences and how we can make Dataset-as-a-Service better

You can contact LUMI AI Factory user support to receive support at any step of
the process.

## Applying to Use a Dataset

Applying to use datasets is currently done by e-mail. Please contact us by
e-mail if you want to apply to use one or several of the current
Dataset-as-a-Service datasets.

You will be notified by e-mail when you have been granted or denied access for
a dataset. After you've been granted access to a dataset, the LUMI AI Factory
support can help you to access the dataset so you can use it in your project
with LUMI resources.

## Using Datasets with HPC Tools

To be able to use the HPC tools on LUMI, you need to be a member of a project
that has been granted resources on LUMI. The LUMI consortium countries have
different policies for accessing LUMI. An overview of the access policies is
provided on the
[LUMI Supercomputer Get Started](https://lumi-supercomputer.eu/get-started/)
page.

You can use pre-installed software on LUMI, install additional software
yourself or use an Apptainer/Singularity container or the LUMI container
wrapper:
[https://docs.lumi-supercomputer.eu/software/](https://docs.lumi-supercomputer.eu/software/).

Software library:
[https://lumi-supercomputer.github.io/LUMI-EasyBuild-docs/](https://lumi-supercomputer.github.io/LUMI-EasyBuild-docs/)

Containerized Workflows are developed by the LUMI AI Factory to streamline AI
related tasks in HPC environment:
[https://docs.lumi-supercomputer.eu/software/local/lumi-aif/#containerized-workflows](https://docs.lumi-supercomputer.eu/software/local/lumi-aif/#containerized-workflows)

Running jobs on LUMI:
[https://docs.lumi-supercomputer.eu/runjobs/](https://docs.lumi-supercomputer.eu/runjobs/)

## Citation

Datasets have unique URLs for citation. Licensing information is embedded in
metadata and maintained by data providers.

## Combining Datasets and Working with Your Own Data

You can combine your own data with a Dataset-as-a-Service dataset or use more
than one dataset in your project, if you have been granted access for several
datasets.

Please note that LUMI is not designed to process personal data, and you must
not transfer personal data to the service. Uploading and deleting your own
data is on your own responsibility. Data storage options:
[https://docs.lumi-supercomputer.eu/storage/](https://docs.lumi-supercomputer.eu/storage/)

## Providing your dataset to be used via Dataset-as-a-Service

1. Get to know LUMI AI Factory Dataset-as-a-Service to see if providing your
   dataset through the service would be a fitting way to offer it for a wider
   research community
    1. You will find information about the service in this user guide, the
       service description and user policy
    2. There is more information about the AI factory on the LUMI AI Factory
       website
    3. All LUMI AI Factory services are described on the service catalogue
2. Contact the AI Factory support
    1. We will be happy to learn about your dataset and discuss the details of
       providing the dataset through Dataset-as-a-Service
3. LUMI AI Factory will make a quality assessment of your dataset and decide,
   if the dataset would be suitable to be offered through Dataset-as-a-Service
4. LUMI AI Factory will ask you to sign an agreement about providing the
   dataset
5. After signing the agreement, you will be asked to add the dataset to the
   service and add the required information, like sufficient metadata
    1. We will give you further details about how to proceed with adding the
       dataset
    2. We will publish the dataset after reviewing the required information
       and the technical functionality of the dataset
6. Evaluate the suitability of Dataset-as-a-Service and give feedback on the
   user experience
    1. We are building a new service and would be happy to hear about your
       experiences and suggestions on how we can make Dataset-as-a-Service
       better
7. If you have decided to restrict the access of your dataset, you will be
   notified by e-mail about every data permit request on your dataset
8. If you need information about the usage of your dataset, you can always
   contact the LUMI AI Factory support
9. If you need to update the dataset (make a new version) or remove the
   dataset before the time determined on the agreement has passed, you can
   always contact the LUMI AI Factory support

## Data Agreement

A data agreement is required between the data provider (data controller) and
the LUMI AI Factory (data processor).

## Adding Your Dataset and Metadata

The LUMI AI Factory support will help you to add your dataset into
Dataset-as-a-Service.

Comprehensive metadata for datasets provides the data users detailed
descriptions of the data and helps them to discover the data they need. The
Metax metadata model is designed to describe research datasets and related
entities in a structured, interoperable way.

The Metax metadata model:
[https://wiki.eduuni.fi/spaces/Fairdataverkosto/pages/469015907/In+English+Data+Model+and+metadata+in+Metax+V3]([https://wiki.eduuni.fi/spaces/Fairdataverkosto/pages/469015907/In+English+Data+Model+and+metadata+in+Metax+V3)

Contact the LUMI AI Factory support if you need help with providing
comprehensive metadata for your dataset.

## Reviewing Applications from Data Users

Currently the data permit process is conducted by e-mail.

You will receive data permit applications from potential data users by e-mail
and you can either accept or deny the requests by e-mail.

## Withdrawing a Dataset

If you want to withdraw your dataset, please contact the LUMI AI Factory support.
