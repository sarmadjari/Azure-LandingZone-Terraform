# /platform/identity/network/outputs.tf

output "vnet_id" {
  description = "The ID of the Identity Virtual Network"
  value       = azurerm_virtual_network.vnet.id
}

output "vnet_name" {
  description = "The name of the Identity Virtual Network"
  value       = azurerm_virtual_network.vnet.name
}

output "subnet_ids" {
  description = "The list of subnet IDs for the Identity VNet"
  value       = { for k, v in azurerm_subnet.subnet : k => v.id }
}

output "subnet_names" {
  description = "The list of subnet names for the Identity VNet"
  value       = { for k, v in azurerm_subnet.subnet : k => v.name }
}


