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
      }
    ] if nsg.direction == "INGRESS" && nsg.protocol == "TCP"
  ])

  egress_tcp = flatten([
    for nsg in var.network_security_group_rules: [
      for d in nsg.dest_port: {
        nsg_name  = nsg.nsg_name
        dest_type = nsg.dest_type
        dest      = nsg.dest
        dest_port = {min: d.min, max: d.max}
        stateless = nsg.stateless
      }
    ] if nsg.direction == "EGRESS" && nsg.protocol == "TCP"
  ])

  ingress_udp = flatten([
    for nsg in var.network_security_group_rules: [
      for d in nsg.dest_port: {
        nsg_name  = nsg.nsg_name
        src_type  = nsg.src_type
        src       = nsg.src
        dest_port = {min: d.min, max: d.max}
        stateless = nsg.stateless
      }
    ] if nsg.direction == "INGRESS" && nsg.protocol == "UDP"
  ])

  egress_udp = flatten([
    for nsg in var.network_security_group_rules: [
      for d in nsg.dest_port: {
        nsg_name  = nsg.nsg_name
        dest_type = nsg.dest_type
        dest      = nsg.dest
        dest_port = {min: d.min, max: d.max}
        stateless = nsg.stateless
      }
    ] if nsg.direction == "EGRESS" && nsg.protocol == "UDP"
  ])
}

resource "oci_core_network_security_group_security_rule" "ingress_rules_all" {
  for_each   = {for k,v in var.network_security_group_rules: k => v if v.direction == "INGRESS" && v.protocol == "ALL"}
  depends_on = [ oci_core_network_security_group.this ]

  network_security_group_id = [for nsg in oci_core_network_security_group.this: nsg.id if nsg.display_name == each.value.nsg_name][0]
  direction                 = "INGRESS"
  protocol                  = "all"
  description               = "${each.value.src}-to-${each.value.nsg_name}-INGRESS-ALL"
  source_type               = each.value.src_type == "NSG" ? "NETWORK_SECURITY_GROUP" : "CIDR_BLOCK"
  source                    = each.value.src_type == "NSG" ? [for nsg in oci_core_network_security_group.this: nsg.id if nsg.display_name == each.value.src][0] : each.value.src
  stateless                 = each.value.stateless
}

resource "oci_core_network_security_group_security_rule" "egress_rules_all" {
  for_each   = {for k,v in var.network_security_group_rules: k => v if v.direction == "EGRESS" && v.protocol == "ALL"}
  depends_on = [ oci_core_network_security_group.this ]

  network_security_group_id = [for nsg in oci_core_network_security_group.this: nsg.id if nsg.display_name == each.value.nsg_name][0]
  direction                 = "EGRESS"
  protocol                  = "all"
  description               = "${each.value.nsg_name}-to-${each.value.dest}-EGRESS-ALL"
  destination_type          = each.value.dest_type == "NSG" ? "NETWORK_SECURITY_GROUP" : "CIDR_BLOCK"
  destination               = each.value.dest_type == "NSG" ? [for nsg in oci_core_network_security_group.this: nsg.id if nsg.display_name == each.value.dest][0] : each.value.dest
  stateless                 = each.value.stateless
}

resource "oci_core_network_security_group_security_rule" "ingress_rules_tcp" {
  for_each   = {for r in local.ingress_tcp: "${r.nsg_name}-ingress-tcp-dest_${r.dest_port.min}to${r.dest_port.max}" => r}
  depends_on = [ oci_core_network_security_group.this ]

  network_security_group_id = [for nsg in oci_core_network_security_group.this: nsg.id if nsg.display_name == each.value.nsg_name][0]
  direction                 = "INGRESS"
  protocol                  = "6" # TCP
  description               = "${each.value.src}-to-${each.value.nsg_name}-INGRESS-TCP-DEST(${each.value.dest_port.min}-${each.value.dest_port.max})"
  source_type               = each.value.src_type == "NSG" ? "NETWORK_SECURITY_GROUP" : "CIDR_BLOCK"
  source                    = each.value.src_type == "NSG" ? [for nsg in oci_core_network_security_group.this: nsg.id if nsg.display_name == each.value.src][0] : each.value.src
  stateless                 = each.value.stateless

  tcp_options {
    destination_port_range {
      min = each.value.dest_port.min
      max = each.value.dest_port.max
    }
  }
}

