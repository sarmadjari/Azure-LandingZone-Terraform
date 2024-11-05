# /platform/identity/network/variables.tf

# Define the VNet name
variable "vnet_name" {
  description = "The name of the Virtual Network (VNet)"
  type        = string
}

# Define the location of the resources
variable "location" {
  description = "The Azure region where the resources will be created"
  type        = string
}

# Define the resource group where the VNet will be created
variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

# Define the address space for the VNet
variable "address_space" {
  description = "The address space that will be used for the Virtual Network"
  type        = list(string)
}

# Define subnet details as a list of maps (name and address_prefix)
variable "subnets" {
  description = "A list of subnets to be created within the VNet. Each subnet requires name and address_prefix."
  type = list(object({
    name           = string
    address_prefix = string
  }))
}

# Define optional tags to apply to all resources
variable "tags" {
  description = "Tags to be applied to all resources"
  type        = map(string)
  default     = {}
}
