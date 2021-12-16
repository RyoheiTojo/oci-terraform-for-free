// Copyright (c) 2018, 2021, Oracle and/or its affiliates.

output "id" {
  description = "Compartment ID"
  value = oci_identity_compartment.this[0].id
}

output "parent_compartment_id" {
  description = "Parent Compartment ID"
  value = oci_identity_compartment.this[0].compartment_id
}

output "compartment_name" {
  description = "Compartment name"
  value = oci_identity_compartment.this[0].name
}

output "compartment_description" {
  description = "Compartment description"
  value = oci_identity_compartment.this[0].description
}
