# /platform/connectivity/fortigate/main.tf

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.6.0"
      configuration_aliases = [azurerm.connectivity]
    }
  }
}

resource "azurerm_virtual_machine" "fortigate_vm" {
  provider = azurerm.connectivity
  for_each            = { for idx in range(var.fortigate_count) : idx => idx + 1 }
  name                = "${var.fortigate_prefix_name}-${each.value}"
  location            = var.location
  resource_group_name = var.resource_group_name
  zones               = [var.available_zones[each.key % length(var.available_zones)]]
  vm_size             = var.fortigate_vm_size

  # OS and admin configuration
  os_profile {
    computer_name  = "${var.fortigate_prefix_name}-${each.value}"
    admin_username = var.fortigate_admin_username
    admin_password = var.fortigate_admin_password
  }

  # Storage profile
  storage_os_disk {
    name              = "${var.fortigate_prefix_name}-${each.value}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  # Network interfaces
  network_interface_ids = [
    azurerm_network_interface.nic_external[each.key].id,
    azurerm_network_interface.nic_internal[each.key].id,
    azurerm_network_interface.nic_ha_sync[each.key].id,
    azurerm_network_interface.nic_management[each.key].id
  ]
}

# Network Interface for External subnet
resource "azurerm_network_interface" "nic_external" {
  provider = azurerm.connectivity
  for_each            = { for idx in range(var.fortigate_count) : idx => idx + 1 }
  name                = "${var.fortigate_prefix_name}-${each.value}-nic-external"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "external"
    subnet_id                     = var.fortigate_external_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

# Network Interface for Internal subnet
resource "azurerm_network_interface" "nic_internal" {
  provider = azurerm.connectivity
  for_each            = { for idx in range(var.fortigate_count) : idx => idx + 1 }
  name                = "${var.fortigate_prefix_name}-${each.value}-nic-internal"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.fortigate_internal_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

# Network Interface for HA Sync subnet
resource "azurerm_network_interface" "nic_ha_sync" {
  provider = azurerm.connectivity
  for_each            = { for idx in range(var.fortigate_count) : idx => idx + 1 }
  name                = "${var.fortigate_prefix_name}-${each.value}-nic-ha-sync"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "ha-sync"
    subnet_id                     = var.fortigate_ha_sync_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

# Network Interface for Management subnet
resource "azurerm_network_interface" "nic_management" {
  provider = azurerm.connectivity
  for_each            = { for idx in range(var.fortigate_count) : idx => idx + 1 }
  name                = "${var.fortigate_prefix_name}-${each.value}-nic-management"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "management"
    subnet_id                     = var.connectivity_management_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}


# Adding the FortiGate VMs to the Load Balancers

# External Load Balancer Public IP
resource "azurerm_public_ip" "external_lb_ip_public" {
  provider            = azurerm.connectivity
  name                = "${var.fortigate_prefix_name}-lb-external-ip-public"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# External Load Balancer
resource "azurerm_lb" "external_lb" {
  provider            = azurerm.connectivity
  name                = "${var.fortigate_prefix_name}-lb-external"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "publicFrontend"
    public_ip_address_id = azurerm_public_ip.external_lb_ip_public.id
  }

  frontend_ip_configuration {
    name                 = "privateFrontend"
    subnet_id            = var.fortigate_external_subnet_id
    private_ip_address_allocation = "dynamic"
  }
}

# Internal Load Balancer
resource "azurerm_lb" "internal_lb" {
  provider            = azurerm.connectivity
  name                = "${var.fortigate_prefix_name}-lb-internal"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "internalFrontend"
    subnet_id            = var.fortigate_internal_subnet_id
    private_ip_address_allocation = "dynamic"
  }
}

# Backend Pool for External Load Balancer
resource "azurerm_lb_backend_address_pool" "external_lb_backend" {
  provider            = azurerm.connectivity
  name                = "${var.fortigate_prefix_name}-external-backend-pool"
  loadbalancer_id     = azurerm_lb.external_lb.id
}

# Backend Pool for Internal Load Balancer
resource "azurerm_lb_backend_address_pool" "internal_lb_backend" {
  provider            = azurerm.connectivity
  name                = "${var.fortigate_prefix_name}-internal-backend-pool"
  loadbalancer_id     = azurerm_lb.internal_lb.id
}

# Add each VM's NIC to the External Load Balancer Backend Pool
resource "azurerm_network_interface_backend_address_pool_association" "external_lb_nic_assoc" {
  provider            = azurerm.connectivity
  for_each            = azurerm_network_interface.nic_external
  network_interface_id = each.value.id
  backend_address_pool_id = azurerm_lb_backend_address_pool.external_lb_backend.id
  ip_configuration_name = "external"
}

resource "azurerm_network_interface_backend_address_pool_association" "internal_lb_nic_assoc" {
  provider            = azurerm.connectivity
  for_each            = azurerm_network_interface.nic_internal
  network_interface_id = each.value.id
  backend_address_pool_id = azurerm_lb_backend_address_pool.internal_lb_backend.id
  ip_configuration_name = "internal"
}

# Probes and Load Balancing Rules for the External Load Balancer
resource "azurerm_lb_probe" "external_lb_probe" {
  provider            = azurerm.connectivity
  loadbalancer_id     = azurerm_lb.external_lb.id
  name                = "external-probe"
  protocol            = "Tcp"
  port                = 80
  interval_in_seconds = 5
  number_of_probes    = 2
}

resource "azurerm_lb_rule" "external_lb_rule" {
  provider                     = azurerm.connectivity
  loadbalancer_id              = azurerm_lb.external_lb.id
  name                         = "external-rule"
  protocol                     = "Tcp"
  frontend_port                = 80
  backend_port                 = 80
  frontend_ip_configuration_name = "publicFrontend"
  backend_address_pool_ids     = [azurerm_lb_backend_address_pool.external_lb_backend.id]
  probe_id                     = azurerm_lb_probe.external_lb_probe.id
}

# Probes and Load Balancing Rules for the Internal Load Balancer
resource "azurerm_lb_probe" "internal_lb_probe" {
  provider            = azurerm.connectivity
  loadbalancer_id     = azurerm_lb.internal_lb.id
  name                = "internal-probe"
  protocol            = "Tcp"
  port                = 80
  interval_in_seconds = 5
  number_of_probes    = 2
}

resource "azurerm_lb_rule" "internal_lb_rule" {
  provider                     = azurerm.connectivity
  loadbalancer_id              = azurerm_lb.internal_lb.id
  name                         = "internal-rule"
  protocol                     = "Tcp"
  frontend_port                = 80
  backend_port                 = 80
  frontend_ip_configuration_name = "internalFrontend"
  backend_address_pool_ids     = [azurerm_lb_backend_address_pool.internal_lb_backend.id]
  probe_id                     = azurerm_lb_probe.internal_lb_probe.id
}

