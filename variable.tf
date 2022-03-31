variable "gcp_service_list" {
  description = "List of GCP service to be enabled for a project."
  type        = list(any)
}

variable "project" {
  type        = string
  description = "GCP project ID"
}

# variable "credentials_file_path" {
#   type        = string
#   description = "Credentials for access"
# }

variable "vpc_network_name" {
  type        = string
  description = "vpc network name"
}

variable "subnetwork_name" {
  type        = string
  description = "vpc network name"
}

variable "vpc_region" {
  type        = string
  description = "VPC region"
}

variable "region_zone" {
  type        = string
  description = "VPC zone"
}

variable "network-subnet-cidr" {
  type        = string
  description = "The CIDR for the network subnet"
}

variable "network-subnet2-cidr" {
  type        = string
  description = "The CIDR for the network subnet"
}

variable "service_port" {
  type        = number
  description = "TCP port your service is listening on"
}

variable "service_port_name" {
  type        = string
  description = "name of the port the service is listening on"
}

variable "target_size" {
  type        = number
  description = "The target number of running instances for this managed instance group. This value should always be explicitly set unless this resource is attached to an autoscaler, in which case it should never be set."
}

## Firewall variable object
variable "firewall_rules" {
  description = "List of custom rule definitions (refer to variables file for syntax)."
  default     = []
  type = list(object({
    name                    = string
    description             = string
    direction               = string
    priority                = number
    ranges                  = list(string)
    source_tags             = list(string)
    source_service_accounts = list(string)
    target_tags             = list(string)
    target_service_accounts = list(string)
    allow = list(object({
      protocol = string
      ports    = list(string)
    }))
    deny = list(object({
      protocol = string
      ports    = list(string)
    }))
    log_config = object({
      metadata = string
    })
  }))
}

variable "instance_templates" {
  type = object({
    name_prefix           = string
    tags                  = list(string)
    startup_script        = string
    template_machine_type = string
    source_image          = string
    }
  )
}

variable "instance_group" {
  type = object({
    region       = string
    target_size  = number
    max_replicas = optional(number)
    min_replicas = optional(number)
    host_name    = string
    }
  )
}

# backend list 
variable "backend" {
  type = object({
    name        = string
    portname    = string
    protocol    = string
    port        = number
    target_tags = list(string)
    description = string
  })
}

variable "backend_group" {
  description = "Set of Backend that service this BackEndService."
  type = object({
    balancing_mode               = string
    capacity_scaler              = number
    description                  = string
    max_connections              = number
    max_connections_per_instance = number
    max_connections_per_endpoint = number
    max_rate                     = number
    max_rate_per_instance        = number
    max_rate_per_endpoint        = number
    max_utilization              = number
    }
  )
}

## Health check variables
variable "healthcheck_name" {
  type = string
  description = "name of health check"
}

variable "nat_router_name" {
    type = string
    description = "Network NAT gateway name"
}
terraform {
  # Optional attributes and the defaults function are
  # both experimental, so we must opt in to the experiment.
  experiments = [module_variable_optional_attrs]
}
