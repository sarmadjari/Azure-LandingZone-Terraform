# /platform/main.tf

# Connectivity Network Module
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

# Connectivity Azure Firewall Module
module "connectivity_azure_firewall" {
  source              = "./connectivity/azure_firewall"
  providers = {
    azurerm.connectivity = azurerm.connectivity
  }
  azure_firewall_name = var.azure_firewall_name
  azure_sku_name      = var.azure_sku_name
  azure_sku_tier      = var.azure_sku_tier
  location            = var.location
  resource_group_name = var.connectivity_resource_group_name
  tags                = merge(var.shared_tags, { project = "connectivity" })
  subnet_ids          = module.connectivity_network.subnet_ids

  depends_on = [module.connectivity_network]
}

# Extract AzureApplicationGatewaySubnet address_prefix
locals {
  azure_application_gateway_subnet_prefix = lookup(
    element([for subnet in var.connectivity_subnets : subnet if subnet.name == "AzureApplicationGatewaySubnet"], 0),
    "address_prefix",
    null
  )
}

# Connectivity Application Gateway Module
module "connectivity_azure_application_gateway" {
  source = "./connectivity/azure_application_gateway"
  providers = {
    azurerm.connectivity = azurerm.connectivity
  }
  appgw_name                = var.appgw_name
  location                  = var.location
  resource_group_name       = var.connectivity_resource_group_name
  subnet_id                 = module.connectivity_network.subnet_ids["AzureApplicationGatewaySubnet"]
  private_ip_address        = cidrhost(local.azure_application_gateway_subnet_prefix, 4) # Example: Get 4th usable IP
  waf_mode                  = var.waf_mode
  waf_rule_set_version      = var.waf_rule_set_version
  tags                      = merge(var.shared_tags, { project = "connectivity" })
  depends_on                = [module.connectivity_network]
}

# Connectivity API Management Module
module "connectivity_azure_api_management" {
  source              = "./connectivity/azure_api_management"
  providers = {
    azurerm.connectivity = azurerm.connectivity
  }
  api_management_name         = var.api_management_name
  location                    = var.location
  resource_group_name         = var.connectivity_resource_group_name
  sku_name                    = var.api_management_sku
  subnet_id                   = module.connectivity_network.subnet_ids["AzureAPIManagementSubnet"]
  publisher_name              = var.api_management_publisher_name
  publisher_email             = var.api_management_publisher_email
  connectivity_vnet_address_space = var.connectivity_vnet_address_space
  management_vnet_address_space   = var.management_vnet_address_space
  identity_vnet_address_space     = var.identity_vnet_address_space
  tags                        = merge(var.shared_tags, { project = "connectivity" })

  depends_on = [module.connectivity_network]
}



# Connectivity Security Module
module "connectivity_security" {
  source              = "./connectivity/security"
  providers = {
    azurerm.connectivity = azurerm.connectivity
    azurerm.identity     = azurerm.identity
    azurerm.management   = azurerm.management
  }
  location                            = var.location
  connectivity_resource_group_name    = var.connectivity_resource_group_name
  connectivity_vnet_address_space     = var.connectivity_vnet_address_space
  identity_vnet_address_space         = var.identity_vnet_address_space
  management_vnet_address_space       = var.management_vnet_address_space
  shared_tags                         = var.shared_tags
  connectivity_subnet_ids             = module.connectivity_network.subnet_ids
  identity_subnet_ids                 = module.identity_network.subnet_ids
  management_subnet_ids               = module.management_network.subnet_ids

  azure_firewall_name                 = var.azure_firewall_name
  azure_firewall_private_ip           = module.connectivity_azure_firewall.azure_firewall_private_ip

  management_resource_group_name      = var.management_resource_group_name
  identity_resource_group_name        = var.identity_resource_group_name

  depends_on = [
    module.connectivity_network,
    module.identity_network,
    module.management_network,
    module.connectivity_azure_firewall,
    module.connectivity_azure_application_gateway
  ]
}


# Management Azure Bastion Module
module "management_azure_bastion" {
  source              = "./management/azure_bastion"
  providers = {
    azurerm.management = azurerm.management
  }

  bastion_name        = var.management_bastion_name
  location            = var.location
  resource_group_name = var.management_resource_group_name
  subnet_id           = module.management_network.subnet_ids["AzureBastionSubnet"]
  tags                = merge(var.shared_tags, { project = "management" })
  depends_on          = [module.management_network]
}

# Azure VPN Gateway Module
module "connectivity_azure_vpngateway" {
  source              = "./connectivity/azure_vpngateway"
  providers = {
    azurerm.connectivity = azurerm.connectivity
  }
  vpn_gateway_name        = var.vpn_gateway_name
  location                = var.location
  resource_group_name     = var.connectivity_resource_group_name
  gateway_subnet_id       = module.connectivity_network.subnet_ids["GatewaySubnet"]
  vpn_gateway_sku         = var.vpn_gateway_sku
  tags                    = merge(var.shared_tags, { project = "connectivity" })
  depends_on = [module.connectivity_network]
}


# Azure Local Network Gateway Module
module "connectivity_azure_local_network_gateway" {
  source = "./connectivity/azure_localnetworkgateway"
  providers = {
    azurerm.connectivity = azurerm.connectivity
  }
  local_gateway_name      = var.local_gateway_name
   location               = var.location
  resource_group_name     = var.connectivity_resource_group_name
  on_prem_gateway_ip      = var.on_prem_gateway_ip
  on_prem_address_spaces  = var.on_prem_address_spaces
  tags                    = merge(var.shared_tags, { project = "connectivity" })
  depends_on = [module.connectivity_network]
}

# platform/main.tf

module "connectivity_azure_private_dns_zone" {
  source = "./connectivity/azure_private_dns_zone"
  providers = {
    azurerm.connectivity = azurerm.connectivity
  }

  dns_zone_name       = var.dns_zone_name
  resource_group_name = var.connectivity_resource_group_name
  virtual_network_ids = [
    module.connectivity_network.vnet_id,
    module.identity_network.vnet_id,
    module.management_network.vnet_id
  ]
  registration_enabled = var.registration_enabled
  depends_on = [ module.connectivity_network, module.identity_network, module.management_network ]
}

module "management_log_analytics_workspace" {
  source = "./management/azure_log_analytics_workspace"
  providers = {
    azurerm.management = azurerm.management
  }

  workspace_name        = var.workspace_name
  location              = var.location
  resource_group_name   = var.management_resource_group_name
  sku                   = var.workspace_sku
  retention_in_days     = var.workspace_retention_in_days
  private_endpoint_name = var.workspace_private_endpoint_name
  subnet_id             = module.management_network.subnet_ids["AzureLogAnalyticsSubnet"]
  private_dns_zone_id   = module.connectivity_azure_private_dns_zone.dns_zone_id
  virtual_network_id    = module.management_network.vnet_id
  tags                  = merge(var.shared_tags, { project = "management" })
  depends_on            = [module.management_network, module.connectivity_azure_private_dns_zone]
}
