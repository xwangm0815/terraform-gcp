module "startup-script-lib" {
  source = "git::https://github.com/terraform-google-modules/terraform-google-startup-scripts.git?ref=v0.1.0"
}

 resource "google_compute_instance" "vm_instance_rhel_public" {
  
  name         = var.instance_name
  machine_type = var.linux_instance_type
  zone         = var.subnet_zone
  tags         = var.tags

  metadata_startup_script =file("${path.module}/start.sh")
  
  boot_disk {
    initialize_params {
      image = var.rhel_8_sku
    }
  }

  metadata = {
    startup-script        = "${module.startup-script-lib.content}"
    startup-script-custom = file("${path.module}/start.sh")
  }

  network_interface {
    network = var.vpc_name
    subnetwork    = var.subnet_name
    access_config { }
  }
} 
