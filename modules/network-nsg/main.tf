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

locals {
  network_security_groups = [for k,v in var.network_security_groups: k]
}

resource "oci_core_network_security_group" "this" {
  count = length(local.network_security_groups)

  compartment_id = data.oci_identity_compartments.this.compartments[0].id
  vcn_id         = data.oci_core_vcns.this.virtual_networks[0].id
  display_name   = local.network_security_groups[count.index]
}

locals {
  ingress_all = flatten([
    for nsg_name, rules in var.network_security_groups: [
      for rule in rules: {
          nsg_name  = nsg_name
          src_type  = rule.src_type
          src       = rule.src
          stateless = rule.stateless
      } if rule.direction == "INGRESS" && rule.protocol == "ALL"
    ]
  ])

  egress_all = flatten([
    for nsg_name, rules in var.network_security_groups: [
      for rule in rules: {
          nsg_name  = nsg_name
          dest_type = rule.dest_type
          dest      = rule.dest
          stateless = rule.stateless
      } if rule.direction == "EGRESS" && rule.protocol == "ALL"
    ]
  ])

  ingress_tcp = flatten([
    for nsg_name, rules in var.network_security_groups: [
      for rule in rules: [
        for d in rule.dest_port: {
          nsg_name  = nsg_name
          src_type  = rule.src_type
          src       = rule.src
          dest_port = {min: d.min, max: d.max}
          stateless = rule.stateless
        }
      ] if rule.direction == "INGRESS" && rule.protocol == "TCP"
    ]
  ])

  egress_tcp = flatten([
    for nsg_name, rules in var.network_security_groups: [
      for rule in rules: [
        for d in rule.dest_port: {
          nsg_name  = nsg_name
          dest_type = rule.dest_type
          dest      = rule.dest
          dest_port = {min: d.min, max: d.max}
          stateless = rule.stateless
        }
      ] if rule.direction == "EGRESS" && rule.protocol == "TCP"
    ]
  ])

  ingress_udp = flatten([
    for nsg_name, rules in var.network_security_groups: [
      for rule in rules: [
        for d in rule.dest_port: {
          nsg_name  = nsg_name
          src_type  = rule.src_type
          src       = rule.src
          dest_port = {min: d.min, max: d.max}
          stateless = rule.stateless
        }
      ] if rule.direction == "INGRESS" && rule.protocol == "UDP"
    ]
  ])

  egress_udp = flatten([
    for nsg_name, rules in var.network_security_groups: [
      for rule in rules: [
        for d in rule.dest_port: {
          nsg_name  = nsg_name
          dest_type = rule.dest_type
          dest      = rule.dest
          dest_port = {min: d.min, max: d.max}
          stateless = rule.stateless
        }
      ] if rule.direction == "EGRESS" && rule.protocol == "UDP"
    ]
  ])

  icmp_all_type = flatten([
    for nsg_name, rules in var.network_security_groups: [
      for rule in rules: {
        nsg_name     = nsg_name
        direction    = rule.direction
        src_type     = rule.src_type
        src          = rule.src
        dest_type    = rule.dest_type
        dest         = rule.dest
        icmp_options = null
        stateless    = rule.stateless
      } if rule.protocol == "ICMP" && rule.icmp_options == null
    ]
  ])

  icmp_only_type = flatten([
    for nsg_name, rules in var.network_security_groups: [
      for rule in rules: [
        for i in rule.icmp_options: {
          nsg_name     = nsg_name
          direction    = rule.direction
          src_type     = rule.src_type
          src          = rule.src
          dest_type    = rule.dest_type
          dest         = rule.dest
          icmp_options = {type: i.type, code: null}
          stateless    = rule.stateless
        } if i.type != null && i.code == null
      ] if rule.protocol == "ICMP" && rule.icmp_options != null
    ]
  ])

  icmp_type_with_code = flatten([
    for nsg_name, rules in var.network_security_groups: [
      for rule in rules: [
        for i in rule.icmp_options: {
          nsg_name     = nsg_name
          direction    = rule.direction
          src_type     = rule.src_type
          src          = rule.src
          dest_type    = rule.dest_type
          dest         = rule.dest
          icmp_options = {type: i.type, code: i.code}
          stateless    = rule.stateless
        } if i.type != null && i.code != null
      ] if rule.protocol == "ICMP" && rule.icmp_options != null
    ]
  ])
}

