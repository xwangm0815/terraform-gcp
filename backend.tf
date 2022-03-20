terraform {
  backend "gcs" {
    bucket      = "terraformtest120220316"
    prefix      = "terraform1"
    credentials = "terraform-key.json"
  }
}

data "terraform_remote_state" "rt" {
  backend   = "gcs"
  workspace = terraform.workspace
  config = {
    bucket      = "terraform_rstate_20220317"
    prefix      = "dev"
    credentials = "terraform-key.json"
  }
}
