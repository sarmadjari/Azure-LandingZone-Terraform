# /platform/connectivity/azure_network_internal/main.tf

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.13.0"
      configuration_aliases = [
        azurerm.connectivity,
        azurerm.identity,
        azurerm.management,
      ]
    }
  }
}


# Create the Virtual Network (VNet)
resource "azurerm_virtual_network" "vnet" {
  provider            = azurerm.connectivity
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  tags                = var.tags
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

# Peer connectivity-internal-vnet with connectivity-external-vnet
resource "azurerm_virtual_network_peering" "connectivity_internal_to_external" {
  provider                  = azurerm.connectivity
  name                      = "connectivity-internal-to-external"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.vnet.name
  remote_virtual_network_id = var.external_vnet_id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  depends_on = [
    azurerm_virtual_network.vnet,
    azurerm_subnet.subnet
  ]
}

# Peer connectivity-external-vnet with connectivity-internal-vnet(reverse direction)
resource "azurerm_virtual_network_peering" "connectivity_external_to_internal" {
  provider                  = azurerm.connectivity
  name                      = "connectivity-external-to-internal"
  resource_group_name       = var.external_vnet_rg_name
  virtual_network_name      = var.external_vnet_name
  remote_virtual_network_id = azurerm_virtual_network.vnet.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

# Peer connectivity-internal-vnet with identity-vnet
resource "azurerm_virtual_network_peering" "connectivity_to_identity" {
  provider                  = azurerm.connectivity
  name                      = "connectivity-to-identity"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.vnet.name
  remote_virtual_network_id = var.identity_vnet_id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  depends_on = [
    azurerm_virtual_network.vnet,
    azurerm_subnet.subnet
  ]
}

# Peer identity-vnet with connectivity-internal-vnet(reverse direction)
resource "azurerm_virtual_network_peering" "identity_to_connectivity" {
  provider                  = azurerm.identity
  name                      = "identity-to-connectivity"
  resource_group_name       = var.identity_vnet_rg_name
  virtual_network_name      = var.identity_vnet_name
  remote_virtual_network_id = azurerm_virtual_network.vnet.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

# Peer connectivity-internal-vnet with management-vnet
resource "azurerm_virtual_network_peering" "connectivity_to_management" {
  provider                  = azurerm.connectivity
  name                      = "connectivity-to-management"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.vnet.name
  remote_virtual_network_id = var.management_vnet_id
  allow_forwarded_traffic   = true
  allow_virtual_network_access = true

  depends_on = [azurerm_virtual_network_peering.management_to_connectivity]
}

# Peer management-vnet with connectivity-internal-vnet(reverse direction)
resource "azurerm_virtual_network_peering" "management_to_connectivity" {
  provider                  = azurerm.management
  name                      = "management-to-connectivity"
  resource_group_name       = var.management_vnet_rg_name
  virtual_network_name      = var.management_vnet_name
  remote_virtual_network_id = azurerm_virtual_network.vnet.id
  allow_forwarded_traffic   = true
  allow_virtual_network_access = true
}