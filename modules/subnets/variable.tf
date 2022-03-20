
variable "vpc_network_name" {
  type        = string
  description = "vpc network name"
  default     = "terraform-network"
}

variable "subnet_name" {
  type        = string
  description = "sub network name"
}
variable "region" {
  default = "us-central1"
}

# define vpc region
variable "vpc_region" {
  type        = string
  description = "VPC region"
  default     = "us-central1"
}

# define vpc zone
variable "vpc_zone" {
  type        = string
  description = "VPC zone"
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
