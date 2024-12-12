# /platform/management/azure_log_analytics_workspace/outputs.tf

output "workspace_id" {
  description = "The ID of the Log Analytics workspace."
  value       = azurerm_log_analytics_workspace.log_analytics_workspace.id
}
/*
output "private_endpoint_id" {
  description = "The ID of the private endpoint."
  value       = azurerm_private_endpoint.log_analytics_private_endpoint.id
}
*/