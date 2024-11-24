# /platform/management/azure_bastion/variables.tf

variable "bastion_name" {
  description = "Name of the Azure Bastion Host"
  type        = string
}

variable "location" {
  description = "Azure region for the Bastion Host"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group where Bastion Host will be deployed"
  type        = string
}

variable "subnet_id" {
  description = "ID of the AzureBastionSubnet"
  type        = string
}

variable "tags" {
  description = "Tags to associate with the Azure Bastion Host"
  type        = map(string)
}
