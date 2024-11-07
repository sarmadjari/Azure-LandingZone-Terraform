# /platform/connectivity/fortigate/outputs.tf

output "fortigate_vm_names" {
  description = "The names of the deployed Fortigate VMs"
  value       = [for vm in azurerm_virtual_machine.fortigate_vm : vm.name]
}

output "fortigate_vm_private_ips" {
  description = "The private IP addresses of each Fortigate VM's network interfaces"
  value       = {
    for idx, vm in azurerm_virtual_machine.fortigate_vm : 
    vm.name => [
      azurerm_network_interface.nic_external[idx].ip_configuration[0].private_ip_address,
      azurerm_network_interface.nic_internal[idx].ip_configuration[0].private_ip_address,
      azurerm_network_interface.nic_ha_sync[idx].ip_configuration[0].private_ip_address,
      azurerm_network_interface.nic_management[idx].ip_configuration[0].private_ip_address
    ]
  }
}
