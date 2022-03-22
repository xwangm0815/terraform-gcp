
locals {
  address = var.create_address ? join("", google_compute_global_address.default.*.address) : var.address
}

resource "google_compute_global_address" "default" {
  count      = var.create_address ? 1 : 0
  project    = var.project
  name       = "${var.name}-address"
  ip_version = "IPV4"
}

### IPv4 block ###
resource "google_compute_global_forwarding_rule" "http" {
  project    = var.project
  name       = "${var.name}-http-80"
  target     = google_compute_target_http_proxy.default.self_link
  ip_address = local.address
  port_range = "80"
}

# Target HTTP proxy when http forwarding is true
# The target HTTP proxy uses an URL map to send the traffic to the approriate backend
resource "google_compute_target_http_proxy" "default" {
  project = var.project
  name    = "${var.name}-http-proxy"
  url_map = google_compute_url_map.default.self_link
}

resource "google_compute_url_map" "default" {
  project         = var.project
  name            = "${var.name}-url-map"
  default_service = google_compute_backend_service.default[keys(var.backends)[0]].self_link
}

resource "google_compute_backend_service" "default" {
  for_each         = var.backends
  project          = var.project
  name             = "${var.name}-backend"
  port_name        = "http-port-80"
  protocol         = "HTTP"
  health_checks    = [google_compute_health_check.default.id]
  timeout_sec      = 10
  description      = "http backend service"
  session_affinity = "NONE"

  dynamic "backend" {
    for_each = toset(each.value["groups"])
    content {
      description = lookup(backend.value, "description", null)
      group       = lookup(backend.value, "group")

      balancing_mode               = lookup(backend.value, "balancing_mode")
      capacity_scaler              = lookup(backend.value, "capacity_scaler")
      max_connections              = lookup(backend.value, "max_connections")
      max_connections_per_instance = lookup(backend.value, "max_connections_per_instance")
      max_connections_per_endpoint = lookup(backend.value, "max_connections_per_endpoint")
      max_rate                     = lookup(backend.value, "max_rate")
      max_rate_per_instance        = lookup(backend.value, "max_rate_per_instance")
      max_rate_per_endpoint        = lookup(backend.value, "max_rate_per_endpoint")
      max_utilization              = lookup(backend.value, "max_utilization")
    }
  }

  depends_on = [
    google_compute_health_check.default
  ]

  lifecycle {
    ignore_changes = [backend]
  }
}

resource "google_compute_health_check" "default" {
  name = "health-check"

  http_health_check {
    port = 80
  }
}

