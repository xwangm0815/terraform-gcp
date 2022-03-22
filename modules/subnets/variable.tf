
variable "project_id" {
  description = "The ID of the project where subnets will be created"
}

variable "network_name" {
  type        = string
  description = "vpc network name"
}

variable "subnets" {
  type        = list(map(string))
  description = "The list of subnets being created"
}

variable "secondary_ranges" {
  type        = map(list(object({ range_name = string, ip_cidr_range = string })))
  description = "Secondary ranges that will be used in some of the subnets"
  default     = {}
}
