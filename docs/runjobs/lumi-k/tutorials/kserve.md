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

