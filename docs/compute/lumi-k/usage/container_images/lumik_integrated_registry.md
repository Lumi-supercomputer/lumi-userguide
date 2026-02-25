# Using LUMI-K integrated registry

## Pushing local images to LUMI-K registry

The internal registry allows you to store container images inside your LUMI-K project. This is useful when you build 
images locally and want to deploy them on the cluster without using an external registry.

The process is simple:

1. Make sure to [login via the CLI](../../getting-started/lumik_cli.md)


2. Log in to the registry

    ```sh
    docker login -u unused -p $(oc whoami -t) registry.apps.v1.lumi-k.eu
    ```

    !!! info
        If you get any error, make sure you are logged in. If you run `oc whoami`, the command should return your username.

3. Tag your local image so it points to your project’s ImageStream location. Images must follow this format:

    ```sh
    docker tag <image-name>:<image-tag> registry.apps.v1.lumi-k.eu/<lumik-project-name>/<image-name>:<image-tag>
    ```
   
    Example:

    ```sh
    docker tag myapp:latest registry.apps.v1.lumi-k.eu/myproject/myapp:latest
    ```


4. Push the image to the registry:

    ```sh
    docker push  registry.apps.v1.lumi-k.eu/<lumik-project-name>/<image-name>:<image-tag>
    ```
    Example:

    ```sh
    docker push myapp:latest registry.apps.v1.lumi-k.eu/myproject/myapp:latest
    ```

5. Verify the ImageStream in LUMI-K.

    ```sh
    oc describe is <image-name>
    ```

You should be able to see the ImageStream in the web console as well under Builds -> ImageStreams.


Alternatively, you can query images in remote registry with `docker image ls [OPTIONS] [REPOSITORY[:TAG]]`

!!! warning "Troubleshooting"

    If you receive this error when attempting to push your image:

    ```
    unknown: unexpected status from HEAD request to https://registry.apps.v1.lumi-k.eu/v2/<lumik-project-name>/<image-name>/manifests/sha256:834e7b036543663e8616810c2c3a199cd8a3618e981f75eea235e0920d601ce4: 500
    ```

    You must create the `ImageStream` before pushing.

    Run this command:

    ```
    oc create imagestream {YOUR_IMAGE_NAME}
    ```

[oc](../../getting-started/lumik_cli.md) must be installed locally on your machine.

## Download images from LUMI-K registry

1. Make sure to [login via the CLI](../../getting-started/lumik_cli.md)

2. Log in to the registry

    ```sh
    docker login -u unused -p $(oc whoami -t) registry.apps.v1.lumi-k.eu
    ```

3. Pull the image

    ```sh 
    docker pull registry.apps.v1.lumi-k.eu/<lumik-project-name>/<image-name>:<image-tag>
    ```

4. Optionally you can re-tag the local image before using it (so you can refer to it without the the registry url)

    ```sh 
    docker tag registry.apps.v1.lumi-k.eu/<lumik-project-name>/<image-name>:<image-tag> <image-name>:<image-tag> 
    ```

5. Verify the image

    ```sh 
    docker images
    ```

## Access control for the LUMI-K integrated registry

The LUMI-K internal registry enforces access control based on project (namespace) permissions. Each image stored in the 
registry belongs to a project, and users must have the appropriate privileges in that project to push, pull, or 
manage images.


### Registry ownership and image visibility

Stored images in the internal registry are scoped to the project that owns them.
An image located at:

`registry.apps.v1.lumi-k.eu/<lumi-k-project-name>/<image-name>:<image-tag>`


is by default accessible only to:

* users who have access to same `lumi-k-project-name`

* service accounts in `lumi-k-project-name`

Users in other projects cannot pull this image or push unless explicit access is granted.


LUMI-K provides granular control over access to the integrated image registry, allowing users to manage permissions based on [user authentication](https://docs.redhat.com/en/documentation/openshift_container_platform/4.19/html/authentication_and_authorization/index).

As a LUMI-K user, you can choose how broadly your stored images are exposed for different scenarios.


#### Use case 1: Publicly pullable images through the internet

This method allows **all images** within a LUMI-K project to be pulled by **anyone on the internet**.

!!! info "Expose selected images only"

    If you need to only make one or more specific images see [Use case 3](../container_images/lumik_integrated_registry.md#use-case-3-granular-control-over-publicly-exposing-specific-image-recommended)


- **How to enable**: Use one of the following commands to allow anyone pulling images from your LUMI-K project:

  ```bash
  oc policy add-role-to-user "system:image-puller" "system:anonymous" -n <project>
  # OR
  oc policy add-role-to-group "system:image-puller" "system:unauthenticated" -n <project>
  ```

- **How to disable**: Use one of the following commands to revert above changes:

  ```bash
  oc policy remove-role-from-user "system:image-puller" "system:anonymous" -n <project>
  # OR
  oc policy remove-role-from-group "system:image-puller" "system:unauthenticated" -n <project>
  ```

#### Use case 2: Pullable images for all LUMI-K users, groups, serviceaccounts, and projects

This method allows **all images** within a project to be pulled by **any authenticated LUMI-K user**, including other projects and service accounts inside LUMI-K.

- **How to enable**: Use the following command to allow anyone pulling images from your LUMI-K project:

  ```bash
  oc policy add-role-to-group "system:image-puller" "system:authenticated" -n <project>
  ```

- **How to disable**: Use the following command to revert above changes:

  ```bash
  oc policy remove-role-from-group "system:image-puller" "system:authenticated" -n <project>
  ```

#### Use case 3: Granular control over publicly exposing specific image (Recommended)

This method provides fine-grained control, allowing you to expose **only selected imagestreams** to unauthenticated users on the internet.
It is a more safe alternative to Use case 1 because it exposes only what you explicitly choose.

- **How to enable**: For this, you are required to create a custom role and rolebinding in your LUMI-K project. 

  ```bash
  # Select your project
  oc project my-project

  # Creating custom role
  # oc create role <ROLE_NAME> --verb=get --resource=imagestreams.image.openshift.io/layers --resource-name=<IMAGE_NAME>
  oc create role my-image-puller --verb=get --resource=imagestreams.image.openshift.io/layers --resource-name=MY_IMAGE_NAME # Repeat the option --resource-name to select more Imagestreams

  # Create custom rolebinding
  # oc create rolebinding <RB_NAME> --role=<ROLE_NAME> --user="system:anonymous"
  oc create rolebinding my-image-puller --role=my-image-puller --user="system:anonymous" # Alternative to --user, you can use --group="system:unauthenticated"
  ```

- **How to disable**: Use the following commands to revert above changes:

  ```bash
  # Delete the role and rolebinding
  
  oc delete rolebinding my-image-puller
  oc delete role my-image-puller
  ```

#### Use case 4: Exposing the images from one LUMI-K project to another LUMI-K project (cross-namespace pulling)

This method enables one LUMI-K project to pull images from another project.
It is useful when different namespaces need to share base images.

- **How to enable**: To do so, you need to allow a certain `serviceaccount` from the other namespace be able to pull the image.

  ```bash
  oc policy add-role-to-group -n <project-that-has-the-image> "system:image-puller" "system:serviceaccounts:<project-that-pulls-the-image>"
  ```

- **How to disable**: Use the following command to revert above changes:

  ```bash
  oc policy remove-role-from-group -n <project-that-has-the-image> "system:image-puller" "system:serviceaccounts:<project-that-pulls-the-image>"
  ```
