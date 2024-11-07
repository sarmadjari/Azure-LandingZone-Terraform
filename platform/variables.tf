# /platform/variables.tf

# Location
variable "location" {
  description = "Azure region where the resources will be deployed"
  type        = string
}

# Subscription IDs
variable "connectivity_subscription_id" {
  description = "Subscription ID for Connectivity VNet"
  type        = string
}

variable "identity_subscription_id" {
  description = "Subscription ID for Identity VNet"
  type        = string
}

variable "management_subscription_id" {
  description = "Subscription ID for Management VNet"
  type        = string
}

# Resource Group Names
variable "connectivity_resource_group_name" {
  description = "Resource Group for Connectivity resources"
  type        = string
}

variable "identity_resource_group_name" {
  description = "Resource Group for Identity resources"
  type        = string
}

variable "management_resource_group_name" {
  description = "Resource Group for Management resources"
  type        = string
}

# Shared Tags
variable "shared_tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
}

# VNets Names
variable "connectivity_vnet_name" {
  description = "Resource Group for Connectivity resources"
  type        = string
}

variable "identity_vnet_name" {
  description = "Resource Group for Identity resources"
  type        = string
}

variable "management_vnet_name" {
  description = "Resource Group for Management resources"
  type        = string
}

# Address Spaces for VNets
variable "connectivity_vnet_address_space" {
  description = "Address space for Connectivity VNet"
  type        = list(string)
}

variable "identity_vnet_address_space" {
  description = "Address space for Identity VNet"
  type        = list(string)
}

variable "management_vnet_address_space" {
  description = "Address space for Management VNet"
  type        = list(string)
}

# Subnets
variable "connectivity_subnets" {
  description = "Subnets for Connectivity VNet"
  type        = list(object({
    name           = string
    address_prefix = string
  }))
}

variable "identity_subnets" {
  description = "Subnets for Identity VNet"
  type        = list(object({
    name           = string
    address_prefix = string
  }))
}

variable "management_subnets" {
  description = "Subnets for Management VNet"
  type        = list(object({
    name           = string
    address_prefix = string
  }))
}

# Firewall-specific Variables
variable "firewall_name" {
  description = "The name of the Azure Firewall"
  type        = string
}

variable "sku_name" {
  description = "Firewall SKU Name"
  type        = string
  default     = "AZFW_VNet"
}

variable "sku_tier" {
  description = "Firewall SKU Tier"
  type        = string
  default     = "Standard"
}

#Fortigate Variables
variable "fortigate_prefix_name" {
  description = "The prefix name for the Fortigate resources"
  type        = string
}

variable "fortigate_vm_size" {
  description = "The instance type for the Fortigate VM"
  type        = string
  default     = "Standard_F4s"
}

variable "fortigate_count" {
  description = "The number of Fortigate appliances to create."
  type        = number
  default     = 2
}

variable "fortigate_admin_username" {
  description = "The admin username for the Fortigate VM"
  type        = string
}

variable "fortigate_admin_password" {
  description = "The admin password for the Fortigate VM"
  type        = string
  sensitive   = true
}



