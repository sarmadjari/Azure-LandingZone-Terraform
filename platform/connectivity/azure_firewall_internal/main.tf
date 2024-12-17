# /platform/connectivity/azure_firewall_internal/main.tf

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

/*
# Public IP for Azure Firewall
resource "azurerm_public_ip" "azure_firewall_public_ip" {
  provider            = azurerm.connectivity
  name                = "${var.azure_firewall_name}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
  tags                = merge(var.shared_tags, { project = "connectivity" })
}
*/

# Public IP for Azure Firewall Management
resource "azurerm_public_ip" "azure_firewall_management_public_ip" {
  provider            = azurerm.connectivity
  name                = "${var.azure_firewall_name}-mgmt-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
  tags                = merge(var.shared_tags, { project = "connectivity" })
}

# Azure Firewall Policy
resource "azurerm_firewall_policy" "policy" {
  provider            = azurerm.connectivity
  name                = "${var.azure_firewall_name}-policy"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Premium"
  tags                = merge(var.shared_tags, { project = "connectivity" })
}

# Create a route table for AzureFirewallManagementSubnet with default route to Internet
resource "azurerm_route_table" "firewall_management_route_table" {
  provider            = azurerm.connectivity
  name                = "${var.azure_firewall_name}-mgmt-udr"
  bgp_route_propagation_enabled = false
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = merge(var.shared_tags, { project = "connectivity" })

  # This route ensures Azure Firewall Management Subnet can communicate with the control plane for essential operations (logging, updates, and threat intelligence).
  route {
    name                   = "default-managemnet-route"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "Internet"
  }
}


# Associate the firewall management route table with AzureFirewallManagementSubnet
resource "azurerm_subnet_route_table_association" "firewall_management_subnet" {
  provider       = azurerm.connectivity
  subnet_id      = var.connectivity_internal_subnet_ids["AzureFirewallManagementSubnet"]
  route_table_id = azurerm_route_table.firewall_management_route_table.id
  depends_on = [ azurerm_route_table.firewall_management_route_table ]
}

# Azure Firewall
resource "azurerm_firewall" "azure_firewall" {
  provider            = azurerm.connectivity
  name                = var.azure_firewall_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = var.azure_sku_name
  sku_tier            = var.azure_sku_tier
  firewall_policy_id  = azurerm_firewall_policy.policy.id
  zones               = ["1", "2", "3"]

  ip_configuration {
    name      = "azureFirewallConfig"
    subnet_id = var.connectivity_internal_subnet_ids["AzureFirewallSubnet"]
    # public_ip_address_id = azurerm_public_ip.azure_firewall_public_ip.id
  }

  management_ip_configuration {
    name                 = "azureMgmtFirewallConfig"
    subnet_id            = var.connectivity_internal_subnet_ids["AzureFirewallManagementSubnet"]
    public_ip_address_id = azurerm_public_ip.azure_firewall_management_public_ip.id
  }

  tags                   = merge(var.shared_tags, { project = "connectivity" })
  depends_on = [
    azurerm_public_ip.azure_firewall_management_public_ip,
    #azurerm_public_ip.azure_firewall_public_ip,
    azurerm_firewall_policy.policy,
    azurerm_route_table.firewall_management_route_table,
    azurerm_subnet_route_table_association.firewall_management_subnet
  ]
}
