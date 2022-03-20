### Instance Template
module "startup-script-lib" {
  source = "git::https://github.com/terraform-google-modules/terraform-google-startup-scripts.git?ref=v0.1.0"
}

resource "google_compute_instance_template" "tpl" {
  name_prefix  = "${var.name_prefix}-"
  project      = var.project_id
  machine_type = var.linux_instance_type
  region       = var.region
  tags = ["ssh", "http", "http-server", "https-server"]

  #metadata_startup_script = templatefile("${path.module}/startup.sh", {})
  disk {
    source_image = var.rhel_8_sku
  }
  metadata = {
    startup-script        = "${module.startup-script-lib.content}"
    startup-script-custom = file("${path.module}/start.sh")
  }

  network_interface {
    network    = var.vpc_name
    subnetwork = var.subnet_name
    access_config {}
  }
}
