# /platform/connectivity/security/variables.tf

variable "location" {
  description = "Azure Region"
  type        = string
}

variable "connectivity_resource_group_name" {
  description = "Resource Group Name for Connectivity resources"
  type        = string
}

variable "connectivity_vnet_address_space" {
  description = "Address space for the Connectivity VNet"
  type        = list(string)
}

variable "identity_resource_group_name" {
  description = "Resource Group Name for Identity resources"
  type        = string
}

variable "identity_vnet_address_space" {
  description = "Address space for the Identity VNet"
  type        = list(string)
}

variable "management_resource_group_name" {
  description = "Resource Group Name for Management resources"
  type        = string
}

variable "management_vnet_address_space" {
  description = "Address space for the Management VNet"
  type        = list(string)
}

variable "shared_tags" {
  description = "Shared tags for all resources"
  type        = map(string)
}

variable "connectivity_subnet_ids" {
  description = "Map of subnet names to IDs in the Connectivity VNet"
  type        = map(string)
}

variable "identity_subnet_ids" {
  description = "Map of subnet names to IDs in the Identity VNet"
  type        = map(string)
}

variable "management_subnet_ids" {
  description = "Map of subnet names to IDs in the Management VNet"
  type        = map(string)
}

variable "azure_firewall_private_ip" {
  description = "Private IP address of the Azure Firewall"
  type        = string
}

