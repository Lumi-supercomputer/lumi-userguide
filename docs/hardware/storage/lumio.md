
# Object storage - LUMI-O

!!! warning
    This page is about a hardware partition that is not yet available.

The LUMI-O object store offers a total of 30 PB storage for storing, sharing,
and staging of data.

In an object-based storage, data is managed as objects instead of being
organized as files in a directory hierarchy.

Within your object storage project space you can create buckets. These buckets
will store objects with metadata associated to these objects.

<figure>
  <img
    src="../../assets/images/object-storage-component.svg"
    width="450"
    alt="Object storage components"
  >
</figure>

- **Buckets**: Containers used to store one or more objects.
  Object storage uses a flat structure with only
  one level which means that buckets cannot contain other buckets.
- **Objects**: Any type of data. An object is stored in a bucket.
- **Metadata**: Both buckets and objects have metadata specific to them. The metadata of a bucket specifies e.g. the access rights to the bucket. While traditional
  file systems have fixed metadata (filename, creation date, type, etc.), an
  object storage allows you to add custom metadata.
