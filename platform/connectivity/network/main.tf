# /platform/connectivity/network/main.tf

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.12.0"
      configuration_aliases = [
        azurerm.connectivity,
        azurerm.identity,
        azurerm.management,
      ]
    }
  }
}


# Create Resource Group for Connectivity Network
resource "azurerm_resource_group" "connectivity_rg" {
  provider = azurerm.connectivity
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}


# Create the Virtual Network (VNet)
resource "azurerm_virtual_network" "vnet" {
  provider            = azurerm.connectivity
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  tags                = var.tags
  depends_on          = [azurerm_resource_group.connectivity_rg]
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

# Peer connectivity-vnet with identity-vnet
resource "azurerm_virtual_network_peering" "connectivity_to_identity" {
  provider                  = azurerm.connectivity
  name                      = "connectivity-to-identity"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.vnet.name
  remote_virtual_network_id = var.identity_vnet_id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
}

# Peer identity-vnet with connectivity-vnet (reverse direction)
resource "azurerm_virtual_network_peering" "identity_to_connectivity" {
  provider                  = azurerm.identity
  name                      = "identity-to-connectivity"
  resource_group_name       = var.identity_vnet_rg_name
  virtual_network_name      = var.identity_vnet_name
  remote_virtual_network_id = azurerm_virtual_network.vnet.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
}

# Peer connectivity-vnet with management-vnet
resource "azurerm_virtual_network_peering" "connectivity_to_management" {
  provider                  = azurerm.connectivity
  name                      = "connectivity-to-management"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.vnet.name
  remote_virtual_network_id = var.management_vnet_id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
}

# Peer management-vnet with connectivity-vnet (reverse direction)
resource "azurerm_virtual_network_peering" "management_to_connectivity" {
  provider                  = azurerm.management
  name                      = "management-to-connectivity"
  resource_group_name       = var.management_vnet_rg_name
  virtual_network_name      = var.management_vnet_name
  remote_virtual_network_id = azurerm_virtual_network.vnet.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
}
