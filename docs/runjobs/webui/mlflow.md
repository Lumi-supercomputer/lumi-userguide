# MLflow

[lumi-k]: ../../runjobs/lumi-k/getting-started/lumi_k_what_is.md
[lumi-k-mlflow]: ../../runjobs/lumi-k/tutorials/mlflow.md

The MLflow app launches [MLflow
Tracking](https://mlflow.org/docs/latest/tracking.html), a user interface for
tracking machine learning runs.

To launch it, select the log directory where you have data to visualize and the
resources for the Slurm job. The log directory must be a valid directory with
logs for MLflow to function correctly.

Note it is also possible to deploy MLflow as a service on Kubernetes 
(using [LUMI-K Cloud][lumi-k]), more details are available in the short [tutorial][lumi-k-mlflow].
