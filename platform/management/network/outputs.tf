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

output "subnet_ids" {
  description = "The list of subnet IDs for the Management VNet"
  value       = { for k, v in azurerm_subnet.subnet : k => v.id }
}

output "subnet_names" {
  description = "The list of subnet names for the Management VNet"
  value       = { for k, v in azurerm_subnet.subnet : k => v.name }
}

output "subnet_ids_by_name" {
  description = "A map of subnet names to their respective IDs for the Management VNet"
  value       = { for k, v in azurerm_subnet.subnet : v.name => v.id }
}

