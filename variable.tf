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
