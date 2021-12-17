data "oci_identity_compartments" "this" {
  compartment_id = var.tenancy_ocid
  compartment_id_in_subtree = true

  filter {
    name   = "name"
    values = [var.vcn.compartment_name] # TODO: there is a posibility to match several candidates.
  }
}

resource "oci_core_vcn" "this" {
  cidr_block     = var.vcn.cidr_block
  compartment_id = data.oci_identity_compartments.this.compartments[0].id
  display_name   = var.vcn.name
  is_ipv6enabled = false
}
