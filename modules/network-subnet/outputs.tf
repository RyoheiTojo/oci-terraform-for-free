output "compartments" {
  description = "Compartment tree available"
  value = data.oci_identity_compartments.this.compartments
}
