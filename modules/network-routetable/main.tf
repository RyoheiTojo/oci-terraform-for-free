data "oci_identity_compartments" "this" {
  compartment_id = var.tenancy_ocid
  compartment_id_in_subtree = true

  filter {
    name   = "name"
    values = [var.compartment_name] # TODO: there is a posibility to match several candidates.
  }
}

resource "oci_core_route_table" "this" {
  for_each = var.route_tables

  compartment_id = data.oci_identity_compartments.this.compartments[0].id  
  vcn_id         = var.vcn_id  
  display_name   = each.key

  dynamic "route_rules" {
    for_each = {for dest in each.value.internet_gateway_destinations: dest=>dest}
    
    content {
      destination       = route_rules.value
      network_entity_id = var.internet_gateway_id
      description       = "Internet Gateway"
    }
  }

  dynamic "route_rules" {
    for_each = {for dest in each.value.service_gateway_destinations: dest=>dest}
    
    content {
      destination       = route_rules.value
      destination_type  = "SERVICE_CIDR_BLOCK"
      network_entity_id = var.service_gateway_id
      description       = "Service Gateway"
    }
  }
}
