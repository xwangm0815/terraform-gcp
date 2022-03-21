Configure the Project ID of your GCP project to get started

    yourGcpProjectId = Project ID of your GCP project for Terraform to create resouces

1. Set backend with a pre-existing bucket on Google Cloud Storage (GCS). The bucket must exist prior to configuring the backend.
A backend block cannot refer to named values (like input variables, locals, or data source attributes

    From git root directory:
```
cd scripts

sed -i -e "s|YOUR_TF_PROJ|yourGcpProjectId|g" remote_state_bucket.sh

./remote_state_bucket.sh
```
2. Create service account and credentails. The root directory would contain your service Account Key file.

    From git root directory:
```
cd scripts

sed -i -e "s|YOUR_TF_PROJ|yourGcpProjectId|g" create_tf_sa.sh

./create_tf_sa.sh
```
3. set up prjoct in git root variable.tf
```
sed -i -e "s|YOUR_TF_PROJ|yourGcpProjectId|g" variable.tf
```
Reference links:

[terraform-google-examples](https://github.com/GoogleCloudPlatform/terraform-google-examples)

[hashicorp terraform-provider-google](https://github.com/hashicorp/terraform-provider-google)

