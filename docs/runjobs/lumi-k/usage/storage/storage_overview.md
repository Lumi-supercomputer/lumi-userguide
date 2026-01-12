# Storage in LUMI-K

While containers are designed to be ephemeral, many workloads need persistent storage that survives restarts, 
rescheduling, or updates. Kubernetes solves this by introducing abstractions that allow storage to be requested,
attached, and managed independently of Pods. LUMI-K supports different types of storage depending on how long data
needs to live and how it should be accessed. The available storage option in LUMI-K are ephemeral storage, 
persistent storage, and object storage. Each serves a different purpose and is suitable for different workloads.

![Storage options](../../img/lumik_storage_options.svg)

## Ephemeral storage

Ephemeral storage exists only for the lifetime of a Pod. When the Pod stops, restarts, or is rescheduled to another 
node, the data is lost. Ephemeral storage is provided in LUMI-K via `emptyDir` volumes. EmptyDir allow fast read and write
access by the applications running inside the containers to data that can be recreated or does not need to survive, for example:

* Caches.
* Temporary files or scratch space.
* Working directories for short tasks or jobs.
* Intermediate data during processing.

Do **not** use ephemeral storage for user data, databases, or anything that must persist.

You can find additional information on the [Ephemeral storage](ephemeral_storage.md) page.

## Persistent storage

Persistent storage survives Pod restarts, failures, and rescheduling. Kubernetes provides PersistentVolumes (PVs)
and PersistentVolumeClaims (PVCs) to manage persistent data independently of Pods. Persistent storage ensures that 
applications can reliably store and retrieve data even when Pods move between nodes. Persistent storage is essential for
stateful applications. Use persistent storage when your application must retain data even when pods are re-created 
or deleted:

* Databases (PostgreSQL, MySQL, MongoDB)
* Message queues (Kafka, RabbitMQ)
* Applications that manage user-generated content
* State that must survive updates, restarts, or node failures

You can find additional information on the [Persistent volume](persistent_storage.md) page.


## Object storage

Object storage is an external service accessed via an API (typically HTTP/S3). It stores data as objects rather than 
files and is optimized for durability and scalability. Objects are not mounted as a filesystem. Applications must 
download them for read access and upload them back to persist changes. Object storage is suitable when data is large and
unstructured, or need to be published over internet and does not need to be accessed as a local filesystem:

* Backups and archives.
* Large binary files (images, video, datasets).
* Machine learning training data.
* Scientific or research data.
* Application assets served externally.
* Logs or analytical outputs stored outside the cluster.

[LUMI-O](../../../../storage/lumio/index.md#lumi-o) is an object storage service that can be used in LUMI-K.