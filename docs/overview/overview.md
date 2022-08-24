

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
[lumi-o]: ../storage/parallel/lumio.md
[eap]: ../eap/index.md

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


LUMI is one of the three European pre-exascale supercomputers. It's an HPE Cray EX supercomputer consisting of several partitions targeted for different use cases. The largest partition of the system is the "LUMI-G" partition consisting of GPU accelerated nodes using a future-generation AMD Instinct GPUs. In addition to this, there is a smaller CPU-only partition, "LUMI-C" that features AMD EPYC "Milan" CPUs and an auxiliary partition for data analytics with large memory nodes and some GPUs for data 
visualization. Besides partitions dedicated to computation, LUMI also offer several storage partitions for a total of 117 PB of storage space.


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



