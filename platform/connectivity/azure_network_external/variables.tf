# /platform/connectivity/azure_network_external/variables.tf

variable "vnet_name" {
  description = "The name of the Virtual Network (VNet)"
  type        = string
}

variable "location" {
  description = "Azure region where the resources will be deployed"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "address_space" {
  description = "The address space that will be used for the Virtual Network"
  type        = list(string)
}

variable "subnets" {
  description = "A list of subnets to be created within the VNet. Each subnet requires name and address_prefix."
  type = list(object({
    name           = string
    address_prefix = string
  }))
}

variable "tags" {
  description = "Tags to be applied to all resources"
  type        = map(string)
  default     = {}
}

variable "ddos_protection_plan_name" {
  description = "Name of the Azure DDoS Protection Plan"
  type        = string
  
}

variable "ddos_protection_plan_enabled" {
  description = "Enable DDoS Protection Plan"
  type        = bool
  default     = false
}