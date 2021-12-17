output "network-subnets" {
  description = "Subnets list"
  value = module.network-subnets.this
}

output "network_security_group" {
  description = "NSG available"
  value = module.network-nsg.network_security_groups
}

output "rules" {
  description = "rules"
  value = module.network-nsg.rules
}
