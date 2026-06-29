# KServe
KServe is an open-source Kubernetes-native model inference platform. It provides a standardized **InferenceService** 
object that abstracts away the complexity of serving machine learning models.  It works across major ML frameworks such
as PyTorch, vLLM and Hugging Face transformers through pluggable model runtimes, and supports both predictive and 
generative AI workloads with standard client APIs.

Learn more in the official KServe documentation: https://kserve.github.io/website/docs/intro

## KServe functionality

KServe exposes its functionality primarily through Kubernetes dedicated objects (a.k.a Custom Resources), which means 
deploying a model is a declarative operation. In other words, you describe the desired model  and its runtime as YAML 
definition in the LUMI-K cluster, and the Kserve controller do the actual deployment of the model by managing the 
underlying Kubernetes resources like pods and services for you. Rather than managing several Kubernetes objects required
for deploying and exposing your AI models, day-to-day operations for your inference service can be handled by two 
dedicated Kubernetes objects: **ServingRuntime** and **InferenceService**.

The split between these two resources reflects a clean separation of concerns. **ServingRuntime** captures the 
infrastructure-level details of a model server while the **InferenceService** captures the model-level details. Together 
they let you go from a trained model artifact to a production endpoint with abstracted and simple configuration.


### ServingRuntime

A **ServingRuntime** is a reusable template that defines how a particular class of models is served. It encapsulates the
container image of a model server, the model formats it understands, and the runtime configuration needed to launch it.

ServingRuntime is a namespaced object, therefore if you create a ServingRuntime it can only be used in your namespace. 

In addition to ServingRuntime objects managed by users, LUMI-K provide default runtimes via the ClusterServingRuntime 
objects. The ClusterServingRuntime object is the same as ServingRuntime except that it is cluster scoped 
(i.e., can be used referenced from all namespaces). Users are not allowed to edit or create  ClusterServingRuntimes,
however they can use them directly in their InferenceServices. LUMI-K provide the following default ClusterServingRuntime: 

    - kserve-huggingfaceserver
    - kserve-torchserve
    - kserve-lgbserver
    - kserve-mlserver
    - kserve-pmmlserver
    - kserve-xgbserver
    - kserve-tensorflow-serving
    - kserve-paddleserver
    - kserve-sklearnserver

