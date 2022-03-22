### Instance Template
module "startup-script-lib" {
  source = "git::https://github.com/terraform-google-modules/terraform-google-startup-scripts.git?ref=v0.1.0"
}

resource "google_compute_instance_template" "tpl" {
  name_prefix             = "${var.name_prefix}-"
  project                 = var.project_id
  machine_type            = var.linux_instance_type
  tags                    = var.tags
  labels                  = var.labels
  metadata                = var.metadata
  can_ip_forward          = var.can_ip_forward
  metadata_startup_script = var.startup_script
  region                  = var.region
  min_cpu_platform        = var.min_cpu_platform

  disk {
    source_image = var.rhel_8_sku
  }

  network_interface {
    network    = var.vpc_name
    subnetwork = var.subnet_name
    access_config {}
  }
  lifecycle {
    create_before_destroy = "true"
  }
}
