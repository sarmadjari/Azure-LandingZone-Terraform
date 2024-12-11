# /platform/connectivity/azure_private_dns_zone/outputs.tf

output "dns_zone_id" {
  description = "The ID of the Private DNS Zone."
  value       = azurerm_private_dns_zone.private_dns_zone.id
}

output "dns_zone_name" {
  description = "The name of the Private DNS Zone."
  value       = azurerm_private_dns_zone.private_dns_zone.name
}

output "linked_virtual_networks" {
  description = "The list of Virtual Networks linked to the Private DNS Zone."
  value       = [for link in azurerm_private_dns_zone_virtual_network_link.private_dns_zone_link : link.virtual_network_id]
}
