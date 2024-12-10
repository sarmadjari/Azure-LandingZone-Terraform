# /platform/connectivity/azure_private_dns_zone/outputs.tf

output "dns_zone_id" {
  description = "The ID of the Private DNS Zone."
  value       = azurerm_private_dns_zone.private_dns_zone.id
}

output "dns_zone_name" {
  description = "The name of the Private DNS Zone."
  value       = azurerm_private_dns_zone.private_dns_zone.name
}
