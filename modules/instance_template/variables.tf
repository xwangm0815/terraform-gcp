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
  type = string
  description = "vpc name"
}

variable "subnet_name" {
    type = string
    description = "subnet name"
  
}

variable "vpc_zone" {
  type        = string
  description = "vpc zone"
  default     = "us-central1-c"
}

variable "subnet_zone" {
  description = "subnet zone"
  type = string
}

variable "name_prefix" {
  description = "instance name prefix"
  type = string
}

variable "region" {
  description = "The GCP region"
  type        = string
  default     = "us-central1"
}

# variable "service_account" {
#   default = null
#   type = object({
#     email  = string
#     scopes = set(string)
#   })
#   description = "Service account to attach to the instance. See https://www.terraform.io/docs/providers/google/r/compute_instance_template.html#service_account."
# }
