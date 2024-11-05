# /platform/connectivity/security/main.tf


terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.6.0"
      configuration_aliases = [
        azurerm.connectivity,
        azurerm.identity,
        azurerm.management,
      ]
    }
  }
}

# Public IP for Firewall Management
resource "azurerm_public_ip" "firewall_management_public_ip" {
  provider            = azurerm.connectivity
  name                = "${var.firewall_name}-mgmt-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
  tags = var.tags
}

# Azure Firewall
resource "azurerm_firewall" "internal_firewall" {
  provider            = azurerm.connectivity
  name                = var.firewall_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = var.sku_name
  sku_tier            = var.sku_tier
  zones               = ["1", "2", "3"]

  ip_configuration {
    name      = "internalFirewallConfig"
    subnet_id = var.subnet_ids["AzureFirewallSubnet"]
  }

  management_ip_configuration {
    name                 = "mgmtFirewallConfig"
    subnet_id            = var.subnet_ids["AzureFirewallManagementSubnet"]
    public_ip_address_id = azurerm_public_ip.firewall_management_public_ip.id
  }

  tags = var.tags
}


# Route Table for East-West and Forced Tunneling
# UDR for Connectivity VNet
resource "azurerm_route_table" "connectivity_route_table" {
  provider            = azurerm.connectivity
  name                = "connectivity-udr"
  location            = var.location
  resource_group_name = var.connectivity_resource_group_name
  tags                = merge(var.shared_tags, { project = "connectivity" })

  route {
    name                   = "to-firewall-connectivity"
    address_prefix         = var.connectivity_vnet_address_space[0]
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.internal_firewall.ip_configuration[0].private_ip_address
  }

  route {
    name                   = "to-firewall-identity"
    address_prefix         = var.identity_vnet_address_space[0]
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.internal_firewall.ip_configuration[0].private_ip_address
  }

  route {
    name                   = "to-firewall-management"
    address_prefix         = var.management_vnet_address_space[0]
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.internal_firewall.ip_configuration[0].private_ip_address
  }

  depends_on = [azurerm_firewall.internal_firewall]
}

# UDR for Identity VNet
resource "azurerm_route_table" "identity_route_table" {
  provider            = azurerm.identity
  name                = "identity-udr"
  location            = var.location
  resource_group_name = var.identity_resource_group_name
  tags                = merge(var.shared_tags, { project = "identity" })

  route {
    name                   = "to-firewall-connectivity"
    address_prefix         = var.connectivity_vnet_address_space[0]
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.internal_firewall.ip_configuration[0].private_ip_address
  }

  route {
    name                   = "to-firewall-identity"
    address_prefix         = var.identity_vnet_address_space[0]
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.internal_firewall.ip_configuration[0].private_ip_address
  }

  route {
    name                   = "to-firewall-management"
    address_prefix         = var.management_vnet_address_space[0]
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.internal_firewall.ip_configuration[0].private_ip_address
  }

  depends_on = [azurerm_firewall.internal_firewall]
}

# UDR for Management VNet
resource "azurerm_route_table" "management_route_table" {
  provider            = azurerm.management
  name                = "management-udr"
  location            = var.location
  resource_group_name = var.management_resource_group_name
  tags                = merge(var.shared_tags, { project = "management" })

  route {
    name                   = "to-firewall-connectivity"
    address_prefix         = var.connectivity_vnet_address_space[0]
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.internal_firewall.ip_configuration[0].private_ip_address
  }

  route {
    name                   = "to-firewall-identity"
    address_prefix         = var.identity_vnet_address_space[0]
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.internal_firewall.ip_configuration[0].private_ip_address
  }

  route {
    name                   = "to-firewall-management"
    address_prefix         = var.management_vnet_address_space[0]
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.internal_firewall.ip_configuration[0].private_ip_address
  }

  depends_on = [azurerm_firewall.internal_firewall]
}

# Associate Route Tables to Subnets

# For Connectivity Subnets
resource "azurerm_subnet_route_table_association" "connectivity_subnets" {
  provider       = azurerm.connectivity
  for_each       = { for key, value in var.connectivity_subnet_ids : key => value if !contains(["AzureFirewallSubnet", "AzureFirewallManagementSubnet"], value.name) }
  subnet_id      = each.value.id
  route_table_id = azurerm_route_table.connectivity_route_table.id
}


# For Identity Subnets
resource "azurerm_subnet_route_table_association" "identity_subnets" {
  provider       = azurerm.identity
  for_each       = var.identity_subnet_ids
  subnet_id      = each.value
  route_table_id = azurerm_route_table.identity_route_table.id
}

# For Management Subnets
resource "azurerm_subnet_route_table_association" "management_subnets" {
  provider       = azurerm.management
  for_each       = var.management_subnet_ids
  subnet_id      = each.value
  route_table_id = azurerm_route_table.management_route_table.id
}

