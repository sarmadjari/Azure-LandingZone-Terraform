# /platform/connectivity/fortigate/variables.tf

variable "location" {
  description = "Azure region where the resources will be deployed"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "tags" {
  description = "Tags to be applied to all resources"
  type        = map(string)
  default     = {}
}

variable "fortigate_prefix_name" {
  description = "The prefix name for the Fortigate resources"
  type        = string
}

variable "fortigate_count" {
  description = "The number of Fortigate appliances to create."
  type        = number
  default     = 1
}

variable "available_zones" {
  description = "List of availability zones to cycle through for VM deployment."
  type        = list(string)
  default     = ["1", "2", "3"]
}

variable "fortigate_vm_size" {
  description = "The instance type for the Fortigate VM"
  type        = string
  default     = "Standard_F4s"
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

variable "fortigate_external_subnet_id" {
  description = "The ID of the external subnet for the Fortigate NIC"
  type        = string
}

variable "fortigate_internal_subnet_id" {
  description = "The ID of the internal subnet for the Fortigate NIC"
  type        = string
}

variable "fortigate_ha_sync_subnet_id" {
  description = "The ID of the internal subnet for the Fortigate NIC"
  type        = string
}

variable "connectivity_management_subnet_id" {
  description = "The ID of the management subnet for the Fortigate NIC"
  type        = string
}
