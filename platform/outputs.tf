# /platform/outputs.tf

# Output the Firewall ID
output "internal_firewall_id" {
  value       = module.connectivity_security.internal_firewall_id
  description = "The ID of the internal firewall"
}


