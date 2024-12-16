# /platform/connectivity/azure_api_management/main.tf

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

# Azure API Management
resource "azurerm_api_management" "api_management" {
  provider            = azurerm.connectivity
  name                = var.api_management_name
  location            = var.location
  resource_group_name = var.resource_group_name
  publisher_name      = var.publisher_name
  publisher_email     = var.publisher_email
  sku_name            = var.sku_name
  

  virtual_network_configuration {
    subnet_id = var.subnet_id
  }
  virtual_network_type = "Internal"  # Ensures the APIM is private
  tags = var.tags
  
  depends_on = [
    azurerm_network_security_group.apim_nsg,
    azurerm_subnet_network_security_group_association.apim_nsg_association
  ]
}

# Define Network Security Group (NSG)
resource "azurerm_network_security_group" "apim_nsg" {
  provider            = azurerm.connectivity
  name                = "${var.api_management_name}-nsg"
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
    source_address_prefix      = var.connectivity_internal_vnet_address_space[0]
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
    source_address_prefix      = var.management_vnet_address_space[0]
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
    source_address_prefix      = var.identity_vnet_address_space[0]
    destination_address_prefix = "*"
  }

  # Inbound: Allow traffic to Management Endpoint
  security_rule {
    name                       = "Allow-Management-Endpoint"
    priority                   = 130
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3443"
    source_address_prefix      = "ApiManagement"
    destination_address_prefix = "VirtualNetwork"
  }

  # Outbound: Allow traffic to Allow Control Plane Traffic and Azure dependencies (e.g., Storage, Azure Monitor, Key Vault)
  security_rule {
    name                       = "Allow-Control-Plane-Outbound"
    priority                   = 140
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "AzureCloud"
  }

  # Outbound: Allow DNS traffic
  security_rule {
    name                       = "Allow-DNS-Traffic-UDP"
    priority                   = 150
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Udp"
    source_port_range          = "*"
    destination_port_range     = "53"
    source_address_prefix      = "*"
    destination_address_prefix = "AzureCloud"
  }

  security_rule {
  name                       = "Allow-DNS-Traffic-TCP"
  priority                   = 151
  direction                  = "Outbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "53"
  source_address_prefix      = "*"
  destination_address_prefix = "AzureCloud"
}


}

# Associate NSG with Azure API Management Subnet
resource "azurerm_subnet_network_security_group_association" "apim_nsg_association" {
  provider                  = azurerm.connectivity
  subnet_id                 = var.subnet_id
  network_security_group_id = azurerm_network_security_group.apim_nsg.id
}
