# /platform/connectivity/azure_private_dns_zone/main.tf

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.13.0"
      configuration_aliases = [
        azurerm.connectivity
      ]
    }
  }
}


resource "azurerm_private_dns_zone" "private_dns_zone" {
  provider            = azurerm.connectivity
  name                = var.dns_zone_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zone_link" {
  provider               = azurerm.connectivity
  count                  = length(var.virtual_network_ids)
  name                   = "${var.dns_zone_name}-link-${count.index}"
  resource_group_name    = var.resource_group_name
  private_dns_zone_name  = azurerm_private_dns_zone.private_dns_zone.name
  virtual_network_id     = var.virtual_network_ids[count.index]
  registration_enabled   = var.registration_enabled
  depends_on = [
    azurerm_private_dns_zone.private_dns_zone
  ]
}

