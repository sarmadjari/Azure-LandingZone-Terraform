# /platform/connectivity/azure_private_dns_zone/variables.tf

variable "dns_zone_name" {
  description = "The name of the Private DNS Zone."
  type        = string
}

variable "resource_group_name" {
  description = "The resource group where the Private DNS Zone will be created."
  type        = string
}

variable "virtual_network_ids" {
  description = "List of Virtual Network IDs to link with the Private DNS Zone."
  type        = list(string)
  default     = []
}

variable "registration_enabled" {
  description = "Whether to enable automatic registration of VM records in the linked virtual networks."
  type        = bool
  default     = false
}
