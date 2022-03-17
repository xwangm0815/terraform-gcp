provider "google" {
  credentials = file("terraform-key.json")

  project = "terraform-course-344403"
  region  = "us-central1"
  zone    = "us-central1-c"
}

resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}

terraform {
  backend "gcs" {
    bucket      = "terraformtest120220316"
    prefix      = "terraform1"
    credentials = "terraform-key.json"
  }
}