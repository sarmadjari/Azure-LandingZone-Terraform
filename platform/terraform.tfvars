# /platform/terraform.tfvars

location = "West Europe"

connectivity_subscription_id = "0000000-0000-0000-0000-000000000000"
identity_subscription_id     = "0000000-0000-0000-0000-000000000000"
management_subscription_id   = "0000000-0000-0000-0000-000000000000"

# Shared tags for all resources
shared_tags = {
  environment = "dev"
  owner       = "IT Team"
}

# Resource Group Names
connectivity_resource_group_name = "LZ-connectivity-rg"
identity_resource_group_name     = "LZ-identity-rg"
management_resource_group_name   = "LZ-management-rg"

# IP Ranges for VNets and Subnets
connectivity_vnet_name          = "connectivity-vnet"
connectivity_vnet_address_space = ["10.0.0.0/16"]

identity_vnet_name              = "identity-vnet"
identity_vnet_address_space     = ["10.1.0.0/16"]

management_vnet_name            = "management-vnet"
management_vnet_address_space   = ["10.2.0.0/16"]

# Subnet Definitions
connectivity_subnets = [
  { name = "connectivity-management-subnet", address_prefix = "10.0.100.0/24" },
  { name = "AzureFirewallSubnet", address_prefix = "10.0.10.0/24" },
  { name = "AzureFirewallManagementSubnet", address_prefix = "10.0.11.0/24" },
  { name = "AzureApplicationGatewaySubnet", address_prefix = "10.0.2.0/24" },
  { name = "AzureAPIManagementSubnet", address_prefix = "10.0.3.0/28" },
  #{ name = "fortigate-external-subnet", address_prefix = "10.0.1.0/26" },       # 64 (59 Usable)  addresses for External   (10.0.1.4 - 10.0.1.62)
  #{ name = "fortigate-internal-subnet", address_prefix = "10.0.1.64/26" },      # 64 (59 Usable)  addresses for Internal   (10.0.1.68 - 10.0.1.126)
  #{ name = "fortigate-ha-sync-subnet", address_prefix = "10.0.1.128/29" },      # 8  (3 Usable)   addresses for HA Sync    (10.0.1.132 - 10.0.1.134)
  #{ name = "fortigate-protected-a-subnet", address_prefix = "10.0.1.144/28" },  # 16 (11 Usable)  addresses for Protected  (10.0.1.148 - 10.0.1.158)
  #{ name = "nva2-external-subnet", address_prefix = "10.0.3.0/24" },
  #{ name = "nva2-internal-subnet", address_prefix = "10.0.4.0/24" },
]

identity_subnets = [
  { name = "auth-subnet", address_prefix = "10.1.1.0/24" },
  { name = "directory-subnet", address_prefix = "10.1.2.0/24" },
]

management_subnets = [
  { name = "AzureBastionSubnet", address_prefix = "10.2.1.0/27" },
  { name = "monitoring-subnet", address_prefix = "10.2.2.0/24" },
]

# Azure Firewall Configurations
azure_firewall_name = "internal-firewall"  # Define the desired name for the Azure Firewall here
azure_sku_name      = "AZFW_VNet"
azure_sku_tier      = "Premium"

# Application Gateway Configurations
appgw_name                 = "app-gateway"
appgw_private_ip_address   = "10.0.2.4"  # Ensure this IP is within the application-gateway-subnet


# API Management Configurations
api_management_name           = "my-api-management"
api_management_sku            = "Premium_1" # sku_name is a string consisting of two parts separated by an underscore(_). The first part is the name, valid values include: Consumption, Developer, Basic, Standard and Premium. The second part is the capacity (e.g. the number of deployed units of the sku), which must be a positive integer (e.g. Premium_1).
api_management_publisher_name = "My Company"
api_management_publisher_email = "admin@mycompany.com"


# Azure Bastion configuration
management_bastion_name            = "management-bastion"