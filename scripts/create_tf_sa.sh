#!/bin/sh

export TF_CREDS=../terraform-key.json
export TF_PROJ=YOUR_TF_PROJ
export TF_SA_NAME=terraform-sa

sa_rnd=`echo $RANDOM`
sa_name=${TF_SA_NAME}-${sa_rnd}

sa_name=${TF_SA_NAME}-${sa_rnd}
tf_service_account=`gcloud iam service-accounts create ${sa_name} --display-name "Terraform admin account"`
echo "tf_servce_account" ${tf_service_account}

gcloud iam service-accounts keys create ${TF_CREDS} \
  --iam-account ${sa_name}@${TF_PROJ}.iam.gserviceaccount.com

gcloud projects add-iam-policy-binding ${TF_PROJ} \
    --member serviceAccount:${sa_name}@${TF_PROJ}.iam.gserviceaccount.com \
    --role roles/editor

echo serviceAccount:${sa_name}@${TF_PROJ}.iam.gserviceaccount.com > tf_servce_account.out



