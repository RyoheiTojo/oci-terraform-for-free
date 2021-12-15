data "oci_identity_compartments" "this" {
  compartment_id = var.tenancy_ocid
  compartment_id_in_subtree = true

  filter {
    name   = "name"
    values = [var.compartment_name] # TODO: there is a posibility to match several candidates.
  }
}

resource "oci_core_route_table" "this" {
  compartment_id = data.oci_identity_compartments.this.compartments[0].id  
  vcn_id         = var.vcn_id  
  display_name   = var.routetable_name

  dynamic "route_rules" {
    for_each = var.internet_gateway_id != null ? {id: var.internet_gateway_id} : {}
    
    content {
      destination       = "0.0.0.0/0"
      network_entity_id = route_rules.value
      description       = "Internet Gateway as default gateway"
    }
  }
}
