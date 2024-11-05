# /platform/management/network/outputs.tf

# Output the VNet ID
output "vnet_id" {
  description = "The ID of the Management Virtual Network"
  value       = azurerm_virtual_network.vnet.id
}

output "vnet_name" {
  description = "The name of the Management Virtual Network"
  value       = azurerm_virtual_network.vnet.name
}

# Output the Subnet IDs
output "subnet_ids" {
  description = "The list of subnet IDs"
  value       = { for k, v in azurerm_subnet.subnet : k => v.id }
}

# Output the Subnet Names
output "subnet_names" {
  description = "The list of subnet names"
  value       = { for k, v in azurerm_subnet.subnet : k => v.name }
}

