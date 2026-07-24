# MLflow

MLflow is an open-source platform designed to streamline the machine learning (ML) lifecycle. It helps data scientists and engineers manage experiments, track model performance, and deploy models efficiently. Its flexibility allows integration with popular ML frameworks like TensorFlow, PyTorch, and Scikit-learn, making it easy to integrate into any ML workflow.

Learn more in the official MLflow documentation:
https://mlflow.org/docs/latest/

## Deploying MLflow in LUMI-K

MLflow in LUMI-K can be deployed using [Helm](https://helm.sh/) either from the LUMI-K web user interface in the Software Catalog or via the Helm CLI. In both cases you can add custom values to override default Helm chart values as explained in the values section.

### Using the Software Catalog

1. Create a project in LUMI-K as explained [here](../getting-started/lumik_projects.md#create-a-new-project).

2. Navigate to MLflow Helm Chart in the LUMI-K Software Catalog:
    - On the menu in the left, click on Software Catalog under the Ecosystem section.
    - Search for MLflow in the search box.
    - Click on the MLflow Helm chart.

    ![mlflow software caralog](../img/lumik_mlflow_software_caralog.png)

3. Click on the create button. This will open the "Create Helm Release" form.
4. Give a custom name to your Mlflow Helm release in the "Release name" dialogue box. 
5. Under the "configuration via Form view / YAML view" section, add your custom values to override the default Helm chart values. Overriding default values is explained [here](#overriding-the-default-values).

    ![mlflow helm values UI](../img/lumik_mlflow_values.png)

6. Click on the create button to install a Helm release.
7. Navigate to Releases under the Helm section in the same Ecosystem section in left-side menu. There you can see the status of your Mlflow release. Make sure you are in the correct LUMI-K project. If everything went well, the status column should show "Deployed".
8. If the MLflow tracking server was exposed via a Ingress object, navigate to the Ingress section under Networking from the left-side menu. Here you can see your Ingress endpoint under the Location column. Use this endpoint to access the MLflow tracking server.

### Using the Helm CLI

1. Install Helm CLI tool in your local workstation following the instructions [here](https://helm.sh/docs/intro/install).
2. Login to LUMI-K using the oc CLI tool as explained [here](../getting-started/lumik_cli.md#how-to-login-with-oc).
3. Create a project in LUMI-K:
    ```bash
    oc new-project <your project name> --description="lumi_project: <lumi_project_number>"
    ```
4. Add the cscfi Helm chart repository:
    ```bash
    helm repo add cscfi https://cscfi.github.io/helm-charts/
    ```
    Make sure we get the latest charts from the repo before proceeding:
    ```bash
    helm repo update
    ```
5. Install the MLflow Helm chart from cscfi repo:
    ```bash
    helm install <your release name> -n <your project name> cscfi/mlflow 
    ```
    You can add your custom values to override the default chart values using the `--set` option in the above command. If there are multiple custom values, you can put all the custom values in a single values.yaml file and refer to it in the above command using the `-f values.yaml` option. Overriding default values is explained [here](#overriding-the-default-values).
6. To check the status of the Helm deployment:
    ```bash
    helm status <your release name> -n <your project name>
    ```
    The status field should show "Deployed" in case of a successful Helm deployment.
7. If the Mlflow tracking server was exposed via a Route object, use the following command to get the tracking server endpoint:
    ```bash
    oc get route/mlflow-tracking --namespace=<your project name> -o jsonpath='{.spec.host}'
    ```


### Overriding the Default Values
The MLflow Helm chart from cscfi (and the dependent Mlflow chart from MLflow Community) have multiple default values that can be overriden by the end user according to their requirements. Some of the common replaced values are explained below:

#### Database:
Using a database as the MLflow backend store provides a scalable, reliable, and query-efficient foundation for experiment tracking and model lifecycle management. By default, MLflow has a built-in local SQLite database to store metadata. However, for production environments it is recommended to use an external database instance which have standard enterprise capabilities such as backups, and high availability. To use an external database, the following value needs to be set:
```bash
mlflow
  backendStoreUri: "postgresql://{USERNAME}:{PASSWORD}@{DB_PUBLIC_IP/DOMAIN}:5432/mlflow"
```
Make sure to replace the correct values for the postgresql variables USERNAME, PASSWORD, DB_PUBLIC_IP/DOMAIN. You can also store the database URI in a Kubernetes Secret to avoid exposing credentials in values files:
```bash
kubectl create secret generic mlflow-db-secret \
  --namespace mlflow \
  --from-literal=uri="postgresql://{USERNAME}:{PASSWORD}@{DB_PUBLIC_IP/DOMAIN}:5432/mlflow"
```
Reference the Secret in your values file:
```bash
mlflow:
  backendStoreUriFrom:
    secretKeyRef:
      name: mlflow-db-secret
      key: uri
```

#### s3 Storage Backend:
Using an object store such as LUMI-O via s3 as the MLflow artifact storage backend provides durable, highly available, and virtually unlimited storage for large model artifacts, datasets, and logs. It centralizes artifact management for all experiments and environments, enabling scalable, cost‑effective retention and easy sharing of artifacts across teams and infrastructure.

The MLflow helm chart values that need to be set for s3 connection with LUMI-O are as follows:
```bash
mlflow:
  defaultArtifactRoot: "mlflow-artifacts:/"
  artifactsDestination: "s3://my-bucket/mlflow"
  env:
    - name: MLFLOW_S3_ENDPOINT_URL
        value: "https://lumidata.eu"
    - name: AWS_DEFAULT_REGION
        value: "lumi-prod"
    - name: AWS_ACCESS_KEY_ID
        value: "abc123"
    - name: AWS_SECRET_ACCESS_KEY
        value: "xxxx"
```

#### Authentication:
MLflow has a build-in HTTP Basic Authentication, however, it needs to be enabled and required a CSRF secret key. Add the following with your own values: 

```bash
authentication:
  enabled: true

  adminPassword: I_am_a_long_password_123
  database_uri: ""

mlflow:
  server:
    value_options:
      app_name: "basic-auth"

  env:
    - name: MLFLOW_FLASK_SERVER_SECRET_KEY
      valueFrom:
        secretKeyRef:
          name: mlflow-auth-secret
          key: secret-key
    - name: MLFLOW_AUTH_CONFIG_PATH
      value: /etc/mlflow/auth/basic_auth.ini

  extraVolumes:
    - name: auth-config
      secret:
        secretName: mlflow-auth-config
  extraVolumeMounts:
    - name: auth-config
      mountPath: /etc/mlflow/auth
      readOnly: true
```

#### Ingress
Ingress object needs to be created to expose the MLflow tracking server to the internet. Add the following value to give your domain name for the ingress by replaceing the `host` field:

```bash
mlflow:
  ingress:
      hosts:
        - host: mlflow-my-namespace.apps.lumi-k.eu
          paths:
            - path: /
              pathType: Prefix

  server:
    value_options:
      allowed_hosts: "mlflow-my-namespace.apps.lumi-k.eu"
      cors_allowed_origins: "http://mlflow-my-namespace.apps.lumi-k.eu"
```

#### Accumulated
Since there are multiple custom values, it is better to use a single values file rahter than setting them inline. This can be easily done using a `values.yml` file as shown below and refering it to `helm install` command using the `-f` option.

```bash
authentication:
  enabled: true
  adminPassword: I_am_a_long_password_123
  database_uri: ""

mlflow:
  server:
    value_options:
      app_name: "basic-auth"  
      allowed_hosts: "mlflow-my-namespace.apps.lumi-k.eu"
      cors_allowed_origins: "http://mlflow-my-namespace.apps.lumi-k.eu"

  env:
    - name: MLFLOW_FLASK_SERVER_SECRET_KEY
      valueFrom:
        secretKeyRef:
          name: mlflow-auth-secret
          key: secret-key
    - name: MLFLOW_AUTH_CONFIG_PATH
      value: /etc/mlflow/auth/basic_auth.ini
    - name: MLFLOW_S3_ENDPOINT_URL
      value: "https://lumidata.eu"
    - name: AWS_DEFAULT_REGION
      value: "lumi-prod"
    - name: AWS_ACCESS_KEY_ID
      value: "abc123"
    - name: AWS_SECRET_ACCESS_KEY
      value: "xxxx"

  extraVolumes:
    - name: auth-config
      secret:
        secretName: mlflow-auth-config
  extraVolumeMounts:
    - name: auth-config
      mountPath: /etc/mlflow/auth
      readOnly: true

  mlflow:
    backendStoreUri: "postgresql://{USERNAME}:{PASSWORD}@{DB_PUBLIC_IP/DOMAIN}:5432/mlflow"
    defaultArtifactRoot: "mlflow-artifacts:/"
    artifactsDestination: "s3://my-bucket/mlflow"

  ingress:
      hosts:
        - host: mlflow-my-namespace.apps.lumi-k.eu
          paths:
            - path: /
              pathType: Prefix

```