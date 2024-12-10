# /platform/outputs.tf

output "management_subnet_ids_debug" {
  value = keys(module.management_network.subnet_ids)
}