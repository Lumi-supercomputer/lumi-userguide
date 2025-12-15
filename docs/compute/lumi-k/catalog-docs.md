
# LUMI-K Software catalog

LUMI-K offers a catalog of applications, that are ready to be deployed out of the box.
These applications are provided "as is", If you need help to deploy a newer version of an application, please contact 
the [Help Desk](../../helpdesk/index.md#help-desk).

You can also take a look at the [RedHat Ecosystem Catalog](https://catalog.redhat.com/). This catalog contains ready to 
use container images and packaged applications that can be deployed to LUMI-K. However, some of these applications
require elevated user privileges in LUMI-K and are not deployable by normal users. 

## Access LUMI-K software catalog

!!! warning "LUMI-K Helm Charts"

    Starting on 29 September 2025, Bitnami will be changing its policy regarding its catalog. Read more [here](https://github.com/bitnami/containers/issues/83267)  
    - Current images will be moved to the [Bitnami Legacy Repository](https://hub.docker.com/u/bitnamilegacy) and will no longer be updated.  
    - Some images will still be available in the [Bitnami Secure Images](https://hub.docker.com/u/bitnamisecure) but only with the `latest` tag.  
    - To continue receiving images with the latest updates and access to different tags, you need to subscribe to the full version of [Bitnami Secure Images](https://www.arrow.com/globalecs/uk/products/bitnami-secure-images/)  
    
    Some of our Helm Charts used `Bitnami` images. Our Helm Charts are now intended for testing/development purposes because they use `bitnamilegacy` and/or `bitnamisecure` docker repositories.  
    
    However, the Bitnami project continues to make its source code available at [bitnami/containers](https://github.com/bitnami/containers) under the Apache 2 licence. You can build the image and then push it to your CSC project.
    
    You can find more information on how to push images [here](./images/Using_LUMI-K_integrated_registry.md)

You can browse LUMI-K software catalog from the webinterface after (1) logging in LUMI-K and then (2) switching to the Developer view and click in `+Add`.

![+Add](../img/rahti-catalog.png)