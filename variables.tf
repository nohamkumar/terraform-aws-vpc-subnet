#------------------
### VPC VARIABLES
#------------------

variable "cidr_block" {
  description = "Enter the VPC CIDR block"
}

variable "instance_tenancy" {
  type        = string
  description = "A tenancy option for instances launched into the VPC"
  default     = "default"
  validation {
    condition     = contains(["default", "dedicated", "host"], var.instance_tenancy)
    error_message = "Instance tenancy must be one of \"default\", \"dedicated\", or \"host\"."
  }
}

variable "dns_hostnames_enabled" {
  type        = bool
  description = "A boolean flag to enable/disable DNS hostnames in the VPC"
  default     = true
}

variable "dns_support_enabled" {
  type        = bool
  description = "A boolean flag to enable/disable DNS support in the VPC"
  default     = true
}


#------------------
### SUBNET VARIABLES
#------------------

variable "nat_gateway_enabled" {
  description = "Flag to enable/disable NAT Gateways creation in public subnets"
  default     = "false"
}
