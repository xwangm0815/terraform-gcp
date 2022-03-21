#!/bin/sh

export TF_PROJ=terraform-course-344403
export TF_BE_RS=terraform-be-rstate

GCS_CLASS="multi_regional"
GCS_LOCATION="us"

rs_name=${TF_PROJ}-${TF_BE_RS}

function bucket_exist() {
  if gsutil ls gs://${1} &>/dev/null; then
    true
  else
    false
  fi
}

if ! bucket_exist "${rs_name}"; then
    echo "  > Creating Google Cloud Storage bucket ${rs_name} ..."
    (
      set -x
      gsutil mb -p ${TF_PROJ} -c ${GCS_CLASS} -l ${GCS_LOCATION} gs://${rs_name}
      #gsutil versioning set on gs://${rs_name}
    )
  else
    echo "  > GCS bucket ${rs_name} already created"
fi

cat > tf_backend_gcs.out  << EOF
    bucket  = "${rs_name}"
EOF

sed -i -e "s|\$gcsbucket|${rs_name}|g" ../backend.tf
cat tf_backend_gcs.out
