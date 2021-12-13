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
