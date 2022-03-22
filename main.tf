
## create VPC
module "vpc" {
  source       = "./modules/vpc/"
  project_id   = var.project
  network_name = var.vpc_network_name
}

## create subnet
module "network_subnet" {
  source       = "./modules/subnets/"
  depends_on   = [module.vpc]
  project_id   = var.project
  network_name = var.vpc_network_name
  subnets = [{
    subnet_name         = var.subnetwork_name
    network-subnet-cidr = var.network-subnet-cidr
    subnet_region       = var.vpc_region
    }
  ]
}

## create firewall rules
module "firewall-rules" {
  source       = "./modules/firewall-rules/"
  depends_on   = [module.vpc]
  project_id   = var.project
  network_name = var.vpc_network_name

  rules = [{
    name        = "nginx-allow-http"
    description = null
    direction   = "INGRESS"
    priority    = null

    source_service_accounts = null
    target_service_accounts = null
    ranges                  = ["0.0.0.0/0"]
    source_tags             = null
    target_tags             = ["http", "http-server"]

    allow = [{
      protocol = "tcp"
      ports    = ["80"]
    }]
    deny = []
    log_config = {
      metadata = "INCLUDE_ALL_METADATA"
    }
    },
    {
      name        = "nginx-allow-https"
      description = null
      direction   = "INGRESS"
      priority    = null

      source_service_accounts = null
      target_service_accounts = null
      ranges                  = ["0.0.0.0/0"]
      source_tags             = null
      target_tags             = ["http", "http-server"]

      allow = [{
        protocol = "tcp"
        ports    = ["443"]
      }]
      deny = []
      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }
    },
    {
      name        = "nginx-allow-ssh"
      description = null
      direction   = "INGRESS"
      priority    = null

      source_service_accounts = null
      target_service_accounts = null
      ranges                  = ["0.0.0.0/0"]
      source_tags             = null
      target_tags             = ["ssh", "https-server"]

      allow = [{
        protocol = "tcp"
        ports    = ["22"]
      }]
      deny = []
      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }
  }]
}

# ## VM instance
# #module "vm_instance_rhel_public1" {
# #  source        = "./modules/vm-instance/"
# #  depends_on    = [module.network_subnet]
# #  vpc_name      = var.vpc_network_name
# #  subnet_name   = var.subnetwork_name
# #  subnet_zone   = var.region_zone
# #  instance_name = "rhel-instance1"
# #}

# # module "vm_instance_rhel_public2" {
# #   source        = "./modules/vm-instance/"
# #   depends_on    = [module.network_subnet]
# #   vpc_name      = var.vpc_network_name
# #   subnet_name   = var.subnetwork_name
# #   subnet_zone   = var.region_zone
# #   instance_name = "rhel-instance2"
# # }

module "instance_template" {
  source         = "./modules/instance_template"
  depends_on     = [module.network_subnet]
  project_id     = var.project
  name_prefix    = "rhel-template"
  vpc_name       = var.vpc_network_name
  subnet_name    = var.subnetwork_name
  region         = var.vpc_region
  subnet_zone    = var.region_zone
  tags           = ["ssh", "http", "http-server", "https-server"]
  startup_script = file("./modules/instance_template/start.sh")
}

module "mig1" {
  source            = "./modules/mig"
  project_id        = var.project
  region            = var.vpc_region
  target_size       = var.target_size
  hostname          = "nginx1"
  instance_template = module.instance_template.self_link
}

module "mig2" {
  source            = "./modules/mig"
  project_id        = var.project
  region            = var.vpc_region
  target_size       = var.target_size
  hostname          = "nginx2"
  instance_template = module.instance_template.self_link
}

module "gce-lb-http" {
  source = "./modules/lb-http"
  name   = "nginx-http-lb"
  project = var.project
  target_tags = ["nginx_backend"]

  backends = {
    default = {

      description                     = null
      protocol                        = "HTTP"
      port                            = 80
      port_name                       = "http"
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
          balancing_mode               = null
          capacity_scaler              = null
          description                  = null
          max_connections              = null
          max_connections_per_instance = null
          max_connections_per_endpoint = null
          max_rate                     = null
          max_rate_per_instance        = null
          max_rate_per_endpoint        = null
          max_utilization              = null
        },
        {
          group                        = module.mig2.instance_group
          balancing_mode               = null
          capacity_scaler              = null
          description                  = null
          max_connections              = null
          max_connections_per_instance = null
          max_connections_per_endpoint = null
          max_rate                     = null
          max_rate_per_instance        = null
          max_rate_per_endpoint        = null
          max_utilization              = null
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


