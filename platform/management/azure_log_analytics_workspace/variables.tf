# /platform/management/azure_log_analytics_workspace/variables.tf

variable "workspace_name" {
  description = "The name of the Log Analytics workspace."
  type        = string
}

variable "location" {
  description = "The location for the resources."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "sku" {
  description = "The SKU of the Log Analytics workspace."
  type        = string
  default     = "PerGB2018"
}

variable "retention_in_days" {
  description = "Retention period in days for the workspace."
  type        = number
  default     = 30
}

variable "tags" {
  description = "Tags to apply to the resources."
  type        = map(string)
  default     = {}
}

variable "private_endpoint_name" {
  description = "The name of the private endpoint."
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet for the private endpoint."
  type        = string
}

variable "virtual_network_id" {
  description = "The ID of the virtual network to link the private DNS zone."
  type        = string
}

variable "private_dns_zone_id" {
  description = "The ID of the private DNS zone to link to the private endpoint."
  type        = string
}
