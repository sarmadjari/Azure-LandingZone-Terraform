# /platform/management/azure_bastion/main.tf

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.13.0"
      configuration_aliases = [azurerm.management]
    }
  }
}

resource "azurerm_bastion_host" "bastion" {
  provider            = azurerm.management
  name                = var.bastion_name
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                 = "bastion-ip-config"
    subnet_id            = var.subnet_id
    public_ip_address_id = azurerm_public_ip.bastion_pip.id
  }
  tags = var.tags
  depends_on = [azurerm_public_ip.bastion_pip]
}

resource "azurerm_public_ip" "bastion_pip" {
  provider            = azurerm.management
  name                = "${var.bastion_name}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}