resource "oci_core_network_security_group_security_rule" "egress_rules_tcp" {
  for_each   = {for r in local.egress_tcp: "${r.nsg_name}-egress-tcp-dest_${r.dest_port.min}to${r.dest_port.max}" => r}
  depends_on = [ oci_core_network_security_group.this ]

  network_security_group_id = [for nsg in oci_core_network_security_group.this: nsg.id if nsg.display_name == each.value.nsg_name][0]
  direction                 = "EGRESS"
  protocol                  = "6" # TCP
  description               = "${each.value.nsg_name}-to-${each.value.dest}-EGRESS-TCP-DEST(${each.value.dest_port.min}-${each.value.dest_port.max})"
  destination_type          = each.value.dest_type == "NSG" ? "NETWORK_SECURITY_GROUP" : "CIDR_BLOCK"
  destination               = each.value.dest_type == "NSG" ? [for nsg in oci_core_network_security_group.this: nsg.id if nsg.display_name == each.value.dest][0] : each.value.dest
  stateless                 = each.value.stateless

  tcp_options {
    destination_port_range {
      min = each.value.dest_port.min
      max = each.value.dest_port.max
    }
  }
}

resource "oci_core_network_security_group_security_rule" "ingress_rules_udp" {
  for_each   = {for r in local.ingress_udp: "${r.nsg_name}-ingress-udp-dest_${r.dest_port.min}to${r.dest_port.max}" => r}
  depends_on = [ oci_core_network_security_group.this ]

  network_security_group_id = [for nsg in oci_core_network_security_group.this: nsg.id if nsg.display_name == each.value.nsg_name][0]
  direction                 = "INGRESS"
  protocol                  = "17" # UDP
  description               = "${each.value.src}-to-${each.value.nsg_name}-INGRESS-UDP-DEST(${each.value.dest_port.min}-${each.value.dest_port.max})"
  source_type               = each.value.src_type == "NSG" ? "NETWORK_SECURITY_GROUP" : "CIDR_BLOCK"
  source                    = each.value.src_type == "NSG" ? [for nsg in oci_core_network_security_group.this: nsg.id if nsg.display_name == each.value.src][0] : each.value.src
  stateless                 = each.value.stateless

  udp_options {
    destination_port_range {
      min = each.value.dest_port.min
      max = each.value.dest_port.max
    }
  }
}

resource "oci_core_network_security_group_security_rule" "egress_rules_udp" {
  for_each   = {for r in local.egress_udp: "${r.nsg_name}-egress-udp-dest_${r.dest_port.min}to${r.dest_port.max}" => r}
  depends_on = [ oci_core_network_security_group.this ]

  network_security_group_id = [for nsg in oci_core_network_security_group.this: nsg.id if nsg.display_name == each.value.nsg_name][0]
  direction                 = "EGRESS"
  protocol                  = "17" # UDP
  description               = "${each.value.nsg_name}-to-${each.value.dest}-EGRESS-UDP-DEST(${each.value.dest_port.min}-${each.value.dest_port.max})"
  destination_type          = each.value.dest_type == "NSG" ? "NETWORK_SECURITY_GROUP" : "CIDR_BLOCK"
  destination               = each.value.dest_type == "NSG" ? [for nsg in oci_core_network_security_group.this: nsg.id if nsg.display_name == each.value.dest][0] : each.value.dest
  stateless                 = each.value.stateless

  udp_options {
    destination_port_range {
      min = each.value.dest_port.min
      max = each.value.dest_port.max
    }
  }
}
