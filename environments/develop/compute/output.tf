output "ads" {
  description = "Availability domain list"
  value = module.compute-instance.ads
}

output "subnets" {
  description = "Subnet list"
  value = module.compute-instance.subnets
}

output "compartments" {
  description = "Compartment list"
  value = module.compute-instance.compartments
}
