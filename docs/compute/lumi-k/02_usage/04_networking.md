# Networking in LUMI-K

LUMI-K provides an integrated IPv4, software-defined network (SDN) layer that allows Pods to communicate inside the
cluster and with the outside world. In this network, every Pod gets its own IP address, allowing it to communicate with 
other Pods directly. By default, a pod can communicate only with Pods running in the same namespace
(i.e., LUMI-K project) unless changed by `NetworkPolicies`. When a Pod is restarted or moved, its IP address changes, 
thus, in order to provide stable IPs to applications, `Services` are used to dynamically map the IPs of one or more Pods
to fixed IPs and DNS records, which can be then used to reach the Pods. The IPs of Pods and Services are reachable form within the
cluster only, if a service is to be exposed to internet, you will need to create `Routes`. Hereafter, we explain these 
concepts in details.

## Pod IPs

Each Pod receives an IP address from the LUMI-K network (CIDR: 10.128.0.0/14). By default, Pods can communicate with
other Pods in the same LUMI-K project (i.e., namespace ) and cross-nodes Pod communication is ensured dynamically by the
LUMI-K network. However, it is not advisable to use the Pod IPs directly to reach Pods, as the IPs are ephemeral 
and can change when pods are recreated. You can check the IP addresses assigned to you pods using the following command:

```bash
oc get pods -o wide -n <lumi-k-project-name>
```


## Pod ports

A Pod can run one or more containers, and each container may expose one or more ports. Ports define which network 
endpoints inside the container are intended to receive traffic. While ports inside a Pod are not required to be 
explicitly declared when creating a Pod, doing so improves clarity, enables tools to introspect the application, 
and helps define how **Services** or other Pods should connect to it. Two different containers within the same Pod 
cannot listen to traffic on the same port. You can declare the ports exposed by your containers as in the following 
example:

```yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    app: my-app
  name: web-app
  namespace: my-lumi-k-project

spec:
  containers:
    - name: nginx
      image: nginx
      ports:
        - containerPort: 8080
        - containerPort: 8443
```



## Services

A Service is an abstraction that provides a stable way to access a group of Pods. Because Pods are temporary
and can be replaced at any time, their IP addresses also are temporary. A Service solves this by giving the group of Pods a 
consistent virtual IP and DNS name. The Service automatically keeps track of which Pods should receive traffic, 
based on labels, and forwards traffic to them, acting as  **load balancers**. This allows applications to communicate 
with each other reliably even as individual Pods are replaced, restarted, or scaled.

The following YAML definition creates a service object that points to all pods with label **app: my-app**, using the
`.spec.selector` field:

```yaml
apiVersion: v1
kind: Service
metadata:
  labels:
    app: my-svc
  name: my-service
  namespace: my-lumi-k-project
spec:
  ports:
  - name: my-http-port
    port: 80
    targetPort: 8080
  selector:
    app: my-app
  sessionAffinity: None
  type: ClusterIP
```


Moreover, the previous service definition targets port `8080` in the matching Pods and expose it as port `80`, this 
means that all traffic sent `<service-ip-or-dns>:80` is redirected to a matched at `<matched-pod-ip>:8080`. 

Every Service in LUMI-K receives a DNS name following this hierarchy:

`<service-name>.<lumi-k-project>.svc.cluster.local`

For example, a Service named `backend` in the LUMI-K project `my-project` will have the following DNS name:

`backend.my-project.svc.cluster.local`

This is the fully qualified domain name (FQDN) inside the cluster, however, Kubernetes provides shorter aliases, like
`backend` which can be used to refer to the service named `backend` from any application running inside the same
LUMI-K project where the service is created. Also, `backend.my-project` can be used to refer to the service from other 
LUMI-K projects.


## Routes

!!! info "Note"
    Routes are used to expose HTTP-based service, it is not possible to expose plain TCP/UDP services LUMI-K for now.

