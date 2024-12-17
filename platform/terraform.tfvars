# /platform/terraform.tfvars

location = "West Europe"

tenant_id                    = "0000000-0000-0000-0000-000000000000"

connectivity_subscription_id = "0000000-0000-0000-0000-000000000000"
identity_subscription_id     = "0000000-0000-0000-0000-000000000000"
management_subscription_id   = "0000000-0000-0000-0000-000000000000"

# Shared tags for all resources
shared_tags = {
  environment = "dev"
  owner       = "IT Team"
}

# Resource Group Names
connectivity_external_resource_group_name = "LZ-connectivity-external-rg"
connectivity_internal_resource_group_name = "LZ-connectivity-internal-rg"
identity_resource_group_name     = "LZ-identity-rg"
management_resource_group_name   = "LZ-management-rg"

# IP Ranges for VNets and Subnets
connectivity_external_vnet_name          = "connectivity-external-vnet"
connectivity_external_vnet_address_space = ["10.10.0.0/16"]

connectivity_internal_vnet_name          = "connectivity-internal-vnet"
connectivity_internal_vnet_address_space = ["10.0.0.0/16"]


identity_vnet_name              = "identity-vnet"
identity_vnet_address_space     = ["10.1.0.0/16"]

management_vnet_name            = "management-vnet"
management_vnet_address_space   = ["10.2.0.0/16"]

# Subnet Definitions
connectivity_external_subnets = [
  { name = "AzureFirewallSubnet", address_prefix = "10.10.3.0/24" },
  { name = "AzureFirewallManagementSubnet", address_prefix = "10.10.30.0/24" },

]

connectivity_internal_subnets = [
  { name = "GatewaySubnet", address_prefix = "10.0.2.0/24" },
  { name = "AzureFirewallSubnet", address_prefix = "10.0.3.0/24" },
  { name = "AzureFirewallManagementSubnet", address_prefix = "10.0.30.0/24" },
  { name = "AzureApplicationGatewaySubnet", address_prefix = "10.0.4.0/24" },
  { name = "AzureApiManagement", address_prefix = "10.0.5.0/27" }, # Minimum: /27 (32 addresses) Recommended: /24 (256 addresses) - to accommodate scaling of API Management instance
]

identity_subnets = [
  { name = "auth-subnet", address_prefix = "10.1.1.0/24" },
  { name = "directory-subnet", address_prefix = "10.1.2.0/24" },
]

management_subnets = [
  { name = "AzureBastionSubnet", address_prefix = "10.2.1.0/27" },      # (10.2.1.1 - 10.2.1.30)
  # { name = "AzureLogAnalyticsSubnet", address_prefix = "10.2.1.32/27" }, # (10.2.1.33 - 10.2.1.62)
  { name = "monitoring-subnet", address_prefix = "10.2.2.0/24" },
]


# Azure DDos Protection Plan Configurations
ddos_protection_plan_name     = "ddos-protection-plan"
ddos_protection_plan_enabled  = true

# Azure Firewall Configurations
azure_firewall_external_name  = "external-firewall"  # Define the desired name for the External Azure Firewall here
azure_firewall_internal_name  = "internal-firewall"  # Define the desired name for the Internal Azure Firewall here

azure_sku_name                = "AZFW_VNet"
azure_sku_tier                = "Premium"

# Application Gateway Configurations
appgw_name                 = "app-gateway"


# API Management Configurations
# API Management Configurations
# The API name must to be globaly unique
# The name is used to create a DNS endpoint in the format <api_name>.azure-api.net
api_management_name           = "my-api-management"
# api_management_sku is a string consisting of two parts separated by an underscore(_).
# The first part is the name, valid values include: Consumption, Developer, Basic, Standard and Premium.
# The second part is the capacity (e.g. the number of deployed units of the sku), which must be a positive integer (e.g. Premium_1).
api_management_sku            = "Premium_1"
api_management_publisher_name = "My Company"
api_management_publisher_email = "admin@mycompany.com"


# Azure Bastion configuration
management_bastion_name            = "management-bastion"


# Azure VPN Gateway Configurations
vpn_gateway_name = "vpn-gateway"
vpn_gateway_sku  = "VpnGw2AZ" # VpnGw2AZ Gen2 Zone Redundent Gateway

# Local Network Gateway Configurations
local_gateway_name     = "MyLocalNetworkGateway"
on_prem_gateway_ip     = "203.0.113.10"
on_prem_address_spaces = [
  "192.168.1.0/24",
  "10.0.0.0/16"
]

azure_private_dns_zone_name        = "myCompany.azure"
registration_enabled = true


# Azure Log Analytics Workspace Configurations
workspace_name                  = "log-analytics-workspace"
workspace_sku                   = "PerGB2018"
workspace_retention_in_days     = 30
# workspace_private_endpoint_name = "log-analytics-private-endpoint"