# /platform/providers.tf

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.13.0"
    }
  }
}

# Connectivity Subscription Provider
provider "azurerm" {
  alias           = "connectivity"
  tenant_id       = var.tenant_id
  subscription_id = var.connectivity_subscription_id
  features        {}
}

# Identity Subscription Provider
provider "azurerm" {
  alias           = "identity"
  tenant_id       = var.tenant_id
  subscription_id = var.identity_subscription_id
  features        {}
}

# Management Subscription Provider
provider "azurerm" {
  alias           = "management"
  tenant_id       = var.tenant_id
  subscription_id = var.management_subscription_id
  features        {}
}
