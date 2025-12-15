# What is LUMI-K?

!!! warning "Recommendations"
    Before using LUMI-K, we recommend that you familiarise yourself with cloud containers and Kubernetes.
    You can find more information by following this [link](05_ext_docs.md)

LUMI-k is a container orchestration platform built on top of a hardware partition of the LUMI supercomputer. 
LUMI-K runs on [okd](https://www.okd.io/), the community distribution of Kubernetes that powers Red Hat OpenShift.

LUMI-K is a general-purpose platform that can run many types of applications, including web services, databases, 
scientific software stacks, and data-analysis pipelines. Each application is deployed as one or more containers, 
ensuring isolation and a consistent execution environment.

With the LUMI-K service, you can deploy cloud-native applications that can scale and remain available even when 
individual components fail. LUMI-K includes built-in features such as reconciliation, load balancing, high availability,
and rolling updates, which help ensure that your applications stay responsive during changes or increased load.
The platform also offers ready-made templates for common workloads, such as databases or web servers, allowing you 
to set up these applications with only a few clicks.

## When should I choose LUMI-K?

Here are some example use cases that LUMI-K is good for:

* Deploy applications that are packaged and shipped as Docker containers.
* Deploy application that are composed of multiple interconnected microservices.
* Deploy container-based scientific computing stacks
* Deploy interactive web applications.
* Automatic management of your applications via external CI/CD systems.

## LUMI-K Multi-tenancy

LUMI-K is optimized for multi-tenant deployments, meaning that multiple tenants share the same underlying hardware.
Because of this, **privileged containers are not allowed**, and containers **cannot run as the root user**. If you use
third-party container images, ensure that they do not require elevated privileges or assume that the application will
run as root.

Another implication of multi-tenancy is that LUMI-K projects have defined compute and storage quotas. These limits 
help ensure fair resource usage and prevent individual tenants from affecting the stability of the platform.

