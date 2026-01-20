# Ephemeral storage

When local ephemeral (temporal) storage is needed, an `emptyDir` should volume should be created. The volume is local 
to the node in which the pod is running, on LUMI-K this is a local SSD disk. The volume can be shared across several
containers in the same Pod, and it is the *fastest* filesystem storage available in LUMI-K. However, the emptyDir volume
will be deleted if the Pod is deleted or migrated to another node. It is declared directly in the Pod definition as following example:

*`podWithEmptydDir.yaml`*:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-app
  labels:
    app: my-application
spec:
  volumes:
  - name: volume-a
    emptyDir: {}
  containers:
  - name: container-a
    image: almalinux:10
    volumeMounts:
    - mountPath: /outputdata
      name: volume-a
  - name: container-b
    image: almalinux:10
    volumeMounts:
    - mountPath: /interm
      name: volume-a
```

![emptyDir](../../img/lumik_pods_and_storage_emptydir.svg)

## Using memory as medium

It is possible to make an `emptyDir` even faster by using the memory as storage medium instead (i.e., **tmpfs**)
of the local disks. The size of data stored in a memory backed emptyDir is counted toward the Pod’s memory usage; 
this means the maximum size of data that can be stored is equal to the Pod memory limit (i.e., the size of memory 
limits of containers inside the Pod). If the Pod exceeds its memory limit, Kubernetes may terminate one or more 
containers with an OutOfMemory (`OOMKilled`) status. This can happen even if the application itself is not using too 
much memory — the contents of the tmpfs volume contribute to the limit. You can create memory backed emptyDir by
adding `medium: Memory` under `emptyDir` field. It is recommended to configure the `sizeLimit` to a value lower than the 
Pod memory limit.

* `podWithEmptyDirMemory.yaml`

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: test-pd
spec:
  containers:
  - image: busybox:stable
    name: test-container
    command: ['sh', '-c', 'while true; do sleep 50; done']
    volumeMounts:
    - mountPath: /cache
      name: cache-volume
    resources:
      limits:
        memory: 2Gi
  volumes:
  - name: cache-volume
    emptyDir:
      sizeLimit: 500Mi
      medium: Memory
```
