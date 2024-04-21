variable "linux_instance_type" {
  type        = string
  description = "VM instance type for Linux Server"
  default     = "e2-small"
}

variable "vpc_name" {
  type = string
}

variable "subnet_name" {
  type = string
}

variable "subnet_zone" {
  type = string
}

variable "instance_name" {
  type = string
}