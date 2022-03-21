terraform {
  backend "gcs" {
    bucket  = "$gcsbucket"
    prefix  = "terraform/state"
    credentials = "terraform-key.json"
  }
}

data "terraform_remote_state" "rt" {
  backend   = "gcs"
  workspace = terraform.workspace
  config = {
    bucket      = "$gcsbucket"
    prefix      = "terraform/statedev"
    credentials = "terraform-key.json"
  }
}
