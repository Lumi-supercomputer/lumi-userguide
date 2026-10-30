# MLflow

[lumi-k]: ../../runjobs/lumi-k/getting-started/lumi_k_what_is.md
[lumi-k-mlflow]: ../../runjobs/lumi-k/tutorials/mlflow.md

The MLflow app launches [MLflow
Tracking](https://mlflow.org/docs/latest/tracking.html), a user interface for
tracking machine learning runs.

To launch it, select the log directory where you have data to visualize and the
resources for the Slurm job. The log directory must be a valid directory with
logs for MLflow to function correctly.

In the **MLflow version or module** dropdown, you can select `lumi-multitorch`
to use MLflow from the
[LUMI AI Factory AI Software Environment](../../laif/software/ai-environment.md).
Selecting it shows a second dropdown where you can choose the container version.

!!! warning "Match the container version to your logs"
    MLflow stores its tracking data using a versioned schema. Select the same
    `lumi-multitorch` container version that you used to write the logs.
    Opening logs with a different MLflow version may fail or require a
    database schema migration.

Note it is also possible to deploy MLflow as a service on Kubernetes 
(using [LUMI-K Cloud][lumi-k]), more details are available in the short [tutorial][lumi-k-mlflow].
