# /platform/connectivity/azure_application_gateway/outputs.tf

output "appgw_id" {
  description = "ID of the Application Gateway"
  value       = azurerm_application_gateway.app_gateway.id
}

output "appgw_frontend_ip_configuration" {
  description = "Frontend IP configuration of the Application Gateway"
  value       = azurerm_application_gateway.app_gateway.frontend_ip_configuration
}

output "appgw_private_ip" {
  description = "Private IP address of the Application Gateway"
  value       = azurerm_application_gateway.app_gateway.frontend_ip_configuration[0].private_ip_address
}
