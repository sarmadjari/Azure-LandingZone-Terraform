# platform/connectivity/azure_vpngateway/main.tf

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.12.0"
      configuration_aliases = [
        azurerm.connectivity
      ]
    }
  }
}

resource "azurerm_public_ip" "vpn_gateway_pip" {
  provider            = azurerm.connectivity
  name                = "${var.vpn_gateway_name}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
}

resource "azurerm_virtual_network_gateway" "vpn_gateway" {
  provider                  = azurerm.connectivity
  name                      = var.vpn_gateway_name
  location                  = var.location
  resource_group_name       = var.resource_group_name
  type                      = "Vpn"
  vpn_type                  = "RouteBased"
  sku                       = var.vpn_gateway_sku
  # active_active             = false
  # enable_bgp                = false

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.vpn_gateway_pip.id
    subnet_id                     = var.gateway_subnet_id
  }

  tags = var.tags
}