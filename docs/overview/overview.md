

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

<!-- # LUMI Hardware -->
# Overview

[lumi-c]: ../computing/systems/lumic.md
[lumi-g]: ../computing/systems/lumig.md
[lumi-d]: ../computing/systems/lumid.md
[lumi-f]: ../storage/parallel/lumif.md
[lumi-p]: ../storage/parallel/lumip.md
[lumi-o]: ../storage/object/index.md
[lumi-k]: ../computing/auxiliary/lumik.md
[eap]: ../eap/index.md
[lumi-top500]: https://www.top500.org/system/180048/

<!-- [LUMI-C : The CPU computing partition][lumi-c]

[LUMI-G : The GPU computing partition][lumi-g]

[LUMI-D : Data analytics and visualization on LUMI][lumi-d]

[LUMI-F : The flash-based storage of LUMI][lumi-f]

[LUMI-P : The parallel filesystem of LUMI][lumi-p]

[LUMI-O : The object storage][lumi-o]

<br /> 

[LUMI-EAP : The GPU early Access Platform LUMI][eap] 

-->

<!-- 
<div class="lumi-overview">
  <figure>
    <img 
      src="../../assets/images/lumi-snowflake.svg" 
      width="90%" 
      style="margin: 0 auto;"
      alt="LUMI from 3000 feets"
    >
  </figure>
</div> -->

<!-- <font size="-1">
</font> -->

---
Here you find a description of the LUMI system architecture and the different partitions available on LUMI.

---


LUMI is one of the three European pre-exascale supercomputers. It's an HPE Cray EX supercomputer consisting of several partitions targeted different use cases. As of 06/2022, LUMI ranks third on the [top500.org list][lumi-top500]. LUMI is composed of multiple partitions, that are all connected via a Cray Slingshot 11 high-speed interconnect.

The primary compute power in LUMI is found in the [LUMI-G][lumi-g] partition which features GPU accelerated nodes using AMD Instinct MI250X GPUs. In addition to this, there is a smaller [LUMI-C][lumi-c] CPU-only partition that features AMD EPYC "Milan" CPUs as well as a small [LUMI-D][lumi-d] data analytics partition featuring large memory nodes (4 TB) and some NVIDIA A40 GPUs for data visualization.

Data storage on LUMI is provided by the [LUMI-P][lumi-p] parallel filesystem partition, the [LUMI-F][lumi-f] flash based parallel filesystem, and the [LUMI-O][lumi-o] object storage for a total of 117 PB of storage space.

Additionally, [LUMI-K][lumi-k] provides a container orchestration platform for use with LUMI.


<div class="lumi-overview">
  <p>
    <br>
    <a href="../../computing/systems/lumic/">LUMI-C : The CPU computing partition</a><br>
    <a href="../../computing/systems/lumig/">LUMI-G : The GPU computing partition</a><br>
    <a href="../../computing/systems/lumid/">LUMI-D : Data analytics and visualization</a><br>
    <a href="../../storage/parallel/lumip/">LUMI-P : The parallel filesystem</a><br>
    <a href="../../storage/parallel/lumif/">LUMI-F : The flash-based storage</a><br>
    <a href="../../storage/object/">LUMI-O : The object storage</a><br>
    <a href="../../computing/auxiliary/lumik/">LUMI-K : Container orchestration platform</a><br>
    <!-- LUMI-O : The object storage
    <br />
    LUMI-K : Container orchestration platform
    <br /> -->
    <br />
    <a href="../../eap/">LUMI-EAP : The GPU early Access Platform</a>
  
  </p>
    <figure>
    <img 
      src="../../assets/images/lumi-snowflake.svg" 
      width="100%" 
      style="margin: 0 auto;"
      alt="LUMI from 3000 feets"
    >
  </figure>  
</div>



