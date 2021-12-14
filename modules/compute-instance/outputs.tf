output "ads" {
  description = "Availability domains"
  value = data.oci_identity_availability_domains.this.availability_domains
}

output "subnets" {
  description = "Subnets"
  value = data.oci_core_subnets.this.subnets
}

output "compartments" {
  description = "Compartments"
  value = data.oci_identity_compartments.this.compartments
}

output "fds" {
  description = "Fault domains"
  value = data.oci_identity_fault_domains.this.fault_domains
}

output "nsgs" {
  description = "Network security groups"
  value = data.oci_core_network_security_groups.this.network_security_groups
}
