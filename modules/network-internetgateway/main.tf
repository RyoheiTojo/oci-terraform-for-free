data "oci_identity_compartments" "this" {
  compartment_id = var.tenancy_ocid
  compartment_id_in_subtree = true

  filter {
    name   = "name"
    values = [var.compartment_name] # TODO: there is a posibility to match several candidates.
  }
}

resource "oci_core_internet_gateway" "this" {
  compartment_id = data.oci_identity_compartments.this.compartments[0].id
  vcn_id         = var.vcn_id
  enabled        = true
  display_name   = var.internet_gateway_name
}
