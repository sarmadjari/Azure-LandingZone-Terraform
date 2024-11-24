# /platform/connectivity/azure_api_management/variables.tf

variable "api_management_name" {
  description = "Name of the Azure API Management instance"
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

variable "sku_name" {
  description = "SKU of the API Management instance. Must be 'Premium' for zone redundancy"
  type        = string
}


variable "subnet_id" {
  description = "ID of the subnet for Azure API Management"
  type        = string
}

variable "publisher_name" {
  description = "Name of the publisher for the Azure API Management instance"
  type        = string
}

variable "publisher_email" {
  description = "Email of the publisher for the Azure API Management instance"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
