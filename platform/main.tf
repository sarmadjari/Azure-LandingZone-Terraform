# /platform/main.tf

# Connectivity Network
module "connectivity_network" {
  source              = "./connectivity/network"
  providers = {
    azurerm.connectivity = azurerm.connectivity
    azurerm.identity     = azurerm.identity
    azurerm.management   = azurerm.management
  }
  vnet_name           = var.connectivity_vnet_name
  location            = var.location
  resource_group_name = var.connectivity_resource_group_name
  address_space       = var.connectivity_vnet_address_space
  subnets             = var.connectivity_subnets
  tags                = merge(var.shared_tags, { project = "connectivity" })

  # Use outputs from management and identity modules
  management_vnet_name    = module.management_network.vnet_name
  management_vnet_id      = module.management_network.vnet_id
  management_vnet_rg_name = var.management_resource_group_name

  identity_vnet_name      = module.identity_network.vnet_name
  identity_vnet_id        = module.identity_network.vnet_id
  identity_vnet_rg_name   = var.identity_resource_group_name
}

# Identity Network Module
module "identity_network" {
  source              = "./identity/network"
  providers = {
    azurerm.identity = azurerm.identity
  }
  vnet_name           = var.identity_vnet_name
  location            = var.location
  resource_group_name = var.identity_resource_group_name
  address_space       = var.identity_vnet_address_space
  subnets             = var.identity_subnets
  tags                = merge(var.shared_tags, { project = "identity" })
}

# Management Network Module
module "management_network" {
  source              = "./management/network"
  providers = {
    azurerm.management = azurerm.management
  }
  vnet_name           = var.management_vnet_name
  location            = var.location
  resource_group_name = var.management_resource_group_name
  address_space       = var.management_vnet_address_space
  subnets             = var.management_subnets
  tags                = merge(var.shared_tags, { project = "management" })
}

# Connectivity Security Module
module "connectivity_security" {
  source              = "./connectivity/security"
  providers           = {
    azurerm.connectivity = azurerm.connectivity
    azurerm.identity     = azurerm.identity
    azurerm.management   = azurerm.management
  }
  firewall_name       = var.firewall_name
  sku_name            = var.sku_name
  sku_tier            = var.sku_tier
  location            = var.location
  resource_group_name = var.connectivity_resource_group_name
  tags                = merge(var.shared_tags, { project = "connectivity" })

  # Network Address Spaces
  connectivity_resource_group_name  = var.connectivity_resource_group_name
  connectivity_vnet_address_space   = var.connectivity_vnet_address_space

  identity_resource_group_name      = var.identity_resource_group_name
  identity_vnet_address_space       = var.identity_vnet_address_space

  management_resource_group_name    = var.management_resource_group_name
  management_vnet_address_space     = var.management_vnet_address_space
  shared_tags                       = var.shared_tags

  # Subnet IDs
  subnet_ids          = module.connectivity_network.subnet_ids

  depends_on = [module.connectivity_network]
}