# /platform/identity/network/main.tf

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.12.0"
      configuration_aliases = [azurerm.identity]
    }
  }
}

# Create Resource Group for Identity Network
resource "azurerm_resource_group" "identity_rg" {
  provider = azurerm.identity
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Create the Virtual Network (VNet)
resource "azurerm_virtual_network" "vnet" {
  provider            = azurerm.identity
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  tags                = var.tags
  depends_on          = [azurerm_resource_group.identity_rg]
}

# Create Subnets within the VNet dynamically based on the subnets variable
resource "azurerm_subnet" "subnet" {
  provider            = azurerm.identity
  for_each            = { for subnet in var.subnets : subnet.name => subnet }
  name                = each.value.name
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes    = [each.value.address_prefix]
}
