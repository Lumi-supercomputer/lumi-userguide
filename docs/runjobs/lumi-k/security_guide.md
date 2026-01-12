# Security guide

When LUMI-K applications are exposed to the Internet via [Routes](usage/networking.md#routes), their security 
should be treated with an appropriate care. The user on whose account a service is running in LUMI-K is
responsible for its security.

This guide should be treated as the baseline that must be taken into account, rather than a checklist for perfect security.

Measures that tighten the security of the services running in LUMI-K include the following:

## Cluster policy

By default, LUMI-K applies the default security policies:

- **No root enforced**: That means that you cannot run a container with root privileges. It will fail.

- **Random UID/GID**: When your pod is deployed in LUMI-K, a random UID will be generated. You cannot assign a UID/GID out of this range (for example, `1001`), it will require special privileges. Usually, the number is like `1000620000`.

- **[Restricted-v2 policy](https://connect.redhat.com/en/blog/important-openshift-changes-pod-security-standards)**: Since Openshift 4.11, the new SCC policies are introduced according to the [Pod Security Standards](https://kubernetes.io/docs/concepts/security/pod-security-standards/).

- **[Default Pod resource limits](configuration/resource_quotas.md#default-requests-and-limits)**


## Securing routes

Enable the **TLS encryption** of routes. The router supports modern and secure TLS versions, TLS v1.3 and TLS v1.2. 
TLS v1.3 is currently the latest version. TLS v1.1 and below are no longer considered secure. If the DNS name of your 
service is under the subdomain `*.apps.lumi-k.eu` (e.g. `myapp.apps.lumi-k.eu`), the default wildcard TLS certificate 
provided by LUMI-K can be used directly. Otherwise, you need to add your certificate data in the route object.

Access to the services should be limited to selected networks with
**whitelists** whenever applicable (See the chapter
[Routes](usage/networking.md#ip-whitelisting)). This is relevant whenever
access can be restricted in terms of IP addresses.

Secure routes thwart eavesdropping attacks that target e.g. service passwords and usernames, and other critical data 
sent over the internet.

It is recommended to activate the HSTS header, and can be activated by running this command:

```sh
$ oc annotate route test-route haproxy.router.openshift.io/hsts_header='true'
```

HTTP Strict-Transport-Security response header (or HSTS for short) tells the browser to always use HTTPS and never HTTP for this given Route.

It is also recommended to configure rate limits on your public Routes. This allows you to control how many requests 
a client can send to your application exposed via a route over a given period of time. It is typically used to protect 
applications from abuse, accidental overload, or denial-of-service scenarios. Add the following annotations to your Route:

```sh
oc annotate route <route-name> \
  haproxy.router.openshift.io/rate-limit-connections="true" \
  haproxy.router.openshift.io/rate-limit-connections.concurrent="10" \
  haproxy.router.openshift.io/rate-limit-connections.rate="50"
```
* The annotation `rate-limit-connections=true` enables connection rate limiting on the router.
* The annotation `rate-limit-connections.concurrent=10`: allows a single client IP to have at most 10 concurrent connections.
* The annotation `rate-limit-connections.rate=50`: allows a single client IP to open at most 50 new connections per second.


## Image security

Outdated container images are prone to exploits via security vulnerabilities,
and unfamiliar images may contain malicious code. For these reasons, a given container
image should be used only if:

1. It is from a known and trusted source so that the known security
   vulnerabilities are patched, and you can trust it not to contain malicious
   code.
2. You have reviewed its Dockerfile, build configuration, and the base layer
   satisfies Rule number 1.

Other things to keep in mind:

* Use curated images.
* Prefer images that regularly receive security updates.
* Use static container image analysis tools if available. For support, ask your
  local IT support.
* The smaller the image, the less "surface area" there is for attacks:
  * Utilize the builder pattern in your images if you use compiled languages:
    Build the binary in a different image from where the application is
    deployed. In Docker, this can be achieved with [multi-stage
    builds](https://docs.docker.com/develop/develop-images/multistage-build/),
    and in OpenShift, directories of other images may be mounted during the build
    process by [chaining
    builds](https://cloud.redhat.com/blog/chaining-builds).
    This way, only essential pieces of the software are present in the
    final image.
  * If the application is written in an interpreted language, use language
    based images. Instead of installing Node.js on top of the Alpine image, use
    e.g., `node:21-alpine`.

## IP addresses for firewall openings

When you need to configure firewall openings for traffic coming from LUMI-K, it is advised to request an 
[Egress IP](configuration/network.md#egress-ips) for your LUMI-K project. This will allow the Pods in your LUMI-K 
project to use a dedicated and fixed IP for all egress traffic.

