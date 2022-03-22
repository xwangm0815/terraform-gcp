variable "linux_instance_type" {
  type        = string
  description = "VM instance type for Linux Server"
  default     = "e2-small"
}

variable "project_id" {
  type        = string
  description = "project id"
}

variable "vpc_name" {
  type        = string
  description = "vpc name"
}

variable "subnet_name" {
  type        = string
  description = "subnet name"
}

variable "subnet_zone" {
  description = "subnet zone"
  type        = string
}

variable "name_prefix" {
  description = "instance name prefix"
  type        = string
}

variable "region" {
  description = "The GCP region"
  type        = string
}

variable "min_cpu_platform" {
  description = "Specifies a minimum CPU platform. Applicable values are the friendly names of CPU platforms, such as Intel Haswell or Intel Skylake. See the complete list: https://cloud.google.com/compute/docs/instances/specify-min-cpu-platform"
  type        = string
  default     = null
}

variable "can_ip_forward" {
  description = "Enable IP forwarding, for NAT instances for example"
  default     = "false"
}

variable "tags" {
  type        = list(string)
  description = "Network tags, provided as a list"
  default     = []
}

variable "labels" {
  type        = map(string)
  description = "Labels, provided as a map"
  default     = {}
}

variable "startup_script" {
  description = "User startup script to run when instances spin up"
  default     = ""
}

variable "metadata" {
  type        = map(string)
  description = "Metadata, provided as a map"
  default     = {}
}
