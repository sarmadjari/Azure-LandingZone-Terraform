# /platform/connectivity/security/main.tf


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


# Route Table for East-West and Forced Tunneling
# Create a route table for AzureFirewallManagementSubnet with default route to Internet
resource "azurerm_route_table" "firewall_management_route_table" {
  provider            = azurerm.connectivity
  name                = "firewall-management-udr"
  bgp_route_propagation_enabled = false
  location            = var.location
  resource_group_name = var.connectivity_resource_group_name
  tags                = merge(var.shared_tags, { project = "connectivity" })

  # This route ensures Azure Firewall Management Subnet can communicate with the control plane for essential operations (logging, updates, and threat intelligence).
  route {
    name                   = "default-route"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "Internet"
  }
}

# UDR for Connectivity VNet
resource "azurerm_route_table" "connectivity_route_table" {
  provider            = azurerm.connectivity
  name                = "connectivity-udr"
  location            = var.location
  resource_group_name = var.connectivity_resource_group_name
  tags                = merge(var.shared_tags, { project = "connectivity" })

  route {
    name                   = "to-firewall-then-connectivity"
    address_prefix         = var.connectivity_vnet_address_space[0]
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.azure_firewall_private_ip
  }

  route {
    name                   = "to-firewall-then-identity"
    address_prefix         = var.identity_vnet_address_space[0]
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.azure_firewall_private_ip
  }

  route {
    name                   = "to-firewall-then-management"
    address_prefix         = var.management_vnet_address_space[0]
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.azure_firewall_private_ip
  }
}

# UDR for Identity VNet
resource "azurerm_route_table" "identity_route_table" {
  provider            = azurerm.identity
  name                = "identity-udr"
  location            = var.location
  resource_group_name = var.identity_resource_group_name
  tags                = merge(var.shared_tags, { project = "identity" })

  route {
    name                   = "to-firewall-then-connectivity"
    address_prefix         = var.connectivity_vnet_address_space[0]
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.azure_firewall_private_ip
  }

  route {
    name                   = "to-firewall-then-identity"
    address_prefix         = var.identity_vnet_address_space[0]
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.azure_firewall_private_ip
  }

  route {
    name                   = "to-firewall-then-management"
    address_prefix         = var.management_vnet_address_space[0]
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.azure_firewall_private_ip
  }
}

# UDR for Management VNet
resource "azurerm_route_table" "management_route_table" {
  provider            = azurerm.management
  name                = "management-udr"
  location            = var.location
  resource_group_name = var.management_resource_group_name
  tags                = merge(var.shared_tags, { project = "management" })

  route {
    name                   = "to-firewall-then-connectivity"
    address_prefix         = var.connectivity_vnet_address_space[0]
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.azure_firewall_private_ip
  }

  route {
    name                   = "to-firewall-then-identity"
    address_prefix         = var.identity_vnet_address_space[0]
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.azure_firewall_private_ip
  }

  route {
    name                   = "to-firewall-then-management"
    address_prefix         = var.management_vnet_address_space[0]
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.azure_firewall_private_ip
  }
}

# Associate Route Tables to Subnets

# Associate the firewall management route table with AzureFirewallManagementSubnet
resource "azurerm_subnet_route_table_association" "firewall_management_subnet" {
  provider       = azurerm.connectivity
  subnet_id      = var.connectivity_subnet_ids["AzureFirewallManagementSubnet"]
  route_table_id = azurerm_route_table.firewall_management_route_table.id
}


# For Connectivity Subnets
# Associate Route Tables to Subnets, excluding AzureFirewallManagementSubnet and AzureFirewallSubnet
# resource "azurerm_subnet_route_table_association" "connectivity_subnets" {
#  provider = azurerm.connectivity
#  for_each = {
#    for k, v in var.connectivity_subnet_ids :
#    k => v if k != "AzureFirewallManagementSubnet" && k != "AzureFirewallSubnet"
#  }
#  subnet_id      = each.value
#  route_table_id = azurerm_route_table.connectivity_route_table.id
#}


# For Identity Subnets
resource "azurerm_subnet_route_table_association" "identity_subnets" {
  provider       = azurerm.identity
  for_each       = var.identity_subnet_ids
  subnet_id      = each.value
  route_table_id = azurerm_route_table.identity_route_table.id
}


# For Management Subnets
# Associate Route Tables to Subnets, excluding AzureBastionSubnet
resource "azurerm_subnet_route_table_association" "management_subnets" {
provider       = azurerm.management
  for_each = {
    for k, v in var.management_subnet_ids :
    k => v if k != "AzureBastionSubnet"
  }
  subnet_id      = each.value
  route_table_id = azurerm_route_table.management_route_table.id
}