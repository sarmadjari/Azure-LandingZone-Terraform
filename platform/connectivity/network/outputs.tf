# /platform/connectivity/network/outputs.tf

output "vnet_id" {
  description = "The ID of the Connectivity Virtual Network"
  value       = azurerm_virtual_network.vnet.id
}

output "vnet_name" {
  description = "The name of the Connectivity Virtual Network"
  value       = azurerm_virtual_network.vnet.name
}

output "subnet_ids" {
  description = "The list of subnet IDs for the Connectivity VNet"
  value       = { for k, v in azurerm_subnet.subnet : k => v.id }
}

output "subnet_names" {
  description = "The list of subnet names for the Connectivity VNet"
  value       = { for k, v in azurerm_subnet.subnet : k => v.name }
}

output "subnet_ids_by_name" {
  description = "A map of subnet names to their respective IDs for the Connectivity VNet"
  value       = { for k, v in azurerm_subnet.subnet : v.name => v.id }
}


output "firewall_management_subnet_id" {
  description = "The ID of the Azure Firewall Management subnet"
  value       = azurerm_subnet.subnet["AzureFirewallManagementSubnet"].id
}