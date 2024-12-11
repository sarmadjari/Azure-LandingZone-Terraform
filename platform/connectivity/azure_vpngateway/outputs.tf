# platform/connectivity/azure_vpngateway/output.tf

output "vpn_gateway_id" {
  description = "ID of the Azure VPN Gateway"
  value       = var.use_existing_gateway ? data.azurerm_virtual_network_gateway.existing_vpn_gateway.id : azurerm_virtual_network_gateway.vpn_gateway.id
}

output "vpn_gateway_name" {
  description = "Name of the VPN Gateway being used (new or existing)"
  value       = var.use_existing_gateway ? data.azurerm_virtual_network_gateway.existing_vpn_gateway.name : azurerm_virtual_network_gateway.vpn_gateway.name
}
