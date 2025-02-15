# /platform/connectivity/azure_application_gateway/virables.tf

variable "appgw_name" {
  description = "Name of the Application Gateway"
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

variable "subnet_id" {
  description = "ID of the subnet where Application Gateway will be deployed"
  type        = string
}

variable "private_ip_address" {
  description = "Static private IP address for the Application Gateway"
  type        = string
}

variable "appgw_sku_name" {
  description = "SKU name for the Application Gateway"
  type        = string
  default     = "WAF_v2"
}

variable "appgw_sku_tier" {
  description = "SKU tier for the Application Gateway"
  type        = string
  default     = "WAF_v2"
}

variable "appgw_capacity" {
  description = "Capacity units for the Application Gateway"
  type        = number
  default     = 2
}

variable "frontend_port_http" {
  description = "Frontend HTTP port for the Application Gateway"
  type        = number
  default     = 80
}

variable "backend_port" {
  description = "Backend port for the Application Gateway"
  type        = number
  default     = 80
}

variable "backend_protocol" {
  description = "Backend protocol for the Application Gateway"
  type        = string
  default     = "Http"
}

variable "waf_mode" {
  description = "WAF mode: Detection or Prevention"
  type        = string
  default     = "Prevention"
}

variable "waf_rule_set_type" {
  description = "WAF rule set type"
  type        = string
  default     = "Microsoft_DefaultRuleSet"  # Use DRS instead of OWASP
}

variable "waf_rule_set_version" {
  description = "WAF rule set version"
  type        = string
  default     = "2.1"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "zones" {
  description = "Availability Zones for the Application Gateway"
  type        = list(string)
  default     = ["1", "2", "3"]
}

variable "firewall_external_private_ip" {
  description = "Private IP address of the External Azure Firewall"
  type        = string
  
}

variable "firewall_internal_private_ip" {
  description = "Private IP address of the Internal Azure Firewall"
  type        = string
}