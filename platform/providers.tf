# /platform/providers.tf

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.12.0"
    }
  }
}

# Connectivity Subscription Provider
provider "azurerm" {
  alias           = "connectivity"
  subscription_id = var.connectivity_subscription_id
  features        {}
}

# Identity Subscription Provider
provider "azurerm" {
  alias           = "identity"
  subscription_id = var.identity_subscription_id
  features        {}
}

# Management Subscription Provider
provider "azurerm" {
  alias           = "management"
  subscription_id = var.management_subscription_id
  features        {}
}
