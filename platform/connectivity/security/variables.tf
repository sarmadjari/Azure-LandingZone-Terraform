# /platform/connectivity/security/variables.tf

# Firewall-specific Variables
variable "firewall_name" {
  description = "The name of the Azure Firewall"
  type        = string
}

variable "location" {
  description = "The Azure region for the firewall resources"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group for firewall resources"
  type        = string
}

# Firewall SKU Configuration
variable "sku_name" {
  description = "SKU name for the Azure Firewall"
  type        = string
}

variable "sku_tier" {
  description = "SKU tier for the Azure Firewall"
  type        = string
}

variable "tags" {
  description = "Tags to be applied to all resources"
  type        = map(string)
  default     = {}
}

# VNet Address Spaces for Routing
variable "connectivity_vnet_address_space" {
  description = "Address space for the connectivity VNet"
  type        = list(string)
}

variable "identity_vnet_address_space" {
  description = "Address space for the identity VNet"
  type        = list(string)
}

variable "management_vnet_address_space" {
  description = "Address space for the management VNet"
  type        = list(string)
}

# Subnet IDs for Firewall and Management
variable "subnet_ids" {
  description = "A map of subnet IDs required for firewall configurations"
  type        = map(string)
}

# Resource Group Names
variable "connectivity_resource_group_name" {
  description = "The resource group name for the Connectivity VNet resources"
  type        = string
}

variable "identity_resource_group_name" {
  description = "The resource group name for the Identity VNet resources"
  type        = string
}

variable "management_resource_group_name" {
  description = "The resource group name for the Management VNet resources"
  type        = string
}

# Shared Tags
variable "shared_tags" {
  description = "Tags to apply to all resources for better organization"
  type        = map(string)
}

variable "connectivity_subnet_ids" {
  type        = map(string)
  description = "Map of subnet IDs for the connectivity network"
}

variable "identity_subnet_ids" {
  type        = map(string)
  description = "Map of subnet IDs for the identity network"
}

variable "management_subnet_ids" {
  type        = map(string)
  description = "Map of subnet IDs for the management network"
}

