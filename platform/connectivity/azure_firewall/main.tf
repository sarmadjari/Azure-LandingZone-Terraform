# /platform/connectivity/azure_firewall/main.tf

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

# Public IP for Azure Firewall Management
resource "azurerm_public_ip" "azure_firewall_management_public_ip" {
  provider            = azurerm.connectivity
  name                = "${var.azure_firewall_name}-mgmt-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
  tags                = var.tags
}

# Azure Firewall
resource "azurerm_firewall" "azure_firewall" {
  provider            = azurerm.connectivity
  name                = var.azure_firewall_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = var.azure_sku_name
  sku_tier            = var.azure_sku_tier
  zones               = ["1", "2", "3"]

  ip_configuration {
    name      = "azureFirewallConfig"
    subnet_id = var.subnet_ids["AzureFirewallSubnet"]
  }

  management_ip_configuration {
    name                 = "azureMgmtFirewallConfig"
    subnet_id            = var.subnet_ids["AzureFirewallManagementSubnet"]
    public_ip_address_id = azurerm_public_ip.azure_firewall_management_public_ip.id
  }

  tags = var.tags
  depends_on = [ azurerm_public_ip.azure_firewall_management_public_ip ]
}
