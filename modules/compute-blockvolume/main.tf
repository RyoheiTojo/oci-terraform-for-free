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

resource "oci_core_volume" "this" {
  for_each = var.block_volumes
  
  compartment_id      = data.oci_identity_compartments.this.compartments[0].id
  availability_domain = data.oci_identity_availability_domains.this.availability_domains[var.ad_index].name
  display_name        = each.key
  size_in_gbs         = each.value.size_in_gbs

  dynamic "source_details" {
    for_each = each.value.source_id == null ? {} : {source_id: each.value.source_id, source_type: each.value.source_type}
    
    content {
      id   = source_details.source_id
      type = source_details.source_type
    }
  }
}