If a namespaced ServingRuntime and a cluster-scoped ClusterServingRuntime have the same name, the ServingRuntime has 
precedence in the InferenceService object. More information about the Serving Runtimes in the official
[documentation](https://kserve.github.io/website/docs/concepts/resources/servingruntime).

### InferenceService

An **InferenceService** is the object that actually deploys and exposes the model as an API. It is a namespaced object,
which means that users have full control over its specification. InferenceService defines what to serve by pointing at a
specific model artifact and declaring other parameters that specifies how the model is deployed and exposed. 
It encompasses everything into a single declarative specification focused on the things a model owner actually cares 
about. The KServe controller reconciles the specification into the underlying Kubernetes objects and keeps them aligned 
with the desired state as you iterate.


## Setting up Inference in LUMI-K

In this tutorial we will deploy two models in LUMI-K: a scikit-learn predictive model and a huggingface LLM model using
vLLM server. Both examples will be deployed in `kserve-inference-test` namespace; steps for creating a namespace 
(a.k.a., project) in LUMI-K are explained [here](../getting-started/lumik_projects.md#create-a-new-project).

**Note:  The following examples are adapted from the upstream KServe documentation and tailored to the LUMI-K deployment.**

### Deploying a Predictive Model

First, we will create a **ServingRuntime** object and name it `scikit-learn-server`. This will provide the runtime for 
scikit-learn based models.

```
apiVersion: serving.kserve.io/v1alpha1
kind: ServingRuntime
metadata:
  name: scikit-learn-server
  annotations:
    serving.kserve.io/server-type: scikit-learn-server
spec:
  supportedModelFormats:
    - name: sklearn
      version: "1"
      autoSelect: true
      priority: 1
  protocolVersions:
    - v1
    - v2
  containers:
    - name: kserve-container
      image: kserve/sklearnserver:v0.18.0
      args:
        - --model_name={{.Name}}
        - --model_dir=/mnt/models
        - --http_port=8080
      resources:
        requests:
          cpu: "4"
          memory: 10Gi
        limits:
          cpu: "2"
          memory: 20Gi
```

We are using the upstream provided `kserve/sklearnserver` image for scikit-learn, but, you can also build your own 
custom image and replace this field. Once the **ServingRuntime** is created, we can proceed to creating the **InferenceService**
object.

```
apiVersion: serving.kserve.io/v1beta1
kind: InferenceService
metadata:
  name: sklearn-inference
  namespace: kserve-inference-test
spec:
  predictor:
    model:
      modelFormat:
        name: sklearn
      protocolVersion: v2
      runtime: scikit-learn-server
      storageUri: "gs://kfserving-examples/models/sklearn/1.0/model"
```

Here the model is downloaded from a Google Cloud Storage (GCS) bucket as an anonymous user. LUMI-K KServe supports the following storage options:

    - Hugging Face Model Hub
    - S3 compliant object storage
    - Azure Blob Storage
    - Google Cloud Storage
    - Git
    - LUMI-K's Persistent Volume Claims (PVCs)
    - HTTP(S) URIs

You can read more about each of the storage options and their authentication methods 
[here](https://kserve.github.io/website/docs/model-serving/storage/overview).

After creating the InferenceService object, wait for it to become ready. You can also check the status of the 
corresponding pod in the `kserve-inference-test` namespace:

`oc get pods -n kserve-inference-test`

The sckit-learn model inference is deployed and ready to be used when the pod and the InferenceService object are in the
ready state. A Kubernetes service is automatically created in the same namespace to expose the inference endpoints. 
However, to expose the endpoints to the internet, we will need to create a Route object. Routes and IP whitelisting in LUMI-K are explained [here](../usage/networking.md#routes).

```
apiVersion: route.openshift.io/v1
kind: Route
metadata:
  name: sklearn-inference
  namespace: kserve-inference-test
spec:
  host: sklearn-inference.apps.lumi-k.eu
  to:
    kind: Service
    name: sklearn-inference-predictor
  port:
    targetPort: 80
```

Finally, we can test our deployed model with an input payload:
```
 {"inputs": [
    {
      "name": "input-0",
      "shape": [2, 4],
      "datatype": "FP32",
      "data": [
        [6.8, 2.8, 4.8, 1.4],
        [6.0, 3.4, 4.5, 1.6]
    ]}]}
```
We can use curl or any HTTP client to send a request to the inference endpoint using KServe's Open Inference Protocol v2.

```
curl -v \
  -H "Content-Type: application/json" \
  -d @./iris-input.json \
  http://sklearn-inference.apps.lumi-k.eu/v2/models/sklearn-iris/infer
```
This should return an output similar to the following:
```
{
  "model_name": "sklearn-iris",
  "model_version": null,
  "id": "c9d537b8-9716-46ce-a437-42f1ae9333d3",
  "parameters": null,
  "outputs": [
    {
      "name": "output-0",
      "shape": [2],
      "datatype": "INT32",
      "parameters": null,
      "data": [1,1]
    }]}
```
### Deploying an LLM Model
In this example, we will deploy Qwen3-4B-Instruct-2507 model which is hosted in Hugging Face Model Hub [here](https://huggingface.co/Qwen/Qwen3-4B-Instruct-2507). 
It is a small 4B parameters model with function/tool calling capabilities for agentic use. We'll use the pre-defined 
**ClusterServingRuntime** `kserve-huggingfaceserver` which is available for all namespaces. 
Furthermore, the example uses a Hugging Face access token in place of the anonymous client, allowing models that require
authentication to be retrieved.

First create a secret that stores you Hugging Face token. Make sure this token has enough permissions to pull the
required model:
```
apiVersion: v1
kind: Secret
metadata:
  name: hf-token
  namespace: kserve-inference-test
type: Opaque
data:
  HF_TOKEN: <hf-token base64 encoded>
```

Create a Kubernetes ServiceAccount and reference the created secret so that the ServiceAccount can access it:
```
apiVersion: v1
kind: ServiceAccount
metadata:
  name: kserve-deploy-sa
  namespace: kserve-inference-test
secrets:
  - name: hf-token
```



KServe uses  an initContainer in the same pod as the inference server pod which automatically downloads the model and
stores it at `/mnt/models/`. However. as LLM models require substantial disk space. It is recommended to mount a 
[PersistentVolumeClaim (PVC)](../usage/storage/persistent_storage.md/#persistentvolumeclaims-pvcs) at `/mnt/models/` 
using one of LUMI-K's [storage classes](../usage/storage/persistent_storage.md/#storageclasses-scs). For fast local 
storage it is recommended to use the [LVM storage class](../usage/storage/persistent_storage.md/#3-lvm-storageclass). 
Nevertheless, if you wish to mount the same PVC instance at different instances of your inference pods, you have to use
the [CephFS storage class](../usage/storage/persistent_storage.md/#1-cephfs-storageclass).

```
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: my-pvc
  namespace: kserve-inference-test
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 100Gi
  storageClassName: rook-ceph-fs
  volumeMode: Filesystem
```

In case of model being hosted by Hugging Face, the initContainer also uses the path `/.cache` of the initContainer while downloading the model. This is not permitted according to OKD security policies. Therefore, in LUMI-K Kserve, if the model is pulled from Hugging Face, the same PVC as created above is configured to be automatically mounted at `/.cache`.

Next we create the InferenceService CR which defines the model to be deployed, the resources to be used and its runtime arguments:

```
apiVersion: serving.kserve.io/v1beta1
kind: InferenceService
metadata:
  name: qwen-inference
  namespace: kserve-inference-test
spec:
  predictor:
    serviceAccountName: kserve-deploy-sa
    model:
      args:
        - '--model_name=qwen'
        - '--enable-auto-tool-choice'
        - '--tool-call-parser=qwen3_xml'
        - '--max-model-len=8192'
        - '--max-num-seqs=8'
        - '--dtype=bfloat16'
      env:
        - name: VLLM_CPU_KVCACHE_SPACE
          value: '24'
      modelFormat:
        name: huggingface
      name: ''
      resources:
        limits:
          cpu: '16'
          memory: 32Gi
        requests:
          cpu: '8'
          memory: 24Gi
      storageUri: 'hf://Qwen/Qwen3-4B-Instruct-2507'
    volumes:
      - name: kserve-provision-location
        persistentVolumeClaim:
          claimName: my-pvc
```

The predictor block in the InferenceService Spec defines the component that actually serves the model. There are some configurations that should be noted:

- **serviceAccountName: kserve-deploy-sa** — the ServiceAccount the predictor Pod runs as. This the same SA we defined earlier and is bound to the secrets needed to authenticate to Hugging Face.
- **modelFormat.name: huggingface** — selects a ServingRuntime (or ClusterServingRuntime in this case) that advertises support for the huggingface format.
- **storageUri: hf://Qwen/Qwen3-4B-Instruct-2507** — the source of the model weights. The hf:// scheme tells KServe to pull directly from the Hugging Face Hub, using the token attached to the ServiceAccount above.
- **env.VLLM_CPU_KVCACHE_SPACE: '24'** — reserves 24 GiB of host memory for the KV cache when running vLLM on CPU. If not defined, vLLM's KV cache assumes it can consume all the memory avaible on the physical node. This results in the pod to be OOM killed due to memory resource limits.
- **args** — flags passed through to the vLLM server:
    - **--model_name=qwen** — the logical name clients use when making inference requests.
    - **--enable-auto-tool-choice** and **--tool-call-parser=qwen3_xml** — enable tool-calling and tell vLLM how to parse Qwen's tool-call output format.
    - **--max-model-len=8192** — caps the context window at 8K tokens. This can be increased up to 262,144 for this model but will require much more memory.
    - **--max-num-seqs=8** — limits concurrent in-flight sequences, keeping memory usage predictable.
    - **--dtype=bfloat16** — loads weights in bfloat16 to reduce memory footprint.
- **resources** — requests 8 CPUs / 24 GiB of memory and caps the Pod at 16 CPUs / 32 GiB. These bounds must accommodate both the model weights and the KV cache reservation above.
- **spec.predictor.volumes: kserve-provision-location** — a PVC mounted into the predictor Pod, used by KServe's storage initContainer to stage the downloaded model weights as explained above. Make sure to keep the name of the volume to be always "kserve-provision-location" as shown in the example.

Similar to the previous example, when the InferenceService object and the corresponding pod(s) become ready, the model deployment is completed. KServe automatically creates a service which exposes the inference endpoint. We can expose the endpoint to the internet using a Route:

```
apiVersion: route.openshift.io/v1
kind: Route
metadata:
  name: qwen-inference
  namespace: kserve-inference-test
  annotations:
    haproxy.router.openshift.io/timeout: '300s'
spec:
  host: qwen-inference.apps.lumi-k.eu
  to:
    kind: Service
    name: qwen-inference-predictor
  port:
    targetPort: 80
```
LLMs can take a while to respond due to multiple factors such the amount of memory available for the model and how complicated the prompt is. Therefore, it is recommended to add the annotation in the Route object to increase the timeout for the ingress connection as shown above.

Finally, we can test our deployed model with an input payload:

```
{
  "model": "qwen",
  "messages": [
    {
      "role": "system",
      "content": "You are a helpful assistant that provides clear and concise answers."
    },
    {
      "role": "user",
      "content": "Write a paragraph on climate change."
    }
  ],
  "max_tokens": 150,
  "temperature": 0.7,
  "stream": false
}
```

We can use curl or any HTTP client to send a request to the inference endpoint using OpenAI-compatible API.

```
curl -v \
  -H "Content-Type: application/json" \
  -d @./qwen-input.json \
  http://qwen-inference.apps.lumi-k.eu/openai/v1/chat/completions
```
This should return an output similar to the following:
```
{
  "id": "chatcmpl-878aae738737f602",
  "object": "chat.completion",
  "created": 1781006737,
  "model": "qwen",
  "choices": [
    {
      "index": 0,
      "message": {
        "role": "assistant",
        "content": "Climate change refers to the long-term changes in Earth's weather patterns, including rising temperatures, altered precipitation patterns,and shifts in seasonal climates. These changes have serious implications for human societies around the world, affecting everything from agriculture and water resources to air quality and public health.\n\nOne of the most significant impacts of climate change is its impact on ecosystems. Many species are facing extinction due to habitat loss, pollution, and other factors. Climate change also alters the timing of seasons and weather events, leading to increased frequency and intensity of extreme weather events such as hurricanes, droughts, and floods.\n\nThe effects of climate change extend far beyond the immediate environment. It can lead to social and economic disruptions, including food shortages, displacement of people, and reduced access to",
      },
      "finish_reason": "length",
    }
  ],
  "usage": {
    "prompt_tokens": 32,
    "total_tokens": 182,
    "completion_tokens": 150,
  },
}
```