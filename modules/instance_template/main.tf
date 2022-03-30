##Instance Template
module "startup-script-lib" {
    source = "git::https://github.com/terraform-google-modules/terraform-google-startup-scripts.git?ref=v0.1.0"
}

resource "google_service_account" "compute" {
  project                 = var.project
  account_id = "computeaccess"
  display_name = "compute access account"
}

resource "google_compute_instance_template" "tpl" {
  name_prefix             = "${var.template.name_prefix}-"
  project                 = var.project
  machine_type            = var.template.template_machine_type
  tags                    = var.template.tags
  labels                  = var.labels
  #metadata                = var.metadata
  can_ip_forward          = var.can_ip_forward
  #metadata_startup_script = var.startup_script
  region                  = var.region
  min_cpu_platform        = var.min_cpu_platform

  disk {
    source_image = var.template.source_image
  }

  metadata = {
    startup-script        = "${module.startup-script-lib.content}"
    startup-script-custom = file("${path.module}/start.sh")
    enable-os-login = "true"
  }

  network_interface {
    subnetwork_project = "${var.project}"
    network    = var.vpc_name
    subnetwork = "${var.subnet_name}"
    access_config {}
  }

  service_account {
    email  = google_service_account.compute.email
    scopes = ["cloud-platform"]
  }

  lifecycle {
    create_before_destroy = "true"
  }
}
