output "compartment_id" {
  description = "Compartment id"
  value = data.oci_identity_compartments.this.compartment_id
}

output "vcn_id" {
  description = "id of vcn that is created"
  value       = oci_core_vcn.vcn.id
}
