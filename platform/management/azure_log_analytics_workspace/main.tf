# /platform/management/azure_log_analytics_workspace/main.tf

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.13.0"
      configuration_aliases = [azurerm.management]
    }
  }
}

# Create a Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  provider            = azurerm.management
  name                = var.workspace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  retention_in_days   = var.retention_in_days

  tags = var.tags
}

# Create a Private Endpoint for the Log Analytics Workspace
resource "azurerm_private_endpoint" "log_analytics_private_endpoint" {
  provider            = azurerm.management
  name                = var.private_endpoint_name
  location            = azurerm_log_analytics_workspace.log_analytics_workspace.location
  resource_group_name = azurerm_log_analytics_workspace.log_analytics_workspace.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${azurerm_log_analytics_workspace.log_analytics_workspace.name}-connection"
    private_connection_resource_id = azurerm_log_analytics_workspace.log_analytics_workspace.id
    is_manual_connection           = false
    subresource_names              = ["workspace"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [var.private_dns_zone_id]
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "dns_zone_link" {
  provider              = azurerm.management
  name                  = "${var.private_endpoint_name}-dns-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = var.private_dns_zone_name
  virtual_network_id    = var.virtual_network_id
  registration_enabled  = false
}