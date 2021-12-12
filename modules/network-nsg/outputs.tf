output "network_security_groups" {
  description = "Network security groups"
  value = oci_core_network_security_group.this
}

output "rules" {
  description = "rules"
  value = var.network_security_group_rules
}
