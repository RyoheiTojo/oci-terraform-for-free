output "id" {
  description = "Compartment ID"
  value = oci_identity_compartment.this[0].id
}

output "compartment_id" {
  description = "Parent Compartment ID"
  value = oci_identity_compartment.this[0].compartment_id
}

output "name" {
  description = "Compartment name"
  value = oci_identity_compartment.this[0].name
}

output "description" {
  description = "Compartment description"
  value = oci_identity_compartment.this[0].description
}
