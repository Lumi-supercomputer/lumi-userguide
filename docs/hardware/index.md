

<style scoped>
.lumi-overview {
  display: flex; 
  flex-direction: row; 
  align-items: center;
}

.lumi-overview p {
  width: 45%;
}

.lumi-overview figure {
    width: 55%;
  }

@media (max-width: 740px) {
  .lumi-overview {
    flex-direction: column;
  }

  .lumi-overview p {
    width: 50%;
  }

  .lumi-overview figure {
    width: 50%;
  }
}
</style>


# Overview

[lumi-c]: ../hardware/compute/lumic.md
[lumi-g]: ../hardware/compute/lumig.md
[lumi-d]: ../hardware/compute/lumid.md
[lumi-f]: ../hardware/storage/lumif.md
[lumi-p]: ../hardware/storage/lumip.md
[lumi-o]: ../hardware/storage/lumio.md
[lumi-k]: ../hardware/auxiliary/lumik.md
[lumi-interconnect]: ../hardware/interconnect.md
[eap]: ../hardware/compute/eap.md
[lumi-top500]: https://www.top500.org/system/180048/

---
Here you find a description of the LUMI system architecture and the different
hardware partitions available on LUMI.

---


LUMI is one of the three European pre-exascale supercomputers. It's an HPE Cray
EX supercomputer consisting of several hardware partitions targeted different
use cases. All of the hardware partitions are connected via a HPE Slingshot 11
high-speed [interconnect][lumi-interconnect]. As of 06/2022, LUMI ranks third
on the [top500.org list][lumi-top500].

The primary compute power in LUMI is found in the [LUMI-G][lumi-g] hardware
partition which features GPU accelerated nodes using AMD Instinct MI250X GPUs.
In addition to this, there is a smaller [LUMI-C][lumi-c] CPU-only hardware
partition that features AMD EPYC "Milan" CPUs as well as a small
[LUMI-D][lumi-d] data analytics hardware partition featuring large memory nodes
(4 TB) and some NVIDIA A40 GPUs for data visualization.

Data storage on LUMI is provided by the [LUMI-P][lumi-p] parallel file system
hardware partition, the [LUMI-F][lumi-f] flash based parallel file system
hardware partition, and the [LUMI-O][lumi-o] object storage hardware partition
for a total of 117 PB of storage space.

Additionally, the [LUMI-K][lumi-k] hardware partition provides a container
orchestration platform for use with LUMI.


<div class="lumi-overview">
  <p>
    <br>
    <a href="../hardware/compute/lumic/">LUMI-C : CPU compute</a><br>
    <a href="../hardware/compute/lumig/">LUMI-G : GPU compute</a><br>
    <a href="../hardware/compute/lumid/">LUMI-D : Data analytics</a><br>
    <a href="../hardware/storage/lumip/">LUMI-P : Parallel file system</a><br>
    <a href="../hardware/storage/lumif/">LUMI-F : Flash-based parallel file system</a><br>
    <a href="../hardware/storage/lumio/">LUMI-O : Object storage</a><br>
    <a href="../hardware/auxiliary/lumik/">LUMI-K : Container orchestration platform</a><br>
    <br>
  </p>
    <figure>
    <img 
      src="../assets/images/lumi-snowflake.svg" 
      width="100%" 
      style="margin: 0 auto;"
      alt="LUMI from 3000 feets"
    >
  </figure>  
</div>



