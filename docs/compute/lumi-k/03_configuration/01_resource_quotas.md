## Resource Requests and Limits

Each container inside a Pod can define two key resource settings:

* A **request** is the amount of CPU or memory that the container is guaranteed. The scheduler uses this value to decide 
where the Pod (and its containers) can run.
* A **limit** is the maximum amount of CPU or memory the container is allowed to use. If the container exceeds its memory 
limit, it may be terminated. If it exceeds its CPU limit, Kubernetes throttles it.

### Default requests and limits

If the user does not set custom requests and limits for a container within a Pod, the following values are set by default:

|Type|  CPU  | Memory |
|:-:|:-----:|:------:|
|requests| 1000m |  2Gi   |
|limits| 2000m |  2Gi   |


!!! info

    `m` stands for milicores. `1000m` will be the equivalent of 1 CPU core.


### Custom requests and limits

The user can set custom values for the requests and limits of a container, but these values have to fall in a default range 
configured by LUMI-K admins. The default range is as follows:


| Type | CPU | Memory |
|:----:|:---:|:------:|
| Min  | 50m |  8Mi   |
| Max  |  8  |  16Gi  |


Moreover, LUMI-K enforces a maximum limit-to-request ratio of 5. This means that the CPU or memory `limits` cannot be 
set to more than 5 times the `request`. So if the CPU request is 1 core, the CPU limit cannot be higher than 5 cores. 
If you want to increase the CPU limit to 10 cores, you will have to also increase CPU request to at least 2 cores.


!!! info

    If the default ranges are not suitable for your use case, you can request adjusted resource ranges by contacting 
    LUMI support. See the [Contact page](../../../helpdesk/index.md) for instructions.

The following example adjust the values of request and limit in a Pod to match LUMI-K defined range:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: example-pod
spec:
  containers:
  - name: app
    image: nginx:latest
    resources:
      requests:
        cpu: "200m"
        memory: "100Mi"
      limits:
        cpu: "1"
        memory: "500Mi"
```

## Projects quotas

All LUMI-K projects associated with the same LUMI project share the same resource quota.
The default quota assigned to a LUMI project within LUMI-K is as follows:

| Resource                                     | Default |
|----------------------------------------------|---------|
| CPU limits                                   | 12      |
| Memory limits                                | 48 Gi   |
| Persistent Storage                           | 200 Gi  |
| Ephemeral Storage                            | 10 Gi   |
| Number of image streams (images)             | 40      |
| Number of persistent volume claims           | 10      |
| Number of pods                               | 50      |
| Max size of images pushed to LUMI-K registry | 10 GiB  |

This means that the sum of CPU `limits`, of containers across all you LUMI-K projects associated with the same LUMI 
computing project cannot exceed 12 cores. The same restrictions apply for memory and other resources.


!!! warning "Note"

    Note that LUMI-K quotas are independent of the LUMI computing quotas that you applied for when creating LUMI project,
    and that LUMI-K usage does not count toward the LUMI computing quota.

!!! warning "Note"

    If your LUMI project is shared with other team members, they can create new LUMI-K projects
    (see [project creation page](../getting-started/lumik_projects.md)). Keep in mind that the quota will be shared with them.
    
You can find the resource usage and quota of a project in the project view in
the web interface under **Administration -> ResourceQuota** and **Administration -> LimitRanges**.


### Requesting more quota

If you need more resources than the defaults, you can apply for more LUMI-K quota by contacting the 
[Help Desk](../../../helpdesk/index.md#help-desk).