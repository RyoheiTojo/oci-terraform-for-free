data "oci_identity_compartments" "this" {
  compartment_id = var.tenancy_ocid
  compartment_id_in_subtree = true

  filter {
    name   = "name"
    values = [var.compartment_name] # TODO: there is a posibility to match several candidates.
  }
}

data "oci_core_vcns" "this" {
  compartment_id = data.oci_identity_compartments.this.compartments[0].id
  display_name   = var.vcn_name
}

resource "oci_core_subnet" "this" {
  for_each = var.subnets
  
  cidr_block                 = each.value.cidr_block
  compartment_id             = data.oci_identity_compartments.this.compartments[0].id
  vcn_id                     = data.oci_core_vcns.this.virtual_networks[0].id
  route_table_id             = var.route_tables[each.value.route_table_name]
  display_name               = each.key
  prohibit_public_ip_on_vnic = !each.value.is_public
}

