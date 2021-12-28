data "oci_identity_compartments" "this" {
  compartment_id = var.tenancy_ocid
  compartment_id_in_subtree = true

  filter {
    name   = "name"
    values = [var.compartment_name] # TODO: there is a posibility to match several candidates.
  }
}

data "oci_identity_availability_domains" "this" {
    compartment_id = var.tenancy_ocid
}

resource "oci_core_boot_volume" "this" {
  for_each = var.boot_volumes

  compartment_id      = data.oci_identity_compartments.this.compartments[0].id
  availability_domain = data.oci_identity_availability_domains.this.availability_domains[var.ad_index].name

  source_details {
    id   = each.value.source_id
    type = each.value.source_type
  }
}