
#Practice merge conflict#
# this is codes in local branch
# merge to master
provider "google" {
  credentials = file("terraform-key.json")
  project = " -course-344403"
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
# end local branch code =======
#Enable services in GCP Project.
resource "google_project_service" "gcp_services" {
  count                      = length(var.gcp_service_list)
  project                    = var.project
  service                    = var.gcp_service_list[count.index]
  disable_dependent_services = true
}

## create VPC
module "vpc" {
  source       = "./modules/vpc/"
  depends_on   = [google_project_service.gcp_services]
  project_id   = var.project
  network_name = var.vpc_network_name
}

## create subnet
module "network_subnet" {
  source       = "./modules/subnets/"
  depends_on   = [google_project_service.gcp_services, module.vpc]
  project_id   = var.project
  network_name = var.vpc_network_name
  subnets = [{
    subnet_name           = var.subnetwork_name
    network-subnet-cidr   = var.network-subnet-cidr
    subnet_region         = var.vpc_region
    subnet_private_access = true
    }
  ]
}

## create firewall rules
module "firewall-rules" {
  source       = "./modules/firewall-rules/"
  depends_on   = [module.vpc, google_project_service.gcp_services]
  project_id   = var.project
  network_name = var.vpc_network_name
  rules        = var.firewall_rules
}

module "nat-gateway" {
  source     = "./modules/nat/"
  depends_on = [module.vpc, google_project_service.gcp_services]
  project   = var.project
  network_name = var.vpc_network_name
  nat_router_name = var.nat_router_name
  region          = var.vpc_region
}

module "instance_template" {
  source         = "./modules/instance_template"
  depends_on     = [google_project_service.gcp_services, module.network_subnet]
  project        = var.project
  vpc_name       = var.vpc_network_name
  subnet_name    = var.subnetwork_name
  region         = var.vpc_region
  subnet_zone    = var.region_zone
  startup_script = file(var.instance_templates.startup_script)
  template       = var.instance_templates
}

module "mig1" {
  source            = "./modules/mig"
  depends_on        = [google_project_service.gcp_services]
  project_id        = var.project
  region            = var.instance_group.region
  target_size       = var.instance_group.target_size
  hostname          = "${var.instance_group.host_name}-1"
  instance_template = module.instance_template.self_link
}

module "mig2" {
  source            = "./modules/mig"
  depends_on        = [google_project_service.gcp_services]
  project_id        = var.project
  region            = var.instance_group.region
  target_size       = var.instance_group.target_size
  hostname          = "${var.instance_group.host_name}-2"
  instance_template = module.instance_template.self_link
}

module "gce-lb-http" {
  source           = "./modules/lb-http"
  depends_on       = [google_project_service.gcp_services]
  name             = var.backend.name
  project          = var.project
  target_tags      = var.backend.target_tags
  healthcheck_name = var.healthcheck_name

  backends = {
    default = {

      description                     = var.backend.description
      protocol                        = var.backend.protocol
      port                            = var.backend.port
      port_name                       = var.backend.portname
      timeout_sec                     = 10
      connection_draining_timeout_sec = null
      enable_cdn                      = false
      security_policy                 = null
      session_affinity                = null
      affinity_cookie_ttl_sec         = null
      custom_request_headers          = null
      custom_response_headers         = null

      health_check = {
        check_interval_sec  = null
        timeout_sec         = null
        healthy_threshold   = null
        unhealthy_threshold = null
        request_path        = "/"
        port                = 80
        host                = null
        logging             = null
      }

      log_config = {
        enable      = true
        sample_rate = 1.0
      }

      groups = [
        {
          group                        = module.mig1.instance_group
          balancing_mode               = var.backend_group.balancing_mode
          capacity_scaler              = var.backend_group.capacity_scaler
          description                  = var.backend_group.description
          max_connections              = var.backend_group.max_connections
          max_connections_per_instance = var.backend_group.max_connections_per_instance
          max_connections_per_endpoint = var.backend_group.max_connections_per_endpoint
          max_rate                     = var.backend_group.max_rate
          max_rate_per_instance        = var.backend_group.max_rate_per_instance
          max_rate_per_endpoint        = var.backend_group.max_rate_per_endpoint
          max_utilization              = var.backend_group.max_utilization
        },
        {
          group                        = module.mig2.instance_group
          balancing_mode               = var.backend_group.balancing_mode
          capacity_scaler              = var.backend_group.capacity_scaler
          description                  = var.backend_group.description
          max_connections              = var.backend_group.max_connections
          max_connections_per_instance = var.backend_group.max_connections_per_instance
          max_connections_per_endpoint = var.backend_group.max_connections_per_endpoint
          max_rate                     = var.backend_group.max_rate
          max_rate_per_instance        = var.backend_group.max_rate_per_instance
          max_rate_per_endpoint        = var.backend_group.max_rate_per_endpoint
          max_utilization              = var.backend_group.max_utilization
        },
      ]

      iap_config = {
        enable               = false
        oauth2_client_id     = ""
        oauth2_client_secret = ""
      }
    }
  }
}


