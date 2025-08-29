# LUMI AI Factory Services

!!! info "Note"
    Software installed under `/appl/local` are maintained by the respective
    local organizations.

The [LUMI AI Factory](https://www.lumi-supercomputer.eu/lumi-ai-factory) is developing and providing services on the current LUMI supercomputer, ahead of the deployment of the upcoming [LUMI-AI supercomputer](https://csc.fi/en/media-release/lumis-capacity-in-high-demand-to-be-succeeded-by-an-ai-optimized-supercomputer). As part of our ongoing ramp-up, we’re setting up a service center to provide a suite of tools, services, and user support for AI-related use cases.

The software provided by the LUMI AI Factory is separate from the official LUMI software stack maintained and supported by the LUMI User Support Team. Since the work is still in the early stages, the LUMI AI Factory provided offerings are under active development and the official support process has not yet been finalized. The software and services are currently offered as a preview.

Currently available tools and software:

* [Containerized Workflows](#containerized-workflows)

## Containerized Workflows

Containerized Workflows are developed by the LUMI AI Factory to streamline AI related tasks in HPC environment. The Containerized Workflows consist of pre-built container images, custom software, pre-tested models and examples as well as documentation that can be used to kickstart the use of AI in specific types of tasks. In later stages of development, the workflows will be integrated with the broader LUMI AI Factory software ecosystem.

### Getting Started

To get started with the Containerized Workflows, you can copy example directories from the workflow's examples folder into your project directory. These examples include all the necessary files to run a job on LUMI and can be easily adapted for your specific task.

An example batch job script is included for each example, which you can use to submit the job to the computing cluster. For detailed examples and instructions, refer to the README files located within the workflow example directories on LUMI.

### Overview of Available Workflows

#### LLM Text Processing

The LLM Text Processing workflow enables efficient text processing using Large Language Models (LLMs). This workflow is designed for tasks such as dataset curation, text summarization, and language translation. It leverages the vLLM library to process input files based on user-provided instructions and generate corresponding output files. The workflow uses a YAML configuration file to specify the files used for inputs, outputs, and processing instructions. It utilizes tensor parallelism and batched processing for achieving optimal performance.

**Use Case Examples:**

- Automating the curation of large text datasets for research purposes.
- Summarizing lengthy documents to extract key information.
- Translating text between multiple languages for multilingual research projects.

For more details, refer to the documentation available on LUMI at `/appl/local/laifs/workflows/vllm-text-processing`.

**Usage Example:**

1. **Copy the example directory** to your project space:
   ```bash
   cp -r /appl/local/laifs/workflows/vllm-text-processing/examples/example1 ~/my-llm-example
   cd ~/my-llm-example
   ```

2. **Edit the `task.yaml`** to specify your model, input/output wildcard paths, and templated prompt instructions:
   ```yaml
   ---
   name: Essay writing example
   model: Mistral-Small-3.1-24B-Instruct-2503
   inputs: "./input/input_{*}.txt"
   outputs: "./output/output_{}.txt"
   instructions: "./instructions.txt"
   ```

3. **Edit the instructions file** (`instructions.txt`) to define the prompt. The {input} placeholder will be replaced by the content of each input file.
   ```
   Please write an essay based on the question inside the <text></text> tags.
   Output only the actual essay and no additional content please.
   <text>
   {input}
   </text>
   ```

4. **Submit the job** using the provided batch script:
   ```bash
   sbatch -A your_project batch.sh
   ```

5. **Monitor progress** via Slurm output:
   ```bash
   tail -f slurm-*.out
   ```

6. **Check results** in the `output/` directory after completion. You will get one output file for each input file.

#### Vision-Language Batch Processing

The Vision-Language Batch Processing workflow can be used for image analysis using vision-language models. It uses the Transformers library to process input images based on user-provided instructions and generate output files with textual answers. This workflow supports task configuration through YAML files.

**Use Cases Examples:**

- Generating descriptive captions for a large collection of images.
- Analyzing visual content to answer specific questions about the images.
- Enhancing accessibility by providing textual descriptions of visual data for visually impaired users.

For more details, refer to the documentation available on LUMI at `/appl/local/laifs/workflows/huggingface-vqa`.

**Usage Example:**

1. **Copy the example directory** to your project space:
   ```bash
   cp -r /appl/local/laifs/workflows/huggingface-vqa/examples/example1 ~/my-vlm-example
   cd ~/my-vlm-example
   ```

2. **Edit the `task.yaml`** to specify your model, input/output wildcard paths, and templated prompt instructions:
   ```yaml
   ---
   name: My image QA task
   model: Qwen2.5-VL-7B-Instruct
   inputs: "/path/to/images/img_{*}.png"
   outputs: "/path/to/out/out_{}.txt"
   instructions: "/path/to/prompt.txt"
   ```

3. **Edit the instructions file** (`prompt.txt`) to define the prompt.
   ```
   Describe the nutritional content of the food in this image, with a particular focus on the amount of carbohydrates. No more than 50 words
   ```

4. **Submit the job** using the provided batch script:
   ```bash
   sbatch -A your_project batch.sh
   ```

5. **Monitor progress** via Slurm output:
   ```bash
   tail -f slurm-*.out
   ```

6. **Check results** in the `output/` directory after completion. You will get one output file for each input image.

#### YOLO Image Processing Workflow

The YOLO Image Processing Workflow is tailored for tasks such as object detection and classification using YOLO (You Only Look Once) models. This workflow processes input images and generates output files with class predictions in a human-readable format.

**Use Cases Examples:**

- Detecting and classifying objects in image files.

For more details, refer to the documentation available on LUMI at `/appl/local/laifs/workflows/yolo-image-processing`.

**Usage Example:**

1. **Copy the example directory** to your project space:
   ```bash
   cp -r /appl/local/laifs/workflows/yolo-image-processing/examples/example1 ~/my-yolo-example
   cd ~/my-yolo-example
   ```

2. **Edit the `task.yaml`** to specify your model and input/output wildcard paths. Images must be 224x224 pixels in PNG RGB format. This workflow does not use separate prompt instructions:
   ```yaml
   ---
   name: Object classification example
   model_dir: ../../../../models
   model_file: Ultralytics-YOLO11-v8.3.0/yolo11n-cls.pt
   inputs: "./input/{*}.png"
   outputs: "./output/{}.txt"
   ```

3. **Submit the job** using the provided batch script:
   ```bash
   sbatch -A your_project batch.sh
   ```

4. **Monitor progress** via Slurm output:
   ```bash
   tail -f slurm-*.out
   ```

5. **Check results** in the `output/` directory after completion. Each output file will contain class predictions with probabilities, for example:
   ```
   Prediction: tiger with probability 87.87%
   Prediction: tiger_cat with probability 9.21%
   Prediction: jaguar with probability 1.06%
   Prediction: lion with probability 0.44%
   Prediction: leopard with probability 0.42%
   ```
   You will get one output file for each input image.

