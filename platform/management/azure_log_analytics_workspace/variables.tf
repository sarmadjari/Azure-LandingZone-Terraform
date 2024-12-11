variable "workspace_name" {
  description = "The name of the Log Analytics Workspace."
  type        = string
}

variable "location" {
  description = "The Azure region where the Log Analytics Workspace will be deployed."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group for the Log Analytics Workspace."
  type        = string
}

variable "sku" {
  description = "The SKU of the Log Analytics Workspace."
  type        = string
  default     = "PerGB2018"
}

variable "retention_in_days" {
  description = "The retention period for the Log Analytics Workspace in days."
  type        = number
  default     = 30
}

variable "private_endpoint_name" {
  description = "The name of the private endpoint for the Log Analytics Workspace."
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet where the private endpoint will be deployed."
  type        = string
}

variable "private_dns_zone_name" {
  description = "The name of the Private DNS Zone for the private endpoint."
  type        = string
}

variable "private_dns_zone_id" {
  description = "The ID of the Private DNS Zone for the private endpoint."
  type        = string
}

variable "virtual_network_id" {
  description = "The ID of the virtual network for the private endpoint."
  type        = string
}

variable "tags" {
  description = "Tags to apply to the resources."
  type        = map(string)
  default     = {}
}
