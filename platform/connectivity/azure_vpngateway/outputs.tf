# platform/connectivity/azure_vpngateway/output.tf

output "vpn_gateway_id" {
  description = "ID of the Azure VPN Gateway"
  value       = azurerm_virtual_network_gateway.vpn_gateway.id
}