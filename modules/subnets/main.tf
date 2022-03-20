# create public subnet
resource "google_compute_subnetwork" "network_subnet" {
  name          = var.subnet_name
  ip_cidr_range = var.network-subnet-cidr
  network       = var.vpc_network_name
  region        = var.vpc_region
}