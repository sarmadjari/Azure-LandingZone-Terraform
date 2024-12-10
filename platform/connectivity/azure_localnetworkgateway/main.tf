# platform/connectivity/azure_localnetworkgateway/main.tf

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

resource "azurerm_local_network_gateway" "local_gateway" {
  provider            = azurerm.connectivity
  name                = var.local_gateway_name
  location            = var.location
  resource_group_name = var.resource_group_name

  gateway_address = var.on_prem_gateway_ip

  address_space = var.on_prem_address_spaces

  tags = var.tags
}
