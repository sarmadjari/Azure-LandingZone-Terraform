# /platform/connectivity/azure_private_dns_zone/variables.tf

variable "registration_enabled" {
  description = "Whether to enable automatic registration of VM records in the linked virtual networks."
  type        = bool
  default     = false
}

variable "dns_zone_name" {
  description = "The name of the Private DNS Zone."
  type        = string
  validation {
    condition     = length(var.dns_zone_name) > 0
    error_message = "The DNS zone name must not be empty."
  }
}

variable "resource_group_name" {
  description = "The resource group where the Private DNS Zone will be created."
  type        = string
  validation {
    condition     = length(var.resource_group_name) > 0
    error_message = "The resource group name must not be empty."
  }
}

variable "virtual_network_ids" {
  description = "List of Virtual Network IDs to link with the Private DNS Zone."
  type        = list(string)
  default     = []
  validation {
    condition     = length(var.virtual_network_ids) > 0
    error_message = "At least one virtual network ID must be provided."
  }
}

variable "private_dns_zone_name" {
  description = "The name of the Private DNS Zone used for private endpoints."
  type        = string
}