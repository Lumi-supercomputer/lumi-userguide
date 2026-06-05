# KServe
KServe is an open-source Kubernetes-native model inference platform. It provides a standardized InferenceService custom resource that abstracts away the complexity of serving machine learning models. It works across major ML frameworks such as PyTorch, vLLM and Hugging Face transformers through pluggable model runtimes, and supports both predictive and generative AI workloads with the Open Inference Protocol for consistent client APIs.

Learn more in the official KServe documentation: https://kserve.github.io/website/docs/intro

KServe exposes its functionality primarily through Kubernetes custom resources, which means deploying a model is a declarative operation — you describe the desired state in YAML, and the KServe controller reconciles the underlying Kubernetes resources like pods and services for you. Rather than interacting with the full surface area of the platform, day-to-day usage centers on just two CRs: ServingRuntime (or ClusterServingRuntime) and InferenceService.

The split between these two resources reflects a clean separation of concerns. ServingRuntime captures the infrastructure-level details of a model server such as the container image, supported frameworks, and runtime configuration. InferenceService then captures the model-level details. Together they let you go from a trained model artifact to a production endpoint with a single short YAML file, while inheriting the protocol standardization that KServe provides.
