# platform/connectivity/azure_vpngateway/variables.tf

variable "vpn_gateway_name" {
  description = "Name of the VPN Gateway"
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

variable "gateway_subnet_id" {
  description = "ID of the GatewaySubnet"
  type        = string
}

variable "vpn_gateway_sku" {
  description = "SKU of the VPN Gateway"
  type        = string
  default     = "VpnGw1"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "existing_gateway" {
  default     = false
  type        = bool
  description = "Set to true if the Virtual Network Gateway already exists"
}
