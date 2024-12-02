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
