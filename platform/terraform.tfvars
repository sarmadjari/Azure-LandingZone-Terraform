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
  { name = "fortigate-external-subnet", address_prefix = "10.0.1.0/26" },       # 64 (59 Usable)  addresses for External   (10.0.1.4 - 10.0.1.62)
  { name = "fortigate-internal-subnet", address_prefix = "10.0.1.64/26" },      # 64 (59 Usable)  addresses for Internal   (10.0.1.68 - 10.0.1.126)
  { name = "fortigate-ha-sync-subnet", address_prefix = "10.0.1.128/29" },      # 8  (3 Usable)   addresses for HA Sync    (10.0.1.132 - 10.0.1.134)
  #{ name = "fortigate-protected-a-subnet", address_prefix = "10.0.1.144/28" },  # 16 (11 Usable)  addresses for Protected  (10.0.1.148 - 10.0.1.158)
  { name = "nva2-external-subnet", address_prefix = "10.0.3.0/24" },
  { name = "nva2-internal-subnet", address_prefix = "10.0.4.0/24" },
  { name = "AzureFirewallSubnet", address_prefix = "10.0.10.0/24" },
  { name = "AzureFirewallManagementSubnet", address_prefix = "10.0.11.0/24" },
]

identity_subnets = [
  { name = "auth-subnet", address_prefix = "10.1.1.0/24" },
  { name = "directory-subnet", address_prefix = "10.1.2.0/24" },
]

management_subnets = [
  { name = "admin-subnet", address_prefix = "10.2.1.0/24" },
  { name = "monitoring-subnet", address_prefix = "10.2.2.0/24" },
]

# Azure Firewall Configuration
firewall_name = "internal-firewall"  # Define the desired name for the Azure Firewall here
sku_name      = "AZFW_VNet"
sku_tier      = "Premium"

#Fortigate Configuration
fortigate_prefix_name      = "fortigate"
fortigate_vm_size          = "Standard_F2"
fortigate_count            = 2
fortigate_admin_username   = "fortigateadmin"
fortigate_admin_password   = "P@ss0rd1234"
