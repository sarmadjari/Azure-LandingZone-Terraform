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


resource "azurerm_network_interface" "fortigate_external_nic" {
  name                = "${var.fortigate_prefix_name}-nic-external"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "external"
    subnet_id                     = var.fortigate_external_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}


resource "azurerm_network_interface" "fortigate_internal_nic" {
  name                = "${var.fortigate_prefix_name}-nic-internal"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.fortigate_internal_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "fortigate_mangement_nic" {
  name                = "${var.fortigate_prefix_name}-nic-mangement"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "mangement"
    subnet_id                     = var.connectivity_management_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "example" {
  name                  = var.fortigate_prefix_name
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [ azurerm_network_interface.fortigate_external_nic.id, azurerm_network_interface.fortigate_internal_nic.id, azurerm_network_interface.fortigate_mangement_nic.id]
  vm_size               = var.fortigate_vm_size

  storage_os_disk {
    name              = "${var.fortigate_prefix_name}-os-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "fortinet"
    offer     = "fortinet_fortigate-vm_v5"
    sku       = "fortinet_fg-vm"
    version   = "latest"
  }

  os_profile {
    computer_name  = var.fortigate_prefix_name
    admin_username = var.fortigate_admin_username
    admin_password = var.fortigate_admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
  depends_on = [ azurerm_network_interface.fortigate_external_nic, azurerm_network_interface.fortigate_internal_nic, azurerm_network_interface.fortigate_mangement_nic]
}