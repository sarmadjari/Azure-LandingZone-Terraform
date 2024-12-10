# platform/connectivity/azure_localnetworkgateway/outputs.tf

output "local_network_gateway_id" {
  description = "The ID of the Azure Local Network Gateway."
  value       = azurerm_local_network_gateway.local_gateway.id
}