resource "oci_core_network_security_group_security_rule" "ingress_rules_all" {
  for_each   = {for r in local.ingress_all: "${r.src}-to-${r.nsg_name}-ingress-all" => r}
  depends_on = [ oci_core_network_security_group.this ]

  network_security_group_id = [for nsg in oci_core_network_security_group.this: nsg.id if nsg.display_name == each.value.nsg_name][0]
  direction                 = "INGRESS"
  protocol                  = "all"
  description               = "[${each.value.src}]-to-[${each.value.nsg_name}]-INGRESS-ALL"
  source_type               = each.value.src_type == "NSG" ? "NETWORK_SECURITY_GROUP" : "CIDR_BLOCK"
  source                    = each.value.src_type == "NSG" ? [for nsg in oci_core_network_security_group.this: nsg.id if nsg.display_name == each.value.src][0] : each.value.src
  stateless                 = each.value.stateless
}

resource "oci_core_network_security_group_security_rule" "egress_rules_all" {
  for_each   = {for r in local.egress_all: "${r.nsg_name}-to-${r.dest}-egress-all" => r}
  depends_on = [ oci_core_network_security_group.this ]

  network_security_group_id = [for nsg in oci_core_network_security_group.this: nsg.id if nsg.display_name == each.value.nsg_name][0]
  direction                 = "EGRESS"
  protocol                  = "all"
  description               = "[${each.value.nsg_name}]-to-[${each.value.dest}]-EGRESS-ALL"
  destination_type          = each.value.dest_type == "NSG" ? "NETWORK_SECURITY_GROUP" : "CIDR_BLOCK"
  destination               = each.value.dest_type == "NSG" ? [for nsg in oci_core_network_security_group.this: nsg.id if nsg.display_name == each.value.dest][0] : each.value.dest
  stateless                 = each.value.stateless
}

