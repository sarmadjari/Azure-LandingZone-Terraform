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

variable "firewall_private_ip" {
  description = "Private IP address of the Azure Firewall"
  type        = string
}

variable "firewall_id" {
  description = "ID of the Azure Firewall"
  type        = string
  
}

# Application Gateway Variables
variable "appgw_name" {
  description = "Name of the Application Gateway"
  type        = string
  default     = "appgw-dev"
}

variable "appgw_private_ip_address" {
  description = "Private IP address for the Application Gateway"
  type        = string
  default     = "10.0.2.4"  # Ensure this IP is within the application-gateway-subnet
}

variable "waf_mode" {
  description = "WAF mode: Detection or Prevention"
  type        = string
  default     = "Prevention"
}

variable "waf_rule_set_version" {
  description = "WAF rule set version"
  type        = string
  default     = "3.2"
}

variable "ssl_certificate_path" {
  description = "Path to the PFX file for SSL certificate"
  type        = string
  default     = ""  # Provide the path if HTTPS is required
}

variable "ssl_certificate_password" {
  description = "Password for the PFX SSL certificate"
  type        = string
  default     = ""  # Provide the password if HTTPS is required
}
