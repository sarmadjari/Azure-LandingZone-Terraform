# /platform/management/azure_bastion/outputs.tf

output "bastion_host_id" {
  description = "ID of the Azure Bastion Host"
  value       = azurerm_bastion_host.bastion.id
}

output "bastion_public_ip" {
  description = "Public IP of the Azure Bastion Host"
  value       = azurerm_public_ip.bastion_pip.ip_address
}
