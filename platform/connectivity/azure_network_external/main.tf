# /platform/connectivity/azure_network_external/main.tf

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


# Create Azure DDos Protection Plan
resource "azurerm_network_ddos_protection_plan" "ddos" {
    provider            = azurerm.connectivity
    name                = var.ddos_protection_plan_name
    location            = var.location
    resource_group_name = var.resource_group_name
}

# Create the Virtual Network (VNet)
resource "azurerm_virtual_network" "vnet" {
  provider            = azurerm.connectivity
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  tags                = var.tags

  # Associate the DDoS Protection Plan
  ddos_protection_plan {
    id = azurerm_network_ddos_protection_plan.ddos.id
    enable = var.ddos_protection_plan_enabled
  }

}

# Create Subnets within the VNet dynamically based on the subnets variable
resource "azurerm_subnet" "subnet" {
  provider            = azurerm.connectivity
  for_each            = { for subnet in var.subnets : subnet.name => subnet }
  name                = each.value.name
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes    = [each.value.address_prefix]
}


