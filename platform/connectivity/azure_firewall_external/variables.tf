# /platform/connectivity/azure_firewall/variables.tf

variable "azure_firewall_name" {
  description = "Name of the Azure Firewall"
  type        = string
}

variable "location" {
  description = "Azure Region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group Name"
  type        = string
}

variable "azure_sku_name" {
  description = "SKU name for the Azure Firewall"
  type        = string
}

variable "azure_sku_tier" {
  description = "SKU tier for the Azure Firewall"
  type        = string
}

variable "connectivity_external_subnet_ids" {
  description = "Map of subnet names to IDs in the Connectivity VNet"
  type        = map(string)
}

variable "shared_tags" {
  description = "Shared tags for all resources"
  type        = map(string)
}
