# /platform/connectivity/azure_api_management/main.tf

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.6.0"
      configuration_aliases = [
        azurerm.connectivity
      ]
    }
  }
}

# Azure API Management
resource "azurerm_api_management" "api_management" {
  provider            = azurerm.connectivity
  name                = var.api_management_name
  location            = var.location
  resource_group_name = var.resource_group_name
  publisher_name      = var.publisher_name
  publisher_email     = var.publisher_email
  sku_name            = var.sku_name
  # zones               = ["1", "2", "3"] it dose not work unless we specify a public IP, Premium is Zone deundent by default

  virtual_network_configuration {
    subnet_id = var.subnet_id
  }

  virtual_network_type = "Internal"  # Ensures the APIM is private

  tags = var.tags
}

# Define Network Security Group (NSG)
resource "azurerm_network_security_group" "apim_nsg" {
  name                = "apim-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  # Allow traffic from Connectivity VNet
  security_rule {
    name                       = "Allow-Connectivity-VNet"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = var.connectivity_vnet_address_space[0] # Add first address space
    destination_address_prefix = "*"
  }

  # Allow traffic from Management VNet
  security_rule {
    name                       = "Allow-Management-VNet"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = var.management_vnet_address_space[0] # Add first address space
    destination_address_prefix = "*"
  }

  # Allow traffic from Identity VNet
  security_rule {
    name                       = "Allow-Identity-VNet"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = var.identity_vnet_address_space[0] # Add first address space
    destination_address_prefix = "*"
  }
}


# Associate NSG with the Azure API Management Subnet
resource "azurerm_subnet_network_security_group_association" "apim_nsg_association" {
  subnet_id                 = module.connectivity_network.subnet_ids["AzureAPIManagementSubnet"]
  network_security_group_id = azurerm_network_security_group.apim_nsg.id
}


