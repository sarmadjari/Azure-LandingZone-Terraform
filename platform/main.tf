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

  # Pass Subnet IDs as Input Variables
  subnet_ids              = module.connectivity_network.subnet_ids
  connectivity_subnet_ids = module.connectivity_network.subnet_ids
  identity_subnet_ids     = module.identity_network.subnet_ids
  management_subnet_ids   = module.management_network.subnet_ids

  depends_on = [
    module.connectivity_network,
    module.identity_network,
    module.management_network
  ]
}


# FotiGate Module
module "connectivity_fortigate" {
  source              = "./connectivity/fortigate"
  providers           = {
    azurerm.connectivity = azurerm.connectivity
  }
  location            = var.location
  resource_group_name = var.connectivity_resource_group_name
  tags                = merge(var.shared_tags, { project = "connectivity" })

  fortigate_prefix_name          = var.fortigate_prefix_name
  fortigate_vm_size              = var.fortigate_vm_size
  fortigate_admin_username       = var.fortigate_admin_username
  fortigate_admin_password       = var.fortigate_admin_password


  fortigate_external_subnet_id     = module.connectivity_network.subnet_ids_by_name["fortigate-external-subnet"]
  fortigate_internal_subnet_id     = module.connectivity_network.subnet_ids_by_name["fortigate-internal-subnet"]
  connectivity_management_subnet_id = module.connectivity_network.subnet_ids_by_name["connectivity-management-subnet"]

  depends_on = [
    module.connectivity_network,
  ]
}