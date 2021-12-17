output "network-subnets" {
  description = "Subnets list"
  value = module.network-subnets.this
}

output "network_security_groups" {
  description = "NSG list"
  value = module.network-nsg.this
}
