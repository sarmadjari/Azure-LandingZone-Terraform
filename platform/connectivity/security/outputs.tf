# /platform/connectivity/security/outputs.tf

# Output the Firewall ID

output "internal_firewall_id" {
  description = "The ID of the internal Azure Firewall"
  value       = azurerm_firewall.internal_firewall.id
}

