# platform/connectivity/azure_vpngateway/output.tf

output "vpn_gateway_id" {
  description = "ID of the Azure VPN Gateway"
  value       = var.existing_gateway ? data.azurerm_virtual_network_gateway.existing_vpn_gateway[0].id : azurerm_virtual_network_gateway.vpn_gateway[0].id
}

output "vpn_gateway_name" {
  value = var.existing_gateway ? data.azurerm_virtual_network_gateway.existing_vpn_gateway[0].name : azurerm_virtual_network_gateway.vpn_gateway[0].name
}

