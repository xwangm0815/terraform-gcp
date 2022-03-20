# Allow http
resource "google_compute_firewall" "allow-http" {
  name    = "nginx-fw-allow-http"
  network = var.vpc_network_name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http", "http-server"]
}

# Allow https
resource "google_compute_firewall" "allow-https" {
  name    = "nginx-fw-allow-https"
  network = var.vpc_network_name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["https", "https-server"]
}

# allow ssh
resource "google_compute_firewall" "allow-ssh" {
  name    = "nginx-fw-allow-ssh"
  network = var.vpc_network_name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh", "https-server"]
}