# /platform/connectivity/azure_api_management/outputs.tf

output "api_management_id" {
  description = "ID of the API Management instance"
  value       = azurerm_api_management.api_management.id
}

output "api_management_hostname" {
  description = "Hostname of the API Management instance"
  value       = azurerm_api_management.api_management.gateway_url
}
