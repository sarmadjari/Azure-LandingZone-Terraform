# /platform/connectivity/azure_firewall_external/outputs.tf

output "azure_firewall_external_private_ip" {
  description = "Private IP address of the Azure Firewall"
  value       = azurerm_firewall.azure_firewall.ip_configuration[0].private_ip_address
}

output "azure_firewall_external_id" {
  description = "ID of the Azure Firewall"
  value       = azurerm_firewall.azure_firewall.id
}