All the IP addresses assigned to Pods and Services are private and non-routable. If you want to expose your **HTTP** 
application to internet you will need to create a [Route](https://docs.redhat.com/en/documentation/openshift_container_platform/4.19/html/ingress_and_load_balancing/routes).
A Route allows you to map a public and routable hostname to a Service object created inside your LUMI-K project. 
In the following example, all `HTTP` traffic sent to hostname `myapp.apps.lumi-k.eu` is redirected to the Service named
`my-service`, which in its turn redirected to the appropriate Pods :


```yaml
apiVersion: route.openshift.io/v1
kind: Route
metadata:
  name: my-route
spec:
  host: myapp.apps.lumi-k.eu
  to:
    kind: Service
    name: my-service
  port:
    targetPort: 80
```

The `.spec.host` field can be set to any value, however, the Route works out-of-box if you use the
`*.apps.lumi-k.eu` as suffix for your hostname. Otherwise, more configurations are needed for setting 
[custom domain names](#custom-domains).

You can also configure the TLS termination for your Route, three options are available:

* **Edge:** this is the default and the simplest TLS termination to configure. The TLS connectivity is terminated at 
the LUMI-K router, which means that The router decrypts the incoming connection and forwards plain HTTP to the backend 
Service/Pod. Use this termination if your application does not need to manage TLS certificates and does not require 
end-to-end encryption. This is default, and you do not need to configure it yourself in the Route.

* **Passthrough termination:** the LUMI-K router does not terminate TLS at all. It simply forwards encrypted traffic 
directly to the Service/Pod. The Pod is responsible for TLS decryption. Use this, if your application needs to manage
its own TLS certificates, and requires end-to-end encrypted traffic. Add the following configuration to your Route to 
use _Passthrough_:


```yaml
spec:
  ....
  ....
  tls:
    termination: passthrough
```



* **Re-encrypt:**  this a hybrid mode. The router terminates TLS from the client, then initiates a new TLS connection 
to the Pod. Pods mapped to the service, are expected to have valid certificate for the DNS name of the service. 
This is for example used when you want the default LUMI-K router certificate to be used for client TLS sessions, while 
the private certificate used to enrypt the traffic inside the LUMI-K cluster. Add the following configuration to your Route to 
use _Re-encrypt_:

```yaml
spec:
  ....
  ....
  tls:
    termination: reencrypt
    destinationCACertificate: |
      <CA for backend certificate>
```

The `destinationCACertificate` CA certificate is used to validate the private Pod/service certificate.

Routes support several configuration and features like rate limiting, IPs white-listing (firewall), HTTP-to-HTTPS 
redirection, and other options that can be explored in the [external docs](https://docs.redhat.com/en/documentation/openshift_container_platform/4.19/html/ingress_and_load_balancing/routes).
However, note that the used TLS termination can limit the usable features.


### Custom domains

You can configure any domain name as host in your route, but in that case, you have to:

1. Provide the public certificate for your custom domain, and its corresponding private key, in fields 
`.spec.tls.certificate` and `.spec.tls.key` respectively. Any certificate provider can be used.

2. Configure a DNS `CNAME` for your domain, pointing to `router-default.v1.apps.lumi-k.eu`. If that not possible, then
an `A` record containing the IP of `router-default.v1.apps.lumi-k.eu` has to be configured. The way this needs to be 
configured depends on the DNS solution you used to register your custom domain, please check with your IT admins. You can
check if your custom domain name has the right configuration using the following command:

    ```bash
    $ host <your.custom.domain.name>
    <your.custom.domain.name> is an alias for router-default.v1.apps.lumi-k.eu.
    router-default.v1.apps.lumi-k.eu has address 86.50.173.222
    ```


### IP Whitelisting

An important feature of Routes, is the IP whitelisting , ie: only allowing a range of IPs to access the route. 
This can be achieved by creating an annotation in the Route object with the key `haproxy.router.openshift.io/ip_whitelist`, 
and by setting the value to a space separated list of IPs and/or network ranges:

* This first example will whitelist a network IP rang (`193.166.0.0/16`):

    ```bash
    oc annotate route $route_name haproxy.router.openshift.io/ip_whitelist='193.166.0.0/16'
    ```

* It is possible to whitelist only a specific IP:

    ```bash
    oc annotate route $route_name haproxy.router.openshift.io/ip_whitelist='188.184.9.236'
    ```

* It is also possible to whitelist multiple IPs and networks at the same time:

    ```bash
    oc annotate route $route_name haproxy.router.openshift.io/ip_whitelist='193.166.0.0/15 193.167.189.25'
    ```


## Network policies

By default, Pods in LUMI-K can receive traffic only from Pods and Services created in the same LUMI-K project. However, 
it is possible to change this behaviour by creating new
[NetworkPolicies](https://kubernetes.io/docs/concepts/services-networking/network-policies/) or editing the default ones 
in your LUMI-K project. By default, Two network policies are created for each LUMI-K project, `allow-from-router` and 
`deny-other-namespaces-access`. The `allow-from-router` policy allows `Routes` to forward external traffic to your Pods,
and  the `deny-other-namespaces-access` policy restrict the allowed ingress traffic to your namespace (LUMI-K project).

You can edit the NetworkPolicies using the web console or the CLI. In the web consol, navigate to 
`Networking > NetworkPolicies`. Use the following commands to edit the default NetworkPolicies.

```bash
oc edit networkpolicy `allow-from-router` -n <lumi-k-project-name>
oc edit networkpolicy `deny-other-namespaces-access` -n <lumi-k-project-name>
```

## Egress IPs

By default, the egress traffic (outgoing traffic) from LUMI-K uses changing IP addresses for the source IP. This means, 
by default users do not have control over source the IP addresses used by their Pods to communicate with services
outside LUMI-K. However, if needed, you can request a dedicated egress IP for your LUMI-K project by contacting 
[Help Desk](../../../helpdesk/index.md#help-desk). Each request is reviewed on a case-by-case basis due to the limited size of IPs pool.
