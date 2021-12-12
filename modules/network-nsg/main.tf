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

resource "oci_core_network_security_group" "this" {
  for_each       = var.network_security_groups
  compartment_id = data.oci_identity_compartments.this.compartments[0].id
  vcn_id         = data.oci_core_vcns.this.virtual_networks[0].id
  display_name   = each.value.display_name
}

locals {
  ingress_tcp = flatten([
    for nsg in var.network_security_group_rules: [
      for d in nsg.dest_port: {
        nsg_name  = nsg.nsg_name
        src_type  = nsg.src_type
        src       = nsg.src
        dest_port = {min: d.min, max: d.max}
        stateless = nsg.stateless
      } if nsg.direction == "INGRESS" && nsg.protocol == "TCP"
    ]
  ])
}

resource "oci_core_network_security_group_security_rule" "ingress_rules_tcp" {
  for_each   = {for r in local.ingress_tcp: "${r.nsg_name}-ingress-tcp-dest_${r.dest_port.min}to${r.dest_port.max}" => r}
  depends_on = [ oci_core_network_security_group.this ]

  network_security_group_id = [for nsg in oci_core_network_security_group.this: nsg.id if nsg.display_name == each.value.nsg_name][0]
  direction                 = "INGRESS"
  protocol                  = "6" # TCP
  description               = "${each.value.nsg_name}-INGRESS-TCP-SOURCE-${each.value.dest_port.min}-${each.value.dest_port.max}"
  source_type               = each.value.src_type == "NSG" ? "NETWORK_SECURITY_GROUP" : "CIDR_BLOCK"
  source                    = each.value.src
  stateless                 = each.value.stateless

  tcp_options {
    destination_port_range {
      min = each.value.dest_port.min
      max = each.value.dest_port.max
    }
  }
}
