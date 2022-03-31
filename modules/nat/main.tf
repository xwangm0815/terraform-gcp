resource "google_compute_router" "nat" {
  project = "${var.project}"
  name    = "${var.nat_router_name}"
  region  = "${var.region}"
  network = "${var.network_name}"
}

resource "google_compute_router_nat" "config" {
  project                            = "${var.project}"  
  name                               = "${var.nat_router_name}-config"
  router                             = "${google_compute_router.nat.name}"
  region                             = "${var.region}"
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}