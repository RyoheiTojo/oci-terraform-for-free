output "compartments" {
  description = "Compartment tree available"
  value = module.network-subnets.compartments
}

output "network_security_group" {
  description = "NSG available"
  value = module.network-nsg.network_security_groups
}

output "rules" {
  description = "rules"
  value = module.network-nsg.rules
}
