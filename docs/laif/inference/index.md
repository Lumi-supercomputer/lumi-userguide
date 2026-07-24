# AI Inference

[openai-api-reference]: https://developers.openai.com/api/reference/overview
[aitta-guide]: ./aitta.md
[aitta]: https://aitta.csc.fi
[vllm]: https://vllm.ai/
[ai-environment]: ../software/ai-environment.md
[ai-guide-vllm]: https://github.com/Lumi-supercomputer/LUMI-AI-Guide/tree/main/10-LLM-inference

AI-enabled services at their core rely on a trained machine learning model that predicts an output based on the given input. A prominent example is when a large language model (LLM) generates a chat response based on the full log of the previous conversation and potentially some additional context information for use in an AI chat assistant application. This prediction process is referred to as `inference`.

An `inference service` (or server) is a software process that performs inference upon request from a downstream application and thus forms a core component of an AI application. The inference service hides the complexity of running the actual models, which due to their size often require several GPUs or even several entire LUMI-G compute nodes, behind an abstracted interface. This typically takes the form of semantic HTTP endpoints, like the [OpenAI API][openai-api-reference], which has become a de-facto standard.


## AI Inference at LUMI AI Factory

The LUMI AI Factory will provide different inference service options for users to experiment with AI inference, catering to different needs.

### Aitta Inference Service

The Aitta inference service provides a collection of pre-selected models running in instances running on LUMI-G. Model instances are shared between users, which keeps individual costs low
and often ensures that popular models are already loaded and ready for immediate use.

The Aitta service frontpage is available at [aitta.csc.fi][aitta] and detailed usage instructions can be found in the [Aitta User Guide][aitta-guide].

### Self-hosted Inference Servers

You can also run your own inference server like [vLLM][vllm], which is available in the [LUMI AI Factory AI Software Environment][ai-environment], or similar. This gives you full control over the inference server and the ability to perform inference with any model you desire. It also ensures that you have the server for yourself and no other user has access to it, giving you sole access to the compute power of the reserved GPUs (e.g. for processing large batches of data at once).

However, it also has a few drawbacks:

- you are billed in GPU-hours the entire time your inference server is running, even if you are sending requests only infrequently and the model is mostly idle,
- the inference service will not be accessible to connections from outside the LUMI supercomputer, so your app development will have to take place within the system, and
- setting up the server instance and finding the optimal configuration is up to you.

A more detailed guide for running your own vLLM instance on LUMI is available in [Chapter 10 of the LUMI AI Guide][ai-guide-vllm].