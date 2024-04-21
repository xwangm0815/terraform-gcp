variable "project" {
  type        = string
  description = "The GCP project ID"
}

variable "network_name" {
  type        = string
  description = "vpc network name"
}

variable "nat_router_name" {
  type        = string
  description = "NAT router name"
  default     = ""
}

variable "region" {
  description = "The GCP region where the  resides."
}
