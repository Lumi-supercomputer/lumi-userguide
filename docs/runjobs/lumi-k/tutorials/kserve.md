# KServe
KServe is an open-source Kubernetes-native model inference platform. It provides a standardized InferenceService custom resource that abstracts away the complexity of serving machine learning models. It works across major ML frameworks such as PyTorch, vLLM and Hugging Face transformers through pluggable model runtimes, and supports both predictive and generative AI workloads with the Open Inference Protocol for consistent client APIs.

Learn more in the official KServe documentation: https://kserve.github.io/website/docs/intro

## KServe Custom Resources

KServe exposes its functionality primarily through Kubernetes custom resources, which means deploying a model is a declarative operation — you describe the desired state in YAML, and the KServe controller reconciles the underlying Kubernetes resources like pods and services for you. Rather than interacting with the full surface area of the platform, day-to-day usage centers on just two CRs: ServingRuntime (or ClusterServingRuntime) and InferenceService.

The split between these two resources reflects a clean separation of concerns. ServingRuntime captures the infrastructure-level details of a model server while the InferenceService captures the model-level details. Together they let you go from a trained model artifact to a production endpoint with YAML files, while inheriting the protocol standardization that KServe provides.

### ServingRuntime

A ServingRuntime is a reusable template that defines how a particular class of models is served. It encapsulates the container image of a model server, the model formats it understands, and the runtime configuration needed to launch it.

ServingRuntime is a namespaced custom resource, therefore if you define a ServingRuntime it can only be used in your namespace. ClusterServingRuntime custom resource is the same as ServingRuntime except that it is cluster scoped. Unfortunately, it is not allowed to create ClusterServingRuntime objects in LUMI-K, however, the cluster has the following pre-defined ClusterServingRuntime which are available to all namespaces:

    - kserve-huggingfaceserver
    - kserve-torchserve
    - kserve-lgbserver
    - kserve-mlserver
    - kserve-pmmlserver
    - kserve-xgbserver
    - kserve-tensorflow-serving
    - kserve-paddleserver
    - kserve-sklearnserver

If a namespaced ServingRuntime and a cluster-scoped ClusterServingRuntime have the same name in case the runtime is explicitly specified in the InferenceService CR, then Kserve will select the ServingRuntime.

More information about the Serving Runtimes in the official documentation: https://kserve.github.io/website/docs/concepts/resources/servingruntime

### InferenceService

An InferenceService is the CR that actually brings a model online. It is a namespaced CR so the user has full control over its specification. Deploying a model in Kubernetes normally means hand-authoring a Deployment, a Service, and a route, and keeping them in sync as the model evolves.
InferenceService defines what to serve by pointing at a specific model artifact and declaring the deployment-level concerns that matter for a production endpoint. It collapses everything into a single declarative spec focused on the things a model owner actually cares about. The KServe controller reconciles the spec into the underlying Kubernetes objects and keeps them aligned with the desired state as you iterate.

## Setting up Inference in LUMI-K

In this tutorial we will deploy two models in LUMI-K: a scikit-learn predictive model and a huggingface LLM model using vLLM server. Both examples will be deployed in `kserve-inference-test` namespace; steps for creating a namespace in LUMI-K are explained [here](../getting-started/lumik_projects.md#create-a-new-project). **Note:  The following examples are adapted from the upstream KServe documentation and tailored to the LUMI-K deployment.**

### Deploying a Predictive Model

First, we will create a ServingRuntime custom resource and name it `scikit-learn-server`. This will provide the tepmplate to run scikit-learn based models.

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

We are using the upstream provided `kserve/sklearnserver` image for scikit-learn, but, you can also build your own custom image and replace this field. Once the ServingRuntime is created, we can proceed to creating the InferenceService CR.

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

Here the model is downloaded from a Google Cloud Storage (GCS) bucket. LUMI-K KServe supports the following storage options:

    - Hugging Face Model Hub
    - S3 compliant object storage
    - Azure Blob Storage
    - Google Cloud Storage
    - Git
    - LUMI-K's Persistent Volume Claims (PVCs)
    - HTTP(S) URIs

You can read more about each of the storage options and their authentication methods [here](https://kserve.github.io/website/docs/model-serving/storage/overview).

After creating the InferenceService CR, wait for it to become ready. You can also check the status of the correspoding pod in the `kserve-inference-test` namespace:

`oc get pods -n kserve-inference-test`

The sckit-learn model inference is deployed and ready to be used when the pod and the InferenceService CR are in the ready state. A Kubernetes service is automatically created in the same namespace to expose the inference endpoints. However, to expose the endpoints to the internet, we will need to create a Route object. Routes and IP whitelisting in LUMI-K are explained [here](../usage/networking.md#routes).

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
    name: sklearn-inference
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

### Deploying an LLM Model

setting up authentication
create the pvc
create inference service
    use the environment variable