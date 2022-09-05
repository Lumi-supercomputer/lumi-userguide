# DeepSpeed on LUMI
[DeepSpeed](https://www.deepspeed.ai) is a deep learning optimization library which, among [many capabilities](https://www.microsoft.com/en-us/research/project/deepspeed/features/), makes possible the training of models with billions of parameters, which might not fit on the GPU memory. The DeepSpeed API is a lightweight wrapper on PyTorch.

DeepSpeed can be installed as well from our EasyBuild recipes
```bash
module load LUMI/22.08 partition/G
module load EasyBuild-user
eb DeepSpeed-0.7.2-cpeGNU-22.08.eb -r
```

Once installed, DeepSpeed can be run like in this example
```bash
#!/bin/bash
#SBATCH --job-name=deepspeed-bert
#SBATCH --ntasks=32
#SBATCH --ntasks-per-node=8
#SBATCH --gpus-per-node=8
#SBATCH --time=0:10:0
#SBATCH --partition gpu
#SBATCH --account=<account>

module load LUMI/22.08
module load partition/G
module load DeepSpeed
export NCCL_SOCKET_IFNAME=hsn0,hsn1,hsn2,hsn3
export NCCL_NET_GDR_LEVEL=3

export TRANSFORMERS_OFFLINE=1
export HF_DATASETS_OFFLINE=1

srun python bert_squad_deepspeed_train.py --deepspeed_config ds_config.json
```
The script [`bert_squad_deepspeed_train`](https://raw.githubusercontent.com/Lumi-supercomputer/lumi-reframe-tests/23a57f141ff6a95f80e2b6cd550e7299c6cd1592/checks/apps/deeplearning/deepspeed/src/bert_squad_deepspeed_train.py) used DeepSpeed to fine-tune BERT from [HuggingFace](https://huggingface.co) for the text extraction task on the [SQuAD dataset](https://rajpurkar.github.io/SQuAD-explorer/). The configuration file is [`ds_config.json`](https://raw.githubusercontent.com/Lumi-supercomputer/lumi-reframe-tests/23a57f141ff6a95f80e2b6cd550e7299c6cd1592/checks/apps/deeplearning/deepspeed/src/ds_config.json).

Since the compute nodes are not connected to the internet, the model, the tokenizer and the data must be available before running the job. All that can be fetched by running the following on a login node
```bash
module load LUMI/22.08
module load partition/G
module load DeepSpeed

python bert_squad_deepspeed_train.py --download-only
```
Notice that in the Slurm batch script, the `transformers` and `datasets` modules are used offline by setting `TRANSFORMERS_OFFLINE=1` and `HF_DATASETS_OFFLINE=1`.
