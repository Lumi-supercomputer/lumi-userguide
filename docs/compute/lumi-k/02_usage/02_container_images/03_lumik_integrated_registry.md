# Using LUMI-K integrated registry

## Pushing local images to LUMI-K registry

The internal registry allows you to store container images inside your LUMI-K project. This is useful when you build 
images locally and want to deploy them on the cluster without using an external registry.

The process is simple:

1. Make sure to [login vi the CLI](../../01_getting-started/04_lumik_cli.md)


2. Log in to the registry

    ```sh
      docker login -u $(oc whoami) -p $(oc whoami -t) registry.apps.v1.lumi-k.eu
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

You should be able to see the ImageStream in the web console as well under Builds -> ImageStreams :


Alternatively you can query images in remote registry with `docker image ls [OPTIONS] [REPOSITORY[:TAG]]`

!!! warning "Troubleshooting"

    If you receive this error when attempting to push your image:

    ```
    unknown: unexpected status from HEAD request to https:// registry.apps.v1.lumi-k.eu/v2/<lumik-project-name>/<image-name>/manifests/sha256:834e7b036543663e8616810c2c3a199cd8a3618e981f75eea235e0920d601ce4: 500
    ```

    You must create the `ImageStream` before pushing.

    Run this command:

    ```
    oc create imagestream {YOUR_IMAGE_NAME}
    ```

[oc](../../01_getting-started/04_lumik_cli.md) must be installed locally on your machine.

## Download images from LUMI-K registry

1. Make sure to [login vi the CLI](../../01_getting-started/04_lumik_cli.md)

2. Log in to the registry

    ```sh
      docker login -u $(oc whoami) -p $(oc whoami -t) registry.apps.v1.lumi-k.eu
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

Images stored in the internal registry are scoped to the project that owns them.
An image located at:

`registry.apps.v1.lumi-k.eu/<lumik-project-name>/<image-name>:<image-tag>`


is by default accessible only to:

* users who have access to <lumik-project-name>

* service accounts in <lumik-project-name>

Users in other projects cannot pull or push this image unless explicit access is granted.


LUMI-K allows fine-grained control over access to the integrated image registry, enabling management of access based 
on [user authentication](https://docs.redhat.com/en/documentation/openshift_container_platform/4.17/html/authentication_and_authorization/index).


### 1. **Unauthenticated Access** (`system:unauthenticated`)

This group includes all users who are accessing the system without valid authentication credentials, including anonymous
users.

- **How to enable**: Grant unauthenticated users access with the command:
  ```bash
  oc policy add-role-to-user registry-viewer system:unauthenticated -n <lumi-k-project>
  ```
- **Use case**: Suitable for cases where you want to make images publicly accessible, allowing anyone to view or pull 
images without logging in.

### 2. **Authenticated Access** (`system:authenticated`)

Authenticated users are those who have successfully logged in using valid credentials (e.g., OAuth tokens).

- **How to enable**: To allow all authenticated users to access the registry:
  ```bash
  oc policy add-role-to-user registry-viewer system:authenticated -n <lumi-k-project>
  ```
- **Use case**: This allows any user with valid credentials (all LUMI-K users) to view or pull images, useful for 
restricting access.

### 3. Specific LUMI-K users

The easiest way to grant access to the registry for someone who is already a LUMI user, is to just add him as team 
member to your LUMI project, the privileges will then propagate to LUMI-K. However, the user will have full access to 
all your LUMI-K projects associated with the LUMI project. If you want to give others pull privilege in one LUMI-K 
project only, use this command:

  ```bash
  oc policy add-role-to-user registry-viewer <lumi-k-username> -n <lumi-k-project>
  ```
