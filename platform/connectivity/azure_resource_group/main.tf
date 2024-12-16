# /platform/connectivity/azure_resource_group/main.tf

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


# Create Resource Group for Connectivity Network
resource "azurerm_resource_group" "connectivity_rg" {
  provider = azurerm.connectivity
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}