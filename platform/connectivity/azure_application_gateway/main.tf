# /platform/connectivity/azure_application_gateway/main.tf

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


# Application Gateway
resource "azurerm_application_gateway" "app_gateway" {
  provider            = azurerm.connectivity
  name                = var.appgw_name
  location            = var.location
  resource_group_name = var.resource_group_name

  sku {
    name     = var.appgw_sku_name
    tier     = var.appgw_sku_tier
    capacity = var.appgw_capacity
  }

  gateway_ip_configuration {
    name      = "appgw-ip-config"
    subnet_id = var.subnet_id
  }

  frontend_port {
    name = "frontend-port-http"
    port = var.frontend_port_http
  }

  frontend_ip_configuration {
    name                          = "appgw-frontend-ip"
    subnet_id                     = var.subnet_id
    private_ip_address            = var.private_ip_address
    private_ip_address_allocation = "Static"
  }

  backend_address_pool {
    name = "appgw-backend-pool"
    # Define backend addresses or make this a variable
  }

  backend_http_settings {
    name                  = "appgw-backend-http-settings"
    cookie_based_affinity = "Disabled"
    port                  = var.backend_port
    protocol              = var.backend_protocol
    request_timeout       = 30
  }

  http_listener {
    name                           = "appgw-http-listener"
    frontend_ip_configuration_name = "appgw-frontend-ip"
    frontend_port_name             = "frontend-port-http"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "appgw-http-routing-rule"
    rule_type                  = "Basic"
    http_listener_name         = "appgw-http-listener"
    backend_address_pool_name  = "appgw-backend-pool"
    backend_http_settings_name = "appgw-backend-http-settings"
  }

  waf_configuration {
    enabled          = true
    firewall_mode    = var.waf_mode
    rule_set_type    = "OWASP"
    rule_set_version = var.waf_rule_set_version
  }

  tags = var.tags
}