# Terraform GCP Challenge Root Module

## Pre-Requisites

* A Google Cloud Platform account
* A GCP Project created for terraform to create GCP resources

## Configure your Terraform GCP project to get started

1. Set backend with a pre-existing bucket on Google Cloud Storage (GCS). The bucket must exist prior to configuring the backend.
A backend block cannot refer to named values (like input variables, locals, or data source attributes

    From git root directory:
```
cd scripts

sed -i -e "s|YOUR_TF_PROJ|yourGcpProjectId|g" remote_state_bucket.sh

./remote_state_bucket.sh
```
2. Create service account and credentails.

    From git root directory:
```
cd scripts

sed -i -e "s|YOUR_TF_PROJ|yourGcpProjectId|g" create_tf_sa.sh

./create_tf_sa.sh
```
Supply the key to Terraform using the environment variable GOOGLE_APPLICATION_CREDENTIALS, setting the value to the location of the file.
```
export GOOGLE_APPLICATION_CREDENTIALS={{path}}
```
3. Define your Terraform Variables. region and environment
```
cp terraform.tfvars.example terraform.tfvars.yourtag
```
Edit terraform.tfvars.yourtag with your own variables definitions. 
```
cp terraform.tfvars.yourtag terraform.tfvars
```
4. Set up terraform backend for remote state

```
cp backend_remote.tfvar.example backend_remote.tfvar
```
Edit backend_remote.tfvar with your own backend GCP Storage Bucket. 

5. Initialize with backend
```
terraform init -backend-config=./backend-config/backend_remote.tfvar
```

## Reference links:

[terraform-google-examples](https://github.com/GoogleCloudPlatform/terraform-google-examples)

[hashicorp terraform-provider-google](https://github.com/hashicorp/terraform-provider-google)

