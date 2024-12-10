# platform/connectivity/azure_localnetworkgateway/variables.tf

variable "local_gateway_name" {
  description = "The name of the Local Network Gateway."
  type        = string
}

variable "location" {
  description = "The Azure region where the resources will be deployed."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "on_prem_gateway_ip" {
  description = "The public IP address of the on-premises VPN device."
  type        = string
}

variable "on_prem_address_spaces" {
  description = "The CIDR address spaces of the on-premises network."
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to resources."
  type        = map(string)
  default     = {}
}