resource "oci_core_network_security_group_security_rule" "ingress_rules_tcp" {
  for_each   = {for r in local.ingress_tcp: "${r.src}-to-${r.nsg_name}-ingress-tcp-dest_${r.dest_port.min}to${r.dest_port.max}" => r}
  depends_on = [ oci_core_network_security_group.this ]

  network_security_group_id = [for nsg in oci_core_network_security_group.this: nsg.id if nsg.display_name == each.value.nsg_name][0]
  direction                 = "INGRESS"
  protocol                  = "6" # TCP
  description               = "[${each.value.src}]-to-[${each.value.nsg_name}]-INGRESS-TCP-DEST(${each.value.dest_port.min}-${each.value.dest_port.max})"
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
  for_each   = {for r in local.egress_tcp: "${r.nsg_name}-to-${r.dest}-egress-tcp-dest_${r.dest_port.min}to${r.dest_port.max}" => r}
  depends_on = [ oci_core_network_security_group.this ]

  network_security_group_id = [for nsg in oci_core_network_security_group.this: nsg.id if nsg.display_name == each.value.nsg_name][0]
  direction                 = "EGRESS"
  protocol                  = "6" # TCP
  description               = "[${each.value.nsg_name}]-to-[${each.value.dest}]-EGRESS-TCP-DEST(${each.value.dest_port.min}-${each.value.dest_port.max})"
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
  for_each   = {for r in local.ingress_udp: "${r.src}-to-${r.nsg_name}-ingress-udp-dest_${r.dest_port.min}to${r.dest_port.max}" => r}
  depends_on = [ oci_core_network_security_group.this ]

  network_security_group_id = [for nsg in oci_core_network_security_group.this: nsg.id if nsg.display_name == each.value.nsg_name][0]
  direction                 = "INGRESS"
  protocol                  = "17" # UDP
  description               = "[${each.value.src}]-to-[${each.value.nsg_name}]-INGRESS-UDP-DEST(${each.value.dest_port.min}-${each.value.dest_port.max})"
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
  for_each   = {for r in local.egress_udp: "${r.nsg_name}-to-${r.dest}-egress-udp-dest_${r.dest_port.min}to${r.dest_port.max}" => r}
  depends_on = [ oci_core_network_security_group.this ]

  network_security_group_id = [for nsg in oci_core_network_security_group.this: nsg.id if nsg.display_name == each.value.nsg_name][0]
  direction                 = "EGRESS"
  protocol                  = "17" # UDP
  description               = "[${each.value.nsg_name}]-to-[${each.value.dest}]-EGRESS-UDP-DEST(${each.value.dest_port.min}-${each.value.dest_port.max})"
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

resource "oci_core_network_security_group_security_rule" "ingress_rules_icmp" {
  for_each   = {for r in local.icmp_all_type: "${r.src}-to-${r.nsg_name}-ingress-icmp-all" => r if r.direction == "INGRESS"}
  depends_on = [ oci_core_network_security_group.this ]

  network_security_group_id = [for nsg in oci_core_network_security_group.this: nsg.id if nsg.display_name == each.value.nsg_name][0]
  direction                 = "INGRESS"
  protocol                  = "1" # ICMP
  description               = "[${each.value.src}]-to-[${each.value.nsg_name}]-INGRESS-ICMP-ALL"
  source_type               = each.value.src_type == "NSG" ? "NETWORK_SECURITY_GROUP" : "CIDR_BLOCK"
  source                    = each.value.src_type == "NSG" ? [for nsg in oci_core_network_security_group.this: nsg.id if nsg.display_name == each.value.src][0] : each.value.src
  stateless                 = each.value.stateless
}

resource "oci_core_network_security_group_security_rule" "egress_rules_icmp" {
  for_each   = {for r in local.icmp_all_type: "${r.nsg_name}-to-${r.dest}-egress-icmp-all" => r if r.direction == "EGRESS"}
  depends_on = [ oci_core_network_security_group.this ]

  network_security_group_id = [for nsg in oci_core_network_security_group.this: nsg.id if nsg.display_name == each.value.nsg_name][0]
  direction                 = "EGRESS"
  protocol                  = "1" # ICMP
  description               = "[${each.value.nsg_name}]-to-[${each.value.dest}]-EGRESS-ICMP-ALL"
  destination_type          = each.value.dest_type == "NSG" ? "NETWORK_SECURITY_GROUP" : "CIDR_BLOCK"
  destination               = each.value.dest_type == "NSG" ? [for nsg in oci_core_network_security_group.this: nsg.id if nsg.display_name == each.value.dest][0] : each.value.dest
  stateless                 = each.value.stateless
}

resource "oci_core_network_security_group_security_rule" "ingress_rules_icmp_with_type" {
  for_each   = {for r in local.icmp_only_type: "${r.src}-to-${r.nsg_name}-ingress-icmp-type${r.icmp_options.type}" => r if r.direction == "INGRESS"}
  depends_on = [ oci_core_network_security_group.this ]

  network_security_group_id = [for nsg in oci_core_network_security_group.this: nsg.id if nsg.display_name == each.value.nsg_name][0]
  direction                 = "INGRESS"
  protocol                  = "1" # ICMP
  description               = "[${each.value.src}]-to-[${each.value.nsg_name}]-INGRESS-ICMP-type${each.value.icmp_options.type}"
  source_type               = each.value.src_type == "NSG" ? "NETWORK_SECURITY_GROUP" : "CIDR_BLOCK"
  source                    = each.value.src_type == "NSG" ? [for nsg in oci_core_network_security_group.this: nsg.id if nsg.display_name == each.value.src][0] : each.value.src
  stateless                 = each.value.stateless
  
  icmp_options {
    type = each.value.icmp_options.type
  }
}

resource "oci_core_network_security_group_security_rule" "egress_rules_icmp_with_type" {
  for_each   = {for r in local.icmp_only_type: "${r.nsg_name}-to-${r.dest}-egress-icmp-type${r.icmp_options.type}" => r if r.direction == "EGRESS"}
  depends_on = [ oci_core_network_security_group.this ]

  network_security_group_id = [for nsg in oci_core_network_security_group.this: nsg.id if nsg.display_name == each.value.nsg_name][0]
  direction                 = "EGRESS"
  protocol                  = "1" # ICMP
  description               = "[${each.value.nsg_name}]-to-[${each.value.dest}]-EGRESS-ICMP-type${each.value.icmp_options.type}"
  destination_type          = each.value.dest_type == "NSG" ? "NETWORK_SECURITY_GROUP" : "CIDR_BLOCK"
  destination               = each.value.dest_type == "NSG" ? [for nsg in oci_core_network_security_group.this: nsg.id if nsg.display_name == each.value.dest][0] : each.value.dest
  stateless                 = each.value.stateless

  icmp_options {
    type = each.value.icmp_options.type
  }
}

resource "oci_core_network_security_group_security_rule" "ingress_rules_icmp_with_type_and_code" {
  for_each   = {for r in local.icmp_type_with_code: "${r.src}-to-${r.nsg_name}-ingress-icmp-type${r.icmp_options.type}-code${r.icmp_options.code}" => r if r.direction == "INGRESS"}
  depends_on = [ oci_core_network_security_group.this ]

  network_security_group_id = [for nsg in oci_core_network_security_group.this: nsg.id if nsg.display_name == each.value.nsg_name][0]
  direction                 = "INGRESS"
  protocol                  = "1" # ICMP
  description               = "[${each.value.src}]-to-[${each.value.nsg_name}]-INGRESS-ICMP-type${each.value.icmp_options.type}-code${each.value.icmp_options.code}"
  source_type               = each.value.src_type == "NSG" ? "NETWORK_SECURITY_GROUP" : "CIDR_BLOCK"
  source                    = each.value.src_type == "NSG" ? [for nsg in oci_core_network_security_group.this: nsg.id if nsg.display_name == each.value.src][0] : each.value.src
  stateless                 = each.value.stateless
  
  icmp_options {
    type = each.value.icmp_options.type
    code = each.value.icmp_options.code
  }
}

resource "oci_core_network_security_group_security_rule" "egress_rules_icmp_with_type_and_code" {
  for_each   = {for r in local.icmp_type_with_code: "${r.nsg_name}-to-${r.dest}-egress-icmp-type${r.icmp_options.type}-code${r.icmp_options.code}" => r if r.direction == "EGRESS"}
  depends_on = [ oci_core_network_security_group.this ]

  network_security_group_id = [for nsg in oci_core_network_security_group.this: nsg.id if nsg.display_name == each.value.nsg_name][0]
  direction                 = "EGRESS"
  protocol                  = "1" # ICMP
  description               = "[${each.value.nsg_name}]-to-[${each.value.dest}]-EGRESS-ICMP-type${each.value.icmp_options.type}-code${each.value.icmp_options.code}"
  destination_type          = each.value.dest_type == "NSG" ? "NETWORK_SECURITY_GROUP" : "CIDR_BLOCK"
  destination               = each.value.dest_type == "NSG" ? [for nsg in oci_core_network_security_group.this: nsg.id if nsg.display_name == each.value.dest][0] : each.value.dest
  stateless                 = each.value.stateless

  icmp_options {
    type = each.value.icmp_options.type
    code = each.value.icmp_options.code
  }
}

