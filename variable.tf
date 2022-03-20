variable "project" {
  default = "terraform-course-344403"
}

variable "vpc_network_name" {
  type        = string
  description = "vpc network name"
  default     = "terraform-network"
}

variable "subnetwork_name" {
  type        = string
  description = "vpc network name"
  default     = "terraform-subnet"
}

variable "region" {
  default = "us-central1"
}

# define VPC region
variable "vpc_region" {
  type        = string
  description = "VPC region"
  default     = "us-central1"
}

# define VPC zone
variable "vpc_zone" {
  type        = string
  description = "vpc zone"
  default     = "us-central1-c"
}

variable "zone" {
  default = "us-central1-c"
}

variable "cidr_ip" {
  type        = string
  description = "The CIDR for the network subnet"
  default     = "10.0.0.0/16"
}

variable "network-subnet-cidr" {
  type        = string
  description = "The CIDR for the network subnet"
  default     = "10.0.0.0/16"
}

variable "service_port" {
  type        = number
  description = "TCP port your service is listening on"
  default     = 80
}

variable "service_port_name" {
  type        = string
  description = "name of the port the service is listening on"
  default     = "http"
}

variable "target_size" {
  type        = number
  description = "The target number of running instances for this managed instance group. This value should always be explicitly set unless this resource is attached to an autoscaler, in which case it should never be set."
  default     = 1
}
