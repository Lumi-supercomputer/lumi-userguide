# What is LUMI-K?

!!! warning "Recommendations"
    Before using LUMI-K, we recommend that you familiarise yourself with cloud containers and Kubernetes.
    You can find more information by following this [link](ext_docs.md).

LUMI-K is a container orchestration platform built on top of a dedicated hardware partition of the LUMI supercomputer. 
It is not possible to run Kubernetes pods on LUMI compute partitions.
LUMI-K runs on [OKD](https://www.okd.io/), the community distribution of Kubernetes that powers Red Hat OpenShift.

LUMI-K is a general-purpose platform that can run many types of applications, including web services, databases, 
scientific software stacks, and data-analysis pipelines. Each application is deployed as one or more containers, 
ensuring isolation and a consistent execution environment.

With the LUMI-K service, you can deploy cloud-native applications that can scale and remain available even when 
individual components fail. LUMI-K includes built-in features such as reconciliation, load balancing, high availability,
and rolling updates, which help ensure that your applications stay responsive during changes or increased load.
The platform also offers ready-made templates for common workloads, such as databases and web servers, allowing you 
to set up these applications with only a few clicks.

The LUMI-K platform comprises 28 worker nodes, each equipped with 128 vCPU cores and 503 GiB of memory. Collectively, this 
provides a total of 3,584 vCPU cores and 14,084 GiB of memory. The platform also includes a Ceph-backed persistent storage cluster, 
offering 89 TiB of total storage capacity. This capacity is dynamically allocated between block storage and filesystem storage classes, 
ensuring flexible and efficient resource utilization. More information regarding the LUMI-K hardware can be found [here](../../../hardware/lumik.md).

## When should I choose LUMI-K?

Here are some example use cases that LUMI-K is good for:

* Deploy applications that are packaged and shipped as Docker containers;
* Deploy applications that are composed of multiple interconnected microservices;
* Deploy container-based scientific computing stacks;
* Deploy interactive web applications;
* Automatically manage your applications via external CI/CD systems.

## When not to choose LUMI-K?

LUMI-K may not be the optimal solution if:

* Application requires GPU resources;
* Application involves traditional HPC-intensive workloads;
* Application can not tolerate restarts;
* Application depends directly on data generated from or needs to share resources with LUMI compute partitions.

## LUMI-K Multi-tenancy

LUMI-K is optimized for multi-tenant deployments, meaning that multiple tenants share the same underlying hardware.
Because of this, **privileged containers are not allowed**, and containers **cannot run as the root user**. If you use
third-party container images, ensure that they do not require elevated privileges or assume that the application will
run as root.

Another implication of multi-tenancy is that LUMI-K projects have defined compute and storage quotas. These limits 
help ensure fair resource usage and prevent individual tenants from affecting the stability of the platform.